# Symbol Extractor, Name Mapper and Renamer

Repository contains the Swift compiler fork with three additional tools and one additional library added.

The tools are:

* _SymbolExtractor_ with sources in `swift/tools/obfuscator-symbol-extractor/` directory and the build file in `swift/tools/obfuscator-symbol-extractor/CMakeLists.txt`

* _NameMapper_ with sources in `swift/tools/obfuscator-name-mapper/` directory and the build file in `swift/tools/obfuscator-name-mapper/CMakeLists.txt`

* _Renamer_ with sources in `swift/tools/obfuscator-renamer/` directory and the build file in `swift/tools/obfuscator-renamer/CMakeLists.txt`

All these tools use a shared library called `swiftObfuscation`. Its headers are in `swift/include/swift/Obfuscation/` directory and its implementations are in `swift/lib/Obfuscation/` directory. The build file is in `swift/lib/Obfuscation/CMakeLists.txt`.

The descriptions of the tools are presented below.


# SymbolExtractor

## Overview

This tool is part of Swift Obfuscator project.

It performs the analysis of Swift source code files and identifies the symbols that should be obfuscated. Once identified, the symbol is written down so that it could be recognized later.

## Usage

```bash
$ obfuscator-symbol-extractor -filesjson <path-to-input-files-json> -symbolsjson <path-to-output-symbols-json> [-hidediagnostics] [-verbose]
```

where

`<path-to-input-files-json>` is a path to `files.json` that contains the data required for performing the analysis of Swift source code. This parameter is required.

`<path-to-output-symbols-json>` is a path to `symbols.json` file that the extracted symbols data will be written to. This parameter is required.

`-hidediagnostics` is the optional flag. It prevents the compiler diagnostics from being printed to standard output. The logs contain compilation warnings and errors that occured during compilation of the input project. This flag should be used with caution, considering that compilation warnings could prevent the `symbol-extractor` from correctly identifying the symbol.

`-verbose` is the optional flag. When present, the `symbols.json` contents are also printed to standard output.

## <a name="symbol-extractor-data-formats"></a> Data Formats

The input data format is called `files.json`. It's defined and explained in the [FilesExtractor project documentation](https://gitlab2.polidea.com/SwiftObfuscator/FileExtractor/tree/master#data-formats).

The output data format is called `symbols.json` and it is presented below:

```javascript
{
  "symbols": [  
    {
      "identifier": <string>,
      "name": <string>,
      "module": <string>,
      "type": <enum string>("type",
                            "namedFunction",
                            "externalParameter",
                            "internalParameter",
                            "singleParameter",
                            "variable",
                            "operator")
    }
  ]
}
```

`symbols` is a list of extracted symbols.

`name` is directly corresponding to the actual string defined in the Swift source code. This string will be replaced in the source code by the `Renamer`.

`identifier` contains all the information required to uniquely identify the given symbol in the source code. It allows `Renamer` to identify if the symbol should be renamed.

`module` is the name of the module in which the extracted symbol was originally declared. For some symbols it is different from the module in which the symbol occures. E.g. for function declaration that satisfies the protocol requirement (or overrides the function from base class), the `module` represents the module in which the protocol (or base class) is declared. It allows `Renamer` to identify if the symbol should be renamed.

`type` contains the type of the symbol. It's a string of value from a strictly limited enumeration:

  - `type` for symbol that represents type (class, struct, enum, protocol).
  - `namedFunction` for symbol that represents function or method with name.
  - `externalParameter` for symbol that represents the function's external parameter name.
  - `internalParameter` for symbol that represents the function's internal parameter name.
  - `singleParameter` for symbol that represents the function's single parameter name (parameter has only one name).
  - `variable` for symbol that represents `let` or `var` field.
  - `operator` for symbol that represents the operator.


# NameMapper

## Overview

This tool is part of Swift Obfuscator project.

It generates the new names for the symbols provided in the `symbols.json` file. It does not perform the actual renaming, just generates the the new names for the symbols that potentially needs to be renamed.

## Usage

```bash
$ obfuscator-name-mapper -symbolsjson <path-to-input-symbols-file> -renamesjson <path-to-output-renames-file> [-namemappingstrategy <name-mapping-strategy>] [-verbose]
```

where

`<path-to-input-symbols-file>` is a path to `symbols.json` file that contains the information about the extracted symbols. It's a required parameter.

`<path-to-output-renames-file>` is a path to the file that the symbols with proposed obfuscated names will be written to. It's a required parameter.

`<name-mapping-strategy>` is the optional parameter of type enum string determining which of the following strategies it used when generating the new names:

