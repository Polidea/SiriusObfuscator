# Obfuscation tool

## Overview

This is the umbrella tool that exposes the unified command line interface to perform the obfuscation of Xcode project.

## Usage

```bash
$ obfuscator-tool -projectrootpath <path-to-xcode-project> -obfuscatedproject `<path-for-obfuscated-project>` -namemappingstrategy <name-mapping-strategy>
```

where

`<path-to-xcode-project>` is a path to Xcode project root folder. It\'s the folder that contains both the Xcode project file (.xcodeproj or .xcworkspace) and the source files. It is passed to _FileExtractor_ tool.

`<path-for-obfuscated-project>` is the path to the directory that the newly generated obfuscated Swift source code files will be written to, as well as the new project. Is is passed to _Renamer_ tool.

`<name-mapping-strategy>` strategy of creating the mapping: original to obfuscated name. Is is passed to _NameMapper_ tool. Options:
- `random` to generate random unique identifiers (default).
- `deterministic` to generate deterministic identifiers (useful for testing).
- `minifying` to generate minified identifiers.

## Data format

TBA

## Build notes for developers

1. Clone the source  
   `git clone ssh://git@gitlab2.polidea.com:23/SwiftObfuscator/ObfuscatorTool.git`

2. Add git-subtrees remotes
   `bash Scripts/git_remotes.sh`

3. (optional, do it if there's a need for updating the dependencies) Update dependecies
   `bash Scripts/git_update.sh`

4. Build all the dependent projects and the main project
   `bash Scripts/build.sh`

## Further read

Please consult the [Documentation](Documentation/) folder for the further explanations.

## Licence

TBA

## Contributors

In the alphabetical order:

* [Jerzy Kleszcz](jerzy.kleszcz@polidea.com)
* [Krzysztof Siejkowski](krzysztof.siejkowski@polidea.com)


