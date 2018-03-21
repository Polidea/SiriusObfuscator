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

    def extract_data_and_build_directory
      dir = @main_build_settings["BUILT_PRODUCTS_DIR"]
      return FileExtractor::FilesJson.new(
        FileExtractor::Project.new(@root_path, @project.path.to_s),
        FileExtractor::Module.new(module_name(@main_build_settings), triple(@main_build_settings)),
        FileExtractor::Sdk.new(sdk_name(@main_build_settings), sdk_path(@main_build_settings)),
        source_files(@main_target),
        layout_files(@main_target),
        update_frameworks_paths(explicitly_linked_frameworks(@main_target), @main_build_settings),
        nil, # for implicitely linked frameworks
        framework_search_paths(@main_build_settings),
        header_search_paths(@main_build_settings),
        nil, # for configuration file
        bridging_header(@main_build_settings)
      ), dir
    end

    private

    def module_name(build_settings)
      build_settings["PRODUCT_MODULE_NAME"]
    end

    def sdk_name(build_settings)
      build_settings["SDK_NAME"]
    end

    def sdk_path(build_settings)
      build_settings["SDKROOT"]
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
        name = framework.display_name
        path = framework.file_ref.real_path.to_s
        FileExtractor::ExplicitlyLinkedFramework.new(name.sub(".framework", ""), path.sub(name, ""))
      end
    end

    def update_frameworks_paths(frameworks, build_settings)
      frameworks.map do |framework|
        framework.path = framework.path.sub("${SDKROOT}", build_settings["SDKROOT"])
        framework.path = framework.path.sub("${BUILT_PRODUCTS_DIR}", build_settings["BUILT_PRODUCTS_DIR"])
        framework
      end
    end

    def cleanup_search_paths(search_paths) 
      framework_search_paths = []
      if !search_paths.nil?
        framework_search_paths = search_paths.split("\"").map do |path_to_clean|
          path_to_clean.sub(/^\"/, '').strip
        end.select do |path|
          !path.empty?
        end
      end
      framework_search_paths
    end

    def framework_search_paths(build_settings)
      search_paths = build_settings["FRAMEWORK_SEARCH_PATHS"]
      cleanup_search_paths(search_paths)
    end

    def header_search_paths(build_settings)
      search_paths = build_settings["HEADER_SEARCH_PATHS"]
      cleanup_search_paths(search_paths)
    end

    def bridging_header(build_settings)
      source_root = build_settings["SOURCE_ROOT"]
      if source_root.nil?
        return ""
      end
      header = build_settings["SWIFT_OBJC_BRIDGING_HEADER"]
      if header.nil?
        return ""
      end
      source_root + "/" + header
    end

    def triple(build_settings)
      architecture = build_settings["PLATFORM_PREFERRED_ARCH"]
      if architecture.nil?
        architecture = build_settings["CURRENT_ARCH"]
      end
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