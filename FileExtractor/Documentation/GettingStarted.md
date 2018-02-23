# Getting started with FileExtractor project

This document presents how to start developing in the File Extractor project. It aims at answering following questions:

1. [What are main components of FileExtractor?](#components)
2. [What is the FileExtractor architecture?](#architecture)
3. [What are the dependencies?](#dependencies)
4. [Where to find particular functionalities?](#where)
5. [How is FileExtractor distributed?](#distribution)

The basic idea behind the FileExtractor is to be the interface between Xcode build system configuration and Swift compiler. It consumes the Xcode project files such as `.xcodeproj` and `.xcworkspace`, finds all the source files that should be obfuscated, identifies the build configuration, dependencies that should be linked and other metadata, and writes it down in the `Files.json` file.

# <a name="components"></a> FileExtractor components

The FileExtractor composes of two parts: Swift launcher and Ruby tool.

The launcher is a Swift command line tool responsible for launching the FileExtractor Ruby code. Its sources are in the `packaging` directory. It contains the `Package.swift` file for dependencies and build instructions and `Sources` directory for the actual code.

The actual tool is written in Ruby. It also composes of two parts: the launcher and the code providing the functionalities. The Ruby launcher (separate from the Swift launcher) is in `bin` directory. The actual functionalities for the tool are in the `lib` directory.

Why do we need two launchers? Because they're meeting different needs:

* the Swift launcher is responsible for executing the Ruby launcher with the proper Ruby interpreter. After the project is build to its distribution form, it takes the path to `lib/ruby/bin` Travelling Ruby 2.2.2 interpreter and executed the Ruby launcher with it. Please consult [distribution](#distribution) section for more details.

* the Ruby launcher is responsible for properly linking the dependencies to the actual tool. It detects whether it's used in the development or distribution environment and sets the paths to dependencies accordingly. Then it executes the actual tool passing all the command-line arguments to it.

The actual tool from the `lib` directory consists of the `file-extractor.rb` file that imports the command line parsing. The command-line parsing from `lib/file-extractor/command.rb` is the starting point for the tool.

# <a name="architecture"></a> Architecture

Launchers, both Swift one and Ruby one, are best thought of as the part of infrastructure. Therefore when writing about the tool architecture I think of the architecture of code in the `lib/file-extractor` directory.

The architecture is a simple command-line driven app that parses the execution similarly to the way that the http server would parse a request:

1. The starting point is in `lib/file-extractor/command.rb` file which checks whether the executions is valid (has all the required parameters). The most important parameter is the path under which we should expect the Xcode project.

2. The second step is to identify and recognize the Xcode project files in the provided directory. If the project is in one of the supported configurations, such as the single-xcodeproj one or the Cocoapods one, then all the required data for further analysis (such as paths to the Xcode project files) is extracted. It's the responsibility of `XcodefilesDeterminer` from `lib/file-extractor/xcodefiles_determiner.rb` and `XcworkspaceExtractor` from `lib/file-extractor/xcworkspace_extractor.rb`. 

3. The third step is to gather all the data required for the semantic analysis in the compiler tools. The `DataExtractor` from `lib/file-extractor/data_extractor.rb` is used for that. It internally calls two additional tools: `XcodeprojExtractor` from `lib/file-extractor/xcodeproj_extractor.rb` and `ModulesExtractor` from `lib/file-extractor/modules_extractor.rb`.  
   * `XcodeprojExtractor` is responsible for extracting the information from the `xcodeproj` file. It uses `xcodebuild` to get all the default `Xcode` settings and `Cocoapods/Xcodeproj` to get the information from the actual file. 
   * `ModulesExtractor` is responsible for finding all the modules that are imported in the Swift source files that should be obfuscated. It uses `swiftc` for that.

4. After all the data is being gathered, `DataExtractor` ensures it's consistent with the requirements of Swift compiler tools. The class responsible for the check is called `DataIntegrityChecker` from `lib/file-extractor/data_integrity_checker.rb`. If it determines that the data is not consistent, it causes the abort with error message. Otherwise the data is written to the terminal output and to file.

5. If the data is consistent, the final step is to build all the required dependencies (if any were identified in the second on third step). The class responsible for it is called `DependencyBuilder` from `lib/file-extractor/dependency_builder.rb`.

# <a name="dependencies"></a> Dependencies

There are four types of dependencies in the FileExtractor tool:

1. Swift launcher dependencies are the Swift libraries responsible for helping with parsing the command-line arguments and launching the Ruby tool. These dependencies are written in `packaging/Package.swift`.

2. Ruby tool has Ruby dependencies (gems) for easier command-line management and Xcode project files parsing. They are defined in `Gemfile`. There are two groups: the production ones (actually used in the production code) and the development ones, used in the development to run tests, build and package the tool etc.

3. Ruby tool has also some implicit external dependencies. It expects that in the user's terminal PATH there'll be a number of tools available. They are:  
   * `xcodebuild`  
   * `xcrun`  
   * `swiftc`  
   These are all parts of Xcode command-line tools, so as long as the usual Xcode installation is available, it's path properly set via `xcode-select` and the command-line tools installed (you can do that by `xcode-select --install`), everything will be provided.

4. Building and packaging has it's own set of dependencies. For the actual building we use `rake` which is defined as part of Ruby dependencies in the `Gemfile`. To use the proper version of dependencies, however, we need to ensure that the proper version of Ruby is used for building. We use [`rbenv`](https://github.com/rbenv/rbenv) for that. After the project if build with proper dependencies, we must ensure it's also run with the prover Ruby version. We don't want to put any restrictions on the user's machine setup, so we're using [Travelling Ruby](http://phusion.github.io/traveling-ruby/) to provide our own Ruby interpreter.

# <a name="where"></a> Where to look for when I want to write / change some functionality?

1. Paths  
   Please consult Swift launcher at `packaging/Sources/file-extractor/main.swift` and Ruby launcher at `bin/file-extractor`.

2. Building and distribution  
   Please change the `Rakefile`.

3. Tests  
   Please write them in the `spec` directory.

4. Command-line interface  
   It's defined by `lib/file-extractor/command.rb` file. It uses `CLAide` gem to build command-line iterface. There is an additional class called `ArgumentsDecorator` that helps to provide the same interface style as LLVM command line conventions.

5. Project structure identification  
   Please see `lib/file-extractor/xcodefiles_determiner.rb` and `lib/file-extractor/xcworkspace_extractor.rb`. The latter uses the `Xcodeproj` gem for parsing the workspace file.

6. Data extraction  
   Please see `lib/file-extractor/data_extractor.rb` for that. It uses `lib/file-extractor/xcodeproj_extractor.rb` for extracting data from Xcode project file and `lib/file-extractor/modules_extractor.rb` to extract additional data from Swift source code files. They use the `Xcodeproj` gem, `xcodebuild`, `xcrun` and `swiftc` as dependencies.

7. Json file format  
   Please see `lib/file-extractor/files_json_struct.rb`. The structs defined there are used by data extraction classes to store all the required information.

8. Data verification  
   Please see `lib/file-extractor/data_integrity_checker.rb` for that.

9. Dependency building  
   Please consult `lib/file-extractor/dependency_builder.rb`.

# <a name="distribution"></a> Distribution

The tool, while being written mainly in Ruby, is being distributed in a way that should not impose any restrictions on the user. They might have even no Ruby installed on their machine. To achive it, the distribution script is written in the `Rakefile`. It creates either a directory (with option `DIR_ONLY=1`) of name `file-extractor-1.0.0-osx` with the distribution version of the tool or the archive `file-extractor-1.0.0-osx.tar.gz` for distribution. It contains all the dependencies in the right version (compatible with Ruby 2.2.2), the built Swift launcher, the Ruby interpreter from Travelling Ruby.
