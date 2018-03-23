module FileExtractor
  require 'colored2'
  require 'claide'

  require 'file-extractor/arguments_decorator'
  require 'file-extractor/configuration_determiner'
  require 'file-extractor/data_extractor'
  require 'file-extractor/dependency_builder'
  require 'file-extractor/xcodefiles_determiner'
  require 'file-extractor/xcworkspace_extractor'

  class Command < CLAide::Command

    self.command = 'file-extractor'
    self.description = 'FileExtractor processes the Xcode project file and generates Files.json file based on that.'

    PROJECTROOTPATH_KEY = "projectrootpath"
    FILESJSON_KEY = "filesjson"
    PROJECTFILEPATH_KEY = "projectfile"
    VERBOSE_KEY = "verbose"

    @file_extractor_options = [
      ["-#{PROJECTROOTPATH_KEY}", "Path to Xcode project root folder. "\
                        "It\'s the folder that contains both the Xcode project file (.xcodeproj or .xcworkspace) "\
                        "and the source files."\
                        "It\'s a required parameter."],
      ["-#{FILESJSON_KEY}", "Path to output files.json. It\'s an optional parameter."],
      ["-#{PROJECTFILEPATH_KEY}", "is a path to the Xcode project file. "\
                                  "It\'s an optional parameter and should be provided only "\
                                  "when the tool fails to automatically identify which project to parse."]
    ]

    @file_extractor_flags = [
      ["-#{VERBOSE_KEY}", "Print debug info."]
    ]

    def self.options
      default_claide_options = FileExtractor::ArgumentsDecorator.optionize(super)
      options = default_claide_options.select do |option| (option.first.include? "help") end
      options.concat(@file_extractor_options)
      options.concat(@file_extractor_flags)
      options
    end

    self.arguments = [
      CLAide::Argument.new("-#{PROJECTROOTPATH_KEY}", true),
      CLAide::Argument.new("PROJECTROOT", true),
      CLAide::Argument.new("-#{FILESJSON_KEY}", false),
      CLAide::Argument.new("FILESJSON", false),
      CLAide::Argument.new("-#{PROJECTFILEPATH_KEY}", false),
      CLAide::Argument.new("PROJECTFILE", false),
      CLAide::Argument.new("-#{VERBOSE_KEY}", false)
    ]

    def extract_option(argv, key)
      option = argv.option(key)
      if !option.nil?
        File.expand_path(option)
      else
        option
      end
    end

    def initialize(argv)
      @project_root_path = extract_option(argv, PROJECTROOTPATH_KEY)
      @files_path = extract_option(argv, FILESJSON_KEY)
      @project_file_path = extract_option(argv, PROJECTFILEPATH_KEY)
      # named `custom_verbose` to avoid collision with default CLAIde `verbose`
      @custom_verbose = argv.flag?(VERBOSE_KEY)
      super
    end
    
    def self.run(argv = [])
      argv = FileExtractor::ArgumentsDecorator.update_argv(argv, "--help", options)
      super
    end

    def run
      if @custom_verbose
        puts "Path to root:"
        puts @project_root_path
      end
      xcodeprojs, xcworkspaces = FileExtractor::XcodefilesDeterminer.find_xcode_files(@project_root_path)
      projects, schemes = FileExtractor::XcworkspaceExtractor.extract_projects_and_dependency_schemes(xcworkspaces, xcodeprojs)
      configuration_path = FileExtractor::ConfigurationDeterminer.find_configuration_file(@project_root_path)
      if projects.empty?
        puts "\n\nNo Xcode project document found in the project root directory"
      elsif projects.count == 1
        if @custom_verbose
          puts "Path to Xcode project:"
          puts xcodeprojs.first
          puts "Path to files:"
          puts @files_path
        end

        json, output_string, build_dir = FileExtractor::DataExtractor.extract_data(@project_root_path, xcodeprojs.first, @files_path, configuration_path, @custom_verbose)
        if @custom_verbose
          puts "\nFound data:\n#{json}"
          puts "\n#{output_string}"
        end
        
        FileExtractor::DependencyBuilder.build_dependencies(schemes, build_dir)
      elsif !@project_file_path.nil? 
        puts "Path to Xcode project:"
        puts @project_file_path
        puts "Path to files:"
        puts @files_path

        json, output_string, build_dir = FileExtractor::DataExtractor.extract_data(@project_root_path, xcodeprojs.first, @files_path, configuration_path, @custom_verbose)
        if @custom_verbose
          puts "\nFound data:\n#{json}"
          puts "\n#{output_string}"
        end

        if projects.include? @project_file_path
          FileExtractor::DependencyBuilder.build_dependencies(schemes, build_dir)
        end
      else
        puts "\n\nFound multiple possible Xcode project files:\n"
        projects.each do |path|
          puts path
        end
        puts "\nPlease specify which one to use with -#{PROJECTFILEPATH_KEY} flag\n"
      end
    end

  end
end
