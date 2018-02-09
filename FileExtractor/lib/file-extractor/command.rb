module FileExtractor
  require 'colored2'
  require 'claide'

  require 'file-extractor/arguments_decorator'
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

    def self.options
      all_options = @file_extractor_options + FileExtractor::ArgumentsDecorator.optionize(super)
      all_options.select do |option| !(option.first.include? "no-ansi") end
    end

    self.arguments = [
      CLAide::Argument.new("-#{PROJECTROOTPATH_KEY}", true),
      CLAide::Argument.new("PROJECTROOT", true),
      CLAide::Argument.new("-#{FILESJSON_KEY}", false),
      CLAide::Argument.new("FILESJSON", false),
      CLAide::Argument.new("-#{PROJECTFILEPATH_KEY}", false),
      CLAide::Argument.new("PROJECTFILE", false)
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
      super
    end
    
    def self.run(argv = [])
      argv = FileExtractor::ArgumentsDecorator.update_argv(argv, "--help", options)
      super
    end

    def run
      puts "Path to root:"
      puts @project_root_path
      xcodeprojs, xcworkspaces = FileExtractor::XcodefilesDeterminer.find_xcode_files(@project_root_path)
      projects, schemes = FileExtractor::XcworkspaceExtractor.extract_projects_and_dependency_schemes(xcworkspaces, xcodeprojs)
      if projects.empty?
        puts "\n\nNo Xcode project document found in the project root directory"
      elsif projects.count == 1
        puts "Path to Xcode project:"
        puts xcodeprojs.first
        puts "Path to files:"
        puts @files_path

        json, output_string, build_dir = FileExtractor::DataExtractor.extract_data(@project_root_path, xcodeprojs.first, @files_path)
        puts "\nFound data:\n#{json}"
        puts "\n#{output_string}"
        
        FileExtractor::DependencyBuilder.build_dependencies(schemes, build_dir)
      elsif !@project_file_path.nil? 
        puts "Path to Xcode project:"
        puts @project_file_path
        puts "Path to files:"
        puts @files_path

        json, output_string, build_dir = FileExtractor::DataExtractor.extract_data(@project_root_path, xcodeprojs.first, @files_path)
        puts "\nFound data:\n#{json}"
        puts "\n#{output_string}"

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
