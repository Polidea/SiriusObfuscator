# Verification suite

## Overview

This repository is part of [Sirius - Swift Obfuscator](https://github.com/PolideaPlayground/SiriusObfuscator) project.

Tools for automatically presenting and veryfying the effectiveness of the obfuscation. The effectiveness is presented in form of the difference between the symbols extracted from the mach-O executable built from projects before and after obfuscation.

It uses `xcodebuild` to build the provided projects if necessary, `nm` to extract symbols from the binary, `swift-demangle` for demangling these extracted symbols and `diff` to diff the extracted symbols.

## Usage

Each of the projects (original and obfuscated) can be provided in form of `.xcodeproj` file and build scheme name (to be buid by VerificationSuite using `xcodebuild`) or in form of pre-built mach-O executable.

```bash
$ VerificationSuite -originalxcodeproj <original-project-xcodeproj-file> -originalscheme <original-project-scheme> -obfuscatedxcodeproj <obfuscated-project-xcodeproj-file> -obfuscatedscheme <obfuscated-project-scheme>
```

```bash
$ VerificationSuite -originalexecutable <original-executable> -obfuscatedexecutable <obfuscated-executable>
```

where

`<original-executable>` is the path to the mach-O executable file build from project before obfuscation. If this parameter is provided the `<original-project-xcodeproj-file>` and `<original-project-scheme>` parameters are ignored.

`<original-project-xcodeproj-file>` is the path to the project file before obfuscation. It's a required parameter.

`<original-project-scheme>` is a scheme for building the project. It's a required parameter.

`<obfuscated-executable>` is the path to the mach-O executable file build from project after obfuscation. If this parameter is provided the `<obfuscated-project-xcodeproj-file>` and `<obfuscated-project-scheme>` parameters are ignored.

`<obfuscated-project-xcodeproj-file>` is the path to the project file after obfuscation. It's a required parameter.

`<obfuscated-project-scheme>` is a scheme for building the project. It's a required parameter.

## Data formats

The input consists of two paths to Xcode project files: original and obfuscated.

The original one is the project before obfuscation that was an input to the _FileExtractor_ tool. All the paths to files and all the metadata was based on this project file.

The obfuscated one is the project after obfuscation that contains the obfuscated source code.

The output is a diff of symbols before and after obfuscation.

## Build notes for developers

1. Clone the source  
   `git clone git@github.com:PolideaPlayground/SiriusObfuscator-VerificationSuite.git`
   `cd VerificationSuite`

2. Build project  
   `swift build`

3. Run tool to verify it's working  
   `./.build/debug/VerificationSuite`

## On project dependencies

This project is dependent on availability of tool in the environment.

It requires `xcodebuild`, so the Xcode must be installed.

It requires standard Unix tool [`nm`](https://en.wikipedia.org/wiki/Nm_(Unix)).

It requires Xcode command-line tool `xcrun`.

It requires Swift toolchain tool `swift-demangle`.

It requires standard Unix tool `diff`.

## Further read

Please consult the [Documentation](Documentation/) folder for the further explanations.

## Contributing

### Contributors

In the alphabetical order:

* [Jerzy Kleszcz](jerzy.kleszcz@polidea.com)
* [Krzysztof Siejkowski](krzysztof.siejkowski@polidea.com)

### CLA

We require contributors to have signed [Contributor Licence Agreement](https://en.wikipedia.org/wiki/Contributor_License_Agreement).

## Licence

```
Copyright 2018 Polidea Sp. z o.o

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