- `random` strategy generates random alphanumeric strings of length 32, e.g. `gnxWyHU0uN3bXejy8bVAoNbyfg4gRuN8`.
- `deterministic` strategy generates deterministic renames based on symbol's original name, e.g. `T1_RootViewController`.
- `minifying` strategy generates strings as short as possible, e.g. `a`.

When the `-namemappingstrategy` parameter is not provided, the default `random` strategy is used.

`-verbose` is the optional flag. When present, the `Renames.json` contents are also printed to standard output.

##<a name="name-mapper-data-formats"></a> Data Formats

The input format is called `symbols.json` and is described and explained in the [SymbolExtractor data formats](#symbol-extractor-data-formats) section.

The output format is called `Renames.json` and it is presented below:

```javascript
{
  "symbols": [
    {
      "identifier": <string>,
      "originalName": <string>,
      "obfuscatedName": <string>,
      "module": <string>,
      "type": <enum string>("type",
                            "namedFunction",
                            "externalParameter",
                            "internalParameter",
                            "singleParameter",
                            "variable",
                            "operator")
    }
  ]
}
```
Most of the fields in each element of the `symbols` array are copied from the input `symbols.json` file and described in [SymbolExtractor data formats](#symbol-extractor-data-formats) section. The differences are described below:

`originalName` is the same as `name` in `symbols.json`.

`obfuscatedName` is the proposed new name that the symbols should be renamed to.


# Renamer

## Overview

This tool is part of Swift Obfuscator project.

It performs the actual renaming. It parses the Swift source code to identify the symbols, checks whether these symbols should be renamed and what to rename them to, and then does the actual job of changing the symbol name. It generates the new Swift source code in the process.

## Usage

```bash
$ obfuscator-renamer -filesjson <path-to-input-files-json-file> -renamesjson <path-to-input-renames-json-file> -obfuscatedproject <path-to-directory-for-obfuscated-project> [-hidediagnostics] [-verbose]
```

where

`<path-to-input-files-json-file>` is the path to the `symbols.json` file. It's a required parameter.

`<path-to-input-renames-json-file>` is the path to the `Renames.json` file. It's a required parameter.

`<path-to-directory-for-obfuscated-project>` is the path to the directory that the newly generated obfuscated Swift source code files will be written to, as well as the new project.

In case when project should be obfuscated in place (without making a copy), `-inplace` argument can be used instead of `-obfuscatedproject`.

`-hidediagnostics` is the optional flag. It prevents the compiler diagnostics from being printed to standard output. The logs contain compilation warnings and errors that occured during compilation of the input project. This flag should be used with caution, considering that compilation warnings could prevent the `renamer` from correctly identifying the symbol.

`-verbose` is the optional flag. When present, the list of the obfuscated files is printed to the standard output.

## Data formats

The input data formats are `files.json` and `Renames.json` and are described in the [SymbolExtractor data formats](#symbol-extractor-data-formats) and [NameMapper data formats](#name-mapper-data-formats) sections.


# Common for all three projects

## Build notes for developers

1. Clone the source code  
   `git clone ssh://git@gitlab2.polidea.com:23/SwiftObfuscator/SymbolExtractorAndRenamer.git`

2. Install build tools  
   `brew install cmake ninja`

3. (optional, only if there is a need for change in the dependencies) Update dependencies  
   `/bin/bash Scripts/git_remotes.sh`  
   Script takes the parameter defining which version of Swift will be used as the basis of the changes to the compiler.

5. Build the Swift compiler in the Xcode-friendly way. A build can take multiple hours. Build artifacts require ~20GB of free disk space.
   `swift/utils/build-script --clean --xcode --release-debuginfo --debug-swift`

6. Build the Swift compiler using ninja with support for iOS, tvOS and watchOS. A build can take multiple hours. Build artifacts require ~20GB of free disk space.
   `swift/utils/build-script --ios --tvos --watchos --release-debuginfo --debug-swift`

7. Copy the generated libraries from ninja build to Xcode build
   `rm -r -f build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64/Debug/lib/swift`
   `cp -r build/Ninja-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64/lib/swift build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64/Debug/lib/swift`

### Build documentation (optional)

1. Install doxygen
   `brew install doxygen`

2. Install graphviz
   `brew install graphviz`

3. Build documentation
   `doxygen Doxyfile`

4. Open documentation
   `open Documentation/doxygen/index.html`

## Further read

Please consult the [Documentation](Documentation/) folder for the further explanations.

## Licence

TBA

## Contributors

In the alphabetical order:

* [Jerzy Kleszcz](jerzy.kleszcz@polidea.com)
* [Krzysztof Siejkowski](krzysztof.siejkowski@polidea.com)
* [Jakub Sowa](jakub.sowa@polidea.com)
* [Michał Zieliński](michal.zielinski@polidea.com)
