module FileExtractor

  require 'open3'

  class DependencyBuilder

    def self.build_dependencies(schemes, build_dir)
      schemes.each do |scheme|
        puts "\nBuilding dependencies using command:\n"
        build_dir = clean_build_directory(build_dir)
        clean_command = "xcodebuild -workspace \"#{scheme[:workspace]}\" -scheme \"#{scheme[:scheme]}\" -derivedDataPath \"#{build_dir}\" clean"
        build_command = "xcodebuild -workspace \"#{scheme[:workspace]}\" -scheme \"#{scheme[:scheme]}\" -derivedDataPath \"#{build_dir}\""
        puts clean_command
        puts build_command
        Open3.capture3(clean_command)
        stdout, stderr, status = Open3.capture3(build_command)
        if status.success?
          puts "\nBuilding dependencies finished successfully\n"
        else
          puts "\nError while building dependencies, here come the logs\n\n"
          puts "\nstdout:\n\n"
          puts stdout
          puts "\nstderr:\n\n"
          puts stderr
        end
      end
    end

    def self.clean_build_directory(build_dir)
      # TODO: should we pass the configuration names from build settings here instead of "Debug" and "Release"?
      paths_to_remove = ["Build", "Products", "Debug", "Release"]
      dirs = build_dir.split(File::SEPARATOR)
      while dirs.last.start_with?(*paths_to_remove)
        dirs.pop
      end
      File.expand_path(dirs.join(File::SEPARATOR))
    end

  end

end