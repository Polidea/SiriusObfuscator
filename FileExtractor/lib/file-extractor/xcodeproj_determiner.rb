module FileExtractor

  require 'find'

  class XcodeprojDeterminer

    XCODE_PROJECT_FORMATS = [".xcodeproj", ".xcworkspace"]

    def self.find_xcode_files(path)
      Find.find(path).select do |file| 
        check_if_path_is_to_xcode_project(file)
      end.each do |path|
        File.expand_path(path)
      end
    end

    private 

    def self.check_if_path_is_to_xcode_project(file)
      XCODE_PROJECT_FORMATS.include?(File.extname(file)) && check_if_is_not_subfile_of_xcode_project(file)
    end

    def self.check_if_is_not_subfile_of_xcode_project(file)
      XCODE_PROJECT_FORMATS.select do |extension| 
        File.dirname(file).include?(extension)
      end.empty?
    end

  end

end