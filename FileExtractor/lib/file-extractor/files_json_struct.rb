module FileExtractor

  require 'json'

  module StructSerialization
    def to_json(options = {})
      to_h.to_json(options)
    end
  end

  Project = Struct.new(:rootPath) do
    include StructSerialization
  end

  Module = Struct.new(:name) do
    include StructSerialization
  end

  Sdk = Struct.new(:name, :path) do
    include StructSerialization
  end

  ExplicitelyLinkedFramework = Struct.new(:name, :path) do
    include StructSerialization
  end
  
  FilesJson = Struct.new(:project, :module, :sdk, :filenames, :explicitelyLinkedFrameworks, :systemLinkedFrameworks) do
    include StructSerialization

    def to_h
      hash = super.to_h
      hash[:module] = self.module.to_h
      hash[:sdk] = self.sdk.to_h
      hash[:explicitelyLinkedFrameworks] = self.explicitelyLinkedFrameworks.map do |framework| framework.to_h end
      hash
    end
  end

end