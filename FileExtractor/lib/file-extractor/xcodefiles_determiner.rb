module FileExtractor

  require 'find'

  class XcodefilesDeterminer

    XCODE_PROJECT_FORMAT = ".xcodeproj"
    XCWORKSPACE_FORMAT = ".xcworkspace"
    XCODE_FILE_FORMATS = [XCODE_PROJECT_FORMAT, XCWORKSPACE_FORMAT]

    def self.find_xcode_files(path)
      xcodeprojs = find_xcode_files_of_type(path, XCODE_PROJECT_FORMAT)
      xcworkspaces = find_xcode_files_of_type(path, XCWORKSPACE_FORMAT)
      return xcodeprojs, xcworkspaces
    end

    private 

    def self.find_xcode_files_of_type(path, type)
      Find.find(path).select do |path| 
        check_if_path_has_extension(path, type)
      end.each do |path|
        File.expand_path(path)
      end
    end

    def self.check_if_path_has_extension(path, extension)
      extension == File.extname(path) && check_if_is_not_subfile(path)
    end

    def self.check_if_is_not_subfile(file)
      XCODE_FILE_FORMATS.select do |extension| 
        File.dirname(file).include?(extension)
      end.empty?
    end

  end

end