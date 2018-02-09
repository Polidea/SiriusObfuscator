module FileExtractor

  require 'json'

  module StructSerialization
    def to_json(options = {})
      to_h.to_json(options)
    end
  end

  Project = Struct.new(:rootPath, :projectFilePath) do
    include StructSerialization
  end

  Module = Struct.new(:name, :triple) do
    include StructSerialization
  end

  Sdk = Struct.new(:name, :path) do
    include StructSerialization
  end

  ExplicitlyLinkedFramework = Struct.new(:name, :path) do
    include StructSerialization
  end
  
  FilesJson = Struct.new(:project, 
                         :module, 
                         :sdk, 
                         :sourceFiles, 
                         :layoutFiles, 
                         :explicitlyLinkedFrameworks, 
                         :implicitlyLinkedFrameworks, 
                         :frameworkSearchPaths) do
    include StructSerialization

    def to_h
      hash = super.to_h
      hash[:module] = self.module.to_h
      hash[:sdk] = self.sdk.to_h
      hash[:explicitlyLinkedFrameworks] = self.explicitlyLinkedFrameworks.map do |framework| framework.to_h end
      hash
    end
  end

end