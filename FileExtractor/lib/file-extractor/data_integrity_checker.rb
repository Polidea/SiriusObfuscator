module FileExtractor

  class DataIntegrityChecker

    def self.verify_data_integrity(data)
      files_not_from_root = files_not_in_path(data.sourceFiles, data.project.rootPath) \
                          + files_not_in_path(data.layoutFiles, data.project.rootPath) 
      if files_not_from_root.empty?
        return true, nil
      else 
        return false, files_not_from_root.reduce("Found following files not under root path:") do |message, file|
          "#{message}\n#{file}" 
        end
      end
    end

    def self.files_not_in_path(filenames, path)
      filenames.select do |filename|
        !(filename.start_with?(path))
      end
    end

  end

end