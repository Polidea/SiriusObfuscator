module FileExtractor
  require 'colored2'
  require 'claide'

  require 'file-extractor/arguments_decorator'
  require 'file-extractor/xcodeproj_determiner'
  require 'file-extractor/data_extractor'

  class Command < CLAide::Command

    self.command = 'file-extractor'
    self.description = 'FileExtractor processes the Xcode project file and generates Files.json file based on that.'

    PROJECTROOTPATH_KEY = "projectrootpath"
    FILESJSON_KEY = "filesjson"

    @file_extractor_options = [
      ["-#{PROJECTROOTPATH_KEY}", "Path to Xcode project root folder. "\
                        "It\'s the folder that contains both the Xcode project file (.xcodeproj or .xcworkspace) "\
                        "and the source files."\
                        "It\'s a required parameter."],
      ["-#{FILESJSON_KEY}", "Path to output files.json. It\'s an optional parameter."]
    ]

    def self.options
      all_options = @file_extractor_options + FileExtractor::ArgumentsDecorator.optionize(super)
      all_options.select do |option| !(option.first.include? "no-ansi") end
    end

    self.arguments = [
      CLAide::Argument.new("-#{PROJECTROOTPATH_KEY}", true),
      CLAide::Argument.new("PROJECTROOT", true),
      CLAide::Argument.new("-#{FILESJSON_KEY}", false),
      CLAide::Argument.new("FILESJSON", false)
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
      super
    end
    
    def self.run(argv = [])
      argv = FileExtractor::ArgumentsDecorator.update_argv(argv, "--help", options)
      super
    end

    def run
      puts "Path to root:"
      puts @project_root_path
      project_paths = FileExtractor::XcodeprojDeterminer.find_xcode_files(@project_root_path)
      if project_paths.empty?
        puts "\n\nNo Xcode project document found in the project root directory"
      elsif project_paths.count == 1
        puts "Path to Xcode project:"
        puts project_paths.first
        puts "Path to files:"
        puts @files_path

        json, output_string = FileExtractor::DataExtractor.extract_data(@project_root_path, project_paths.first, @files_path)
        puts "\nFound data:\n#{json}"
        puts "\n#{output_string}"
      else 
        puts "\n\nFound multiple possible Xcode project files:\n"
        project_paths.each do |path|
          puts path
        end
      end
    end
  end
end
