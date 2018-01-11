module FileExtractor

  require 'xcodeproj'
  require 'file-extractor/files_json_struct'

  class XcodeprojExtractor

    def initialize(root_path, project_path)
      @root_path = root_path
      @project = Xcodeproj::Project.open(project_path)
    end

    def extract_data
      FileExtractor::FilesJson.new(
        FileExtractor::Project.new(@root_path),
        FileExtractor::Module.new(module_name),
        FileExtractor::Sdk.new(sdk, nil),
        filenames,
        explicitelyLinkedFrameworks,
        nil
      )
    end

    private

    def module_name
      @project.targets.to_a.select do |target| 
        target.instance_of? Xcodeproj::Project::Object::PBXNativeTarget
      end.first.name
    end

    def sdk
      # for now, the module name is the target name. ofc that's a non-generalizable assumption
      @project.targets.to_a.select do |target| 
        target.instance_of? Xcodeproj::Project::Object::PBXNativeTarget
      end.map do |target| 
        target.sdk
      end.first
    end

    def filenames 
      @project.targets.to_a.select do |target| 
        target.instance_of? Xcodeproj::Project::Object::PBXNativeTarget
      end.flat_map do |target|
        target.source_build_phase.files.to_a
      end.map do |pbx_build_file|
        pbx_build_file.file_ref.real_path.to_s
      end.select do |path|
        path.end_with?(".swift")
      end.select do |path|
        File.exists?(path)
      end.map do |path|
        File.expand_path(path)
      end
    end

    def explicitelyLinkedFrameworks 
      @project.targets.first.frameworks_build_phase.files.map do |framework|
        name = framework.file_ref.name
        path = framework.file_ref.real_path.to_s
        FileExtractor::ExplicitelyLinkedFramework.new(name.sub(".framework", ""), path.sub(name, ""))
      end
    end

  end

end