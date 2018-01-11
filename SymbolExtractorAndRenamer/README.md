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
$ obfuscator-symbol-extractor -filesjson <path-to-input-files-json> -symbolsjson <path-to-output-symbols-json>
```

where 

`<path-to-input-files-json>` is a path to `Files.json` that contains the data required for performing the analysis of Swift source code. This parameter is required.

`<path-to-output-symbols-json>` is a path to `Symbols.json` file that the extracted symbols data will be written to. If it's an optional parameter. If ommited, tool will print out to the standard output.

## Data formats

The input data format is called `Files.json`. It's defined and explained in the [FilesExtractor project documentation](https://gitlab2.polidea.com/SwiftObfuscator/FileExtractor/tree/master#data-formats).

The output data format is called `Symbols.json` and presented below:

```javascript
{
  "symbols": [  
    {
      "identifier": <string>,
      "name": <string>
    }
  ]
}
```

`symbols` is a list of objects that contains symbol identifier and name. 

`name` is directly corresponding to the actual string defined in the Swift source code. This string will be replaced by the `Renamer`. 

`identifier` contains all the information required to uniquely identify the given symbol in the source code. It will be used by `Renamer` to decide whether the symbol it comes across should be renamed or not.

## Feature list

- [] TBA

# NameMapper

## Overview

This tool is part of Swift Obfuscator project.

It proposes the new names for the symbols provided in the `Symbols.json` file. It does not perform the actual renaming, but it generates the symbols after obfuscation.

## Usage

```bash
$ obfuscator-name-mapper -symbolsjson <path-to-input-symbols-file> -renamesjson <path-to-output-renames-file>
```

where

`<path-to-input-symbols-file>` is a path to `Symbols.json` file that contains the information about the extracted symbols. It's a required parameter.

`<path-to-output-renames-file>` is a path to the file that the symbols with proposed obfuscated names will be written to. It's an optional parameter. If ommited, tool will print out to the standard output.

## Data formats

The input format is called `Symbols.json` and is described and explained in the [SymbolExtractor data formats](#data-formats) section.

The output format is called `Renames.json` and presented below:

```javascript
{
  "symbols": [
    {
      "identifier": <string>,
      "originalName": <string>,
      "obfuscatedName": <string>
    }
  ]
}
```

`symbols` is an array of objects containing the original name of symbol, its identifier and the proposes obfuscated name.

`originalName` and `identifier` are the same as `name` and `symbol` fields in the `Symbols.json` format, respectively.

`obfuscatedName` is the proposed name that the original name of symbol should be changed to.

## Feature list

- [] TBA

# Renamer

## Overview

This tool is part of Swift Obfuscator project.

It performs the actual renaming. It parses the Swift source code to identify the symbols, checks whether these symbols should be renamed and what to rename them to, and then does the actual job of changing the symbol name. It generates the new Swift source code in the process.

## Usage

```bash
$ obfuscator-renamer -filesjson <path-to-input-files-json-file> -renamesjson <path-to-input-renames-json-file> -obfuscatedproject <path-to-directory-for-obfuscated-project>
```

where

`<path-to-input-files-json-file>` is the path to the `Files.json` file. It's a required parameter.

`<path-to-input-renames-json-file>` is the path to the `Renames.json` file. It's a required parameter.

`<path-to-directory-for-obfuscated-project>` is the path to the directory that the newly generated obfuscated Swift source code files will be written to, as well as the new project.

## Data formats

The input data formats are `Files.json` and `Renames.json` and are described in the [SymbolExtractor data formats section](#data-formats) and [NameMapper data formats section](#data-formats-1).

## Feature list

- [] TBA

# Common for all three projects

## Build notes for developers

1. Clone the source code  
   `git clone ssh://git@gitlab2.polidea.com:23/SwiftObfuscator/SymbolExtractorAndRenamer.git`

2. Install build tools  
   `brew install cmake ninja`

3. (optional, only if there is a need for change in the dependencies) Update dependencies  
   `/bin/bash Scripts/git_remotes.sh`  
   Script takes the parameter defining which version of Swift will be used as the basis of the changes to the compiler.

5. Build the Swift compiler in the Xcode-friendly way.  
   `swift/utils/build-script --clean --xcode --release-debuginfo --debug-swift`

6. (optional) Build the Swift compiler in the version allowing for the fast incremental compilation with ninja  
   `swift/utils/build-script --release-debuginfo`

## Further read

Please consult the [Documentation](Documentation/) folder for the further explanations.

## Licence

TBA

## Contributors

In the alphabetical order:

* [Jerzy Kleszcz](mailto:jerzy.kleszcz@polidea.com)
* [Krzysztof Siejkowski](krzysztof.siejkowski@polidea.com)
* [Jakub Sowa](jakub.sowa@polidea.com)

