module FileExtractor

  require 'file-extractor/files_json_struct'
  require 'file-extractor/xcodeproj_extractor'
  require 'file-extractor/modules_extractor'
  require 'file-extractor/data_integrity_checker'

  class DataExtractor

    def self.extract_data(root_path, project_path, files_path)      
      data, build_dir = extract_data_from_all_sources(root_path, project_path)
      data_is_ok, error_message = FileExtractor::DataIntegrityChecker.verify_data_integrity(data)
      json = JSON.pretty_generate(data)
      if data_is_ok 
        return json, write_json_to_file(json, files_path), build_dir
      else
        return json, error_message, build_dir
      end
    end

    private

    def self.extract_data_from_all_sources(root_path, project_path)
      data_extractor = FileExtractor::XcodeprojExtractor.new(root_path, project_path)
      data, build_dir = data_extractor.extract_data_and_build_directory
      data.implicitlyLinkedFrameworks = FileExtractor::ModulesExtractor.system_linked_frameworks(data)
      return data, build_dir
    end

    def self.write_json_to_file(json, files_path)
      if files_path.nil?
        "No output file given, so no data was written"
      else
        File.open("#{files_path}","w") do |file|
          file.write(json)
        end
        "Data written to:\n#{files_path}"
      end
    end

  end

end