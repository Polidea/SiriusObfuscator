module FileExtractor

  class ModulesExtractor

    def self.system_linked_frameworks(data)
      explicitly_linked_frameworks_names = frameworks_names(data.explicitlyLinkedFrameworks)
      modules(data.sourceFiles, explicitly_linked_frameworks_names)
    end

    private 

    def self.frameworks_names(frameworks) 
      frameworks.map do |framework| 
        framework.name
      end
    end

    def self.modules(filenames, exclude_frameworks)
      filenames.flat_map do |file|
        %x{ xcrun swiftc -emit-imported-modules #{file} }.split("\n").reject(&:empty?)
      end.uniq.select do |framework|
        !(exclude_frameworks.include? framework)
      end
    end

  end

end