module FileExtractor

  require 'find'

  class ConfigurationDeterminer

    CONFIGURATION_FILES = [".obfuscation.yaml", ".obfuscation.yml", "obfuscation.yaml", "obfuscation.yml"]

    def self.find_configuration_file(path)
      configuration_path = find_configuration_files(path, CONFIGURATION_FILES).first
      if configuration_path.nil?
        return ""
      end
      return configuration_path
    end

    private 

    def self.find_configuration_files(path, types)
      Find.find(path).select do |path| 
        types.include?(File.basename(path)) 
      end.each do |path|
        File.expand_path(path)
      end
    end

  end

end