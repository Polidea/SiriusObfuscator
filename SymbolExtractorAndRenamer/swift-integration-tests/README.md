Swift Package Tests
===================

Automated tests for validating the generated Swift snapshots behave correctly.

Usage
-----

You are expected to check this repository out as a peer of "llvm" in the
swift-project.

Run the tests using:

    sh ./litTest -sv --param package-path=/path/to/downloadable-package .

where the path is the unarchived package root path.

Tests
-----

Here is a partial list of tests in the repository:

| Test Name                | Functionality                                                    |
|--------------------------|------------------------------------------------------------------|
| basic                    | Check output of `swift --version`                                |
| example-package-dealer   | Build the example package-dealer package                         |
| repl                     | Various REPL sanity checks, notably importing Darwin and Glibc   |
| swift-build-self-host    | Use swift build to build itself                                  |
| swift-compiler           | Compile a basic swift file                                       |
| test-c-library-swiftpm   | Build a package that links a 3rd party library                   |
| test-foundation-package  | Build a package that imports Foundation                          |
| test-import-glibc        | Compile a source file importing and using Glibc                  |
| test-multi-compile       | Compile multiple source files into an executable                 |
| test-multi-compile-glibc | Compile multiple source files importing Glibc into an executable |
| test-static-lib          | Compile multiple source files into a static library              |
| test-xctest-package      | Build a package that imports XCTest                              |

