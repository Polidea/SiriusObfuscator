# Getting Started Guide

Use this guide to get started with SymbolExtractorAndRenamer development. You can find answers to following questions:

1. [What the purpose of SymbolExtractorAndRenamer?](#purpose)
2. [What are the main components of SymbolExtractorAndRenamer](#components)
3. [How to build and run SymbolExtractorAndRenamer tools using Xcode](#buid_and_run)
4. [Where to find particular functionalities?](#functionalities)
5. [How to add new files and components?](#adding)

# <a name="purpose"></a> Purpose

SymbolExtractorAndRenamer is the main component of the Obfuscator infrastructure. It performs the symbols renaming of files provided in Xcode project using the `files.json` produced by FileExtractor. It copies the original project and performs the renaming on its symbols. The basic steps of the process are:

1. Performing semantic analysis of files listed in `files.json` and collecting the symbols for renaming. Those symbols are saved to `symbols.json`.
2. Generating the proposed renames for symbols and saving them to `renames.json`
3. Creating the copy of the project that is being obfuscated and performing the symbol renaming on the project copy.

# <a name="components"></a> Components

The repo is the fork of Swift Compiler's branch: [`swift-4.0-branch`](https://github.com/apple/swift/tree/swift-4.0-branch). To allow supporting other Swift versions in future, the SymbolExtractorAndRenamer repository consists of additive-only changes to Swift Compiler.

The main components of SymbolExtractorAndRenamer are tools and library organized in similar manner as existing Swift Compiler tools and libraries:

SymbolExtractorAndRenamer tools:

* `obfuscator-symbol-extractor` collects the symbols that needs to be renamed.
* `obfuscator-name-mapper` generates the proposed renames for symbols.
* `obfuscator-renamer` performs the renaming.

These tools are being build to executables that are being executed by ObfuscatorTool. The executions perform the three basic steps of SymbolExtractorAndRenamer.

Under the hood, the tool components serve mainly as command line arguments parsers. All main logic of SymbolExtractorAndRenamer is placed in the library shared by above tools. The library is named `swiftObfuscation` and it serves tasks such as:

  * performing semantic analysis using `swiftFrontend` tools and creating AST tree.
  * extracting the symbols from the AST tree.
  * generating renames.
  * performing the renaming.

# <a name="buid_and_run"></a> Building and Running Using Xcode

To build each SymbolExtractorAndRenamer tool:

1. Perform the steps in _Build notes for developers_ in [README](../README.md)
2. Open the generated Xcode project:
`open build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64/Swift.xcodeproj`
3. Add scheme for each SymbolExtractorAndRenamer target (`obfuscator-symbol-extractor`, `obfuscator-name-mapper`,  `obfuscator-renamer`,  `swiftObfuscation`) by selecting `Product > Scheme > New Scheme...` and choosing one of the above targets from the long dropdown list.
4. Build each Obfuscator tool and library by choosing its scheme from list in `Product > Scheme` and selecting `Product > Build`.

To run each SymbolExtractorAndRenamer tool, you can either:

a) call its executable from command line:
```bash
$ obfuscator-symbol-extractor -filesjson <path-to-input-files-json> -symbolsjson <path-to-output-symbols-json>
```
```bash
$ obfuscator-name-mapper -symbolsjson <path-to-input-symbols-file> -renamesjson <path-to-output-renames-file>
```
```bash
$ obfuscator-renamer -filesjson <path-to-input-files-json-file> -renamesjson <path-to-input-renames-json-file> -obfuscatedproject <path-to-directory-for-obfuscated-project>
```

b) or execute it using Xcode scheme. You need to provide scheme executable arguments by selecting `Product > Scheme > Edit Scheme... > Run > Arguments` and tapping `+` under `Arguments Passed On Launch`.

Executable arguments and data formats are described in [README](../README.md).

# <a name="functionalities"></a> Source files overview
When modifying or adding functionalities refer to this overview of source files in each SymbolExtractorAndRenamer tool/library component.

## `obfuscator-symbol-extractor`
`obfuscator-symbol-extractor` sources can be found in `swift/tools/obfuscator-symbol-extractor/`:

* `obfuscator-symbol-extractor.cpp` parses the command line arguments and use `swiftObfuscation` library to parse `files.json` and extract symbols meant to be renamed from the files listed in `files.json`. The symbols are saved to `symbols.json`
* `CMakeLists.txt` cmake build file

## `obfuscator-name-mapper`
`obfuscator-name-mapper` sources can be found in `swift/tools/obfuscator-name-mapper/`:

* `obfuscator-name-mapper.cpp` parses the command line arguments and use `swiftObfuscation` library to parse `symbols.json` and generate mapping of original symbol names to proposed renames and save it to `renames.json`.
* `CMakeLists.txt` cmake build file

## `obfuscator-renamer`
`obfuscator-renamer` sources can be found in `swift/tools/obfuscator-renamer/`:

* `obfuscator-renamer.cpp` parses the command line arguments and use `swiftObfuscation` library to parse `renames.json` and perform actual renaming.
* `CMakeLists.txt` cmake build file

## `swiftObfuscation`
`swiftObfuscation` header files can be found in `swift/include/swift/Obfuscation/`, its implementations are in:  `swift/lib/Obfuscation/`:

* `CompilerInfrastructure.cpp` handles setting up the compiler with `CompilerInvocationConfiguration` and invoking the semantic analysis of .swift files
* `DataStructures.cpp` defines the data structures used in `swiftObfuscation` together with its operator functions and json serialization and deserialization.
* `DeclarationParser.cpp` takes the `Decl` and routes it to be parsed by one of the "specific" declaration parsers (`NominalTypeDeclarationParser`, `VariableDeclarationParser`, `OperatorParser`, `FunctionDeclarationParser`, `ParameterDeclarationParser`)
* `DeclarationParsingUtils.cpp` defines utility functions used by declaration parsers.
* `ExpressionParser.cpp` parses the `Expr` (`swiftAST` object representing expression) to `Symbol` object.
* `FileIO.cpp` defines the functions for json files serialization / deserialization.
* `FunctionDeclarationParser.cpp` parses the `FuncDecl` (`swiftAST` object representing function declaration) to `Symbol` object.
* `LayoutRenamer.cpp` performs renaming of .xib and .storyboard files.
* `NameMapping.cpp` uses symbols name generators to generate the mapping: original symbol name to proposed rename.
* `NominalTypeDeclarationParser.cpp` parses `NominalTypeDecl` (`swiftAST` object representing class, struct, protocol or enum declaration) to `Symbol` object.
* `OperatorParser.cpp` parses `OperatorDecl` (`swiftAST` object representing operator declaration) to `Symbol` object
* `ParameterDeclarationParser.cpp` parses `ParamDecl` (`swiftAST` object representing function parameter declaration) to `Symbol` object
* `Renaming.cpp` creates the copy of the project being obfuscated and performs the renaming defined in `RenamesJson` object.
* `SourceFileWalker.cpp` identifies the symbols in the `SourceFile` (`swiftAST` object representing the .swift source file) using `SourceEntityWalker` callbacks and collects them to the set of `SymbolWithRange` objects.
* `SymbolExtracting.cpp` extracts symbols from .swift files included in `FilesJson` object collects them to `SymbolsJson` object.
* `Utils.cpp` defines utility functions.
* `VariableDeclarationParser.cpp` parses the `VarDecl` (`swiftAST` object representing `var` or `let` declaration) to `Symbol` object.

`swiftObfuscation` cmake build file can be found in `swift/lib/Obfuscation/CMakeLists.txt`.

## Unit tests
Unit test files can be found in `swift/unittests/SwiftObfuscation/` together with its `CMakeLists.txt` build file.

SymbolExtractorAndRenamer unit test are organized in similar manner to other SymbolExtractorAndRenamer tools. To run the tests just build and run `SwiftObfuscationTests` target, as described in [Building and Running Using Xcode](#buid_and_run) section.

## Integration tests
Ingration tests can be found in `swift/test/Obfuscation`.

Use the following command to run the tests:
```
swift/utils/run-test swift/test/Obfuscation \
--build-dir build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64 \
--lit build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/llvm-macosx-x86_64/Debug/bin/llvm-lit
```

For details refer to [IntegrationTesting](IntegrationTesting.md).

# <a name="adding"></a> Adding new files and components

## Adding new files to existing SymbolExtractorAndRenamer library

Place `.h` files in `swift/include/swift/<library_folder>`.

Place `.cpp` files in `swift/lib/<library_folder>`.
When adding `.cpp` file you need to include it in cmake build file (`CMakeLists.txt`) of this library: `swift/lib/<library_folder>/CMakeLists.txt`

## Including libraries from Swift Compiler

To make use of some Swift Compiler library (e.g. `swiftObfuscation` library) you need to include its header file in your source file using `#include` and add the library name in your `CMakeLists.txt` file under `LINK_LIBRARIES`. Please refer to existing `CMakeLists.txt` and follow the Swift Compiler guidelines.

## Creating new SymbolExtractorAndRenamer tools

To create new Swift Compiler tool create the directory in `swift/tools/` and follow the structure of existing tools, e.g. `obfuscator-symbol-extactor`. You need to create proper `CMakeLists.txt` build file starting with `add_swift_host_tool(<tool-name>` and include all the tool's dependecies and  `.cpp` files of the tool.

## Adding new parameters to command line tool

In the directory `swift/tools/<tool-name>` please find the `.cpp` file that defines the tool in question. There'll a namespace definition called `options` at the top of the file. This is the place that all the parameters are defined in. 

We're using the `llvm::cl` for the parameters definition and parsing. The definition is done by creating static global variables of the type from `llvm::cl`. They do not have to be enclosed in the `options` namespace, but we're doing it by convention to increase readability. The possible types of parameters as well as the possible options for each of them are documented in the [LLVM CommandLine Library Manual](https://llvm.org/docs/CommandLine.html).

The actual parsing is done in the `llvm::cl::ParseCommandLineOptions` function.
