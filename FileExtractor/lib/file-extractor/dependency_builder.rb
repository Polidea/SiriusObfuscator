module FileExtractor

  require 'open3'
  require 'file-extractor/carthage_determiner'

  class DependencyBuilder

    def self.build_dependencies(schemes, build_dir, cartfile_dir, verbose)

      if cartfile_dir
        found_cartfile_resolved = FileExtractor::CarthageDeterminer.directory_contains_cartfile_resolved(cartfile_dir)
        if found_cartfile_resolved
          carthage_bootstrap_command = "carthage bootstrap"
          if verbose
            puts "\nFound Cartfile.resolved"
            puts "Building Carthage dependencies using command:"
            puts carthage_bootstrap_command
          end
          Dir.chdir(cartfile_dir) {
            stdout, stderr, status = Open3.capture3(carthage_bootstrap_command)
            if !status.success?
              puts "\nError while building Carthage dependencies, here come the logs\n\n"
              puts "\nstdout:\n\n"
              puts stdout
              puts "\nstderr:\n\n"
              puts stderr
            elsif verbose
              puts stdout
              puts "\nBuilding Carthage dependencies finished successfully"
            end
          }
        else
          puts "\nFailed to bootstrap Carthage dependecies: Cartfile.resolved is missing."
        end        
      end

      schemes.each do |scheme|
        if verbose
          puts "\nBuilding Cocoapods dependencies using command:\n"
        end
        build_dir = clean_build_directory(build_dir)
        clean_command = "xcodebuild -workspace \"#{scheme[:workspace]}\" -scheme \"#{scheme[:scheme]}\" -derivedDataPath \"#{build_dir}\" clean"
        build_command = "xcodebuild -workspace \"#{scheme[:workspace]}\" -scheme \"#{scheme[:scheme]}\" -derivedDataPath \"#{build_dir}\""
        if verbose
          puts clean_command
          puts build_command
        end
        Open3.capture3(clean_command)
        stdout, stderr, status = Open3.capture3(build_command)
        if !status.success?
          puts "\nError while building dependencies, here come the logs\n\n"
          puts "\nstdout:\n\n"
          puts stdout
          puts "\nstderr:\n\n"
          puts stderr
        elsif verbose
          puts "\nBuilding Cocoapods dependencies finished successfully\n"
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