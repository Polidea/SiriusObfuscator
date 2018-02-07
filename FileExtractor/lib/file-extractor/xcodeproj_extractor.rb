module FileExtractor

  require 'xcodeproj'
  require 'file-extractor/files_json_struct'

  class XcodeprojExtractor

    def initialize(root_path, project_path)
      @root_path = root_path
      @project = Xcodeproj::Project.open(project_path)
      @all_targets = @project.targets.to_a.select do |target| 
        target.instance_of? Xcodeproj::Project::Object::PBXNativeTarget
      end
      @main_target = @all_targets.first
      @main_build_settings = build_settings(@main_target)
    end

    def extract_data
      FileExtractor::FilesJson.new(
        FileExtractor::Project.new(@root_path, @project.path.to_s),
        FileExtractor::Module.new(module_name(@main_target), triple(@main_build_settings)),
        FileExtractor::Sdk.new(sdk(@main_target), nil),
        source_files(@main_target),
        layout_files(@main_target),
        explicitly_linked_frameworks(@main_target),
        nil
      )
    end

    private

    def module_name(target)
      target.name
    end

    def sdk(target)
      target.sdk
    end

    def source_files(target)
      filepaths(target.source_build_phase.files, ".swift")
    end

    def layout_files(target)
      filepaths(target.resources_build_phase.files, ".storyboard", ".xib")
    end

    def filepaths(file_references, *extensions)
      file_references.to_a.flat_map do |pbx_build_file|
        if pbx_build_file.file_ref.instance_of? Xcodeproj::Project::Object::PBXFileReference
          [pbx_build_file.file_ref.real_path.to_s]
        elsif pbx_build_file.file_ref.instance_of? Xcodeproj::Project::Object::PBXVariantGroup
          pbx_build_file.file_ref.files.map do |file_ref|
            file_ref.real_path.to_s
          end  
        end
      end.select do |path|
        !path.nil? && path.end_with?(*extensions)
      end.select do |path|
        File.exists?(path)
      end.map do |path|
        File.expand_path(path)
      end
    end

    def explicitly_linked_frameworks(target)
      target.frameworks_build_phase.files.map do |framework|
        name = framework.file_ref.name
        path = framework.file_ref.real_path.to_s
        FileExtractor::ExplicitlyLinkedFramework.new(name.sub(".framework", ""), path.sub(name, ""))
      end
    end

    def triple(build_settings)
      architecture = build_settings["CURRENT_ARCH"]
      sdk = case build_settings["PLATFORM_NAME"]
        when "iphoneos"
          build_settings["SDK_NAME"].gsub("iphoneos", "ios")
        when "iphonesimulator"
          build_settings["SDK_NAME"].gsub("iphonesimulator", "ios")
        when "appletvos"
          build_settings["SDK_NAME"].gsub("apple", "")
        when "appletvsimulator"
          build_settings["SDK_NAME"].gsub("appletvsimulator", "tvos")
        when "watchsimulator"
          build_settings["SDK_NAME"].gsub("simulator", "os")
        else
          build_settings["SDK_NAME"]
        end
      "#{architecture}-apple-#{sdk}"
    end

    def build_settings(target)
      %x{ xcodebuild -project "#{@project.path.expand_path.to_s}" -target "#{target.name}" -showBuildSettings }
        .split("\n")
        .map do |setting|
          setting.strip.split("=")
        end.select do |splitted|
          splitted.size == 2
        end.map do |splitted|
          splitted.map do |token|
            token.strip
          end
        end.to_h
    end

  end

end