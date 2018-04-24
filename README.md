# Sirius - Swift Obfuscator

## Overview

Sirius is a tool for performing source-to-source obfuscation of Swift projects.

Basically, it transforms your code from this:

```
class Sample: UIViewController {
  var value = 42
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    foo(bar: 1)
  }
  
  func foo(bar baz: Int) {
    value += baz
  }
}

protocol Configurable {
  func configure()
}

extension Sample: Configurable {
  func configure() { }
}
```

to this:

```
class aqoxMfcPUXffEuurviH_ZPMDW2hCmXDR: UIViewController {
  var a0vLRcFFAQ1Lvw2sf4ZIigWKjXjpJpug = 42
  
  override func viewDidLoad() {
    super.viewDidLoad()
    A6PP2E5mcmjEsgOvTeXwy2G44vzYLa6H()
    xG1qrXIMEJC1Eoma2Qbp_ZWJ5y2lrGYX(KuT5vOLIISvSJyju6bYxsHO_vlWUU589: 1)
  }
  
  func xG1qrXIMEJC1Eoma2Qbp_ZWJ5y2lrGYX(KuT5vOLIISvSJyju6bYxsHO_vlWUU589 vjCKgTT7Cf0ZlEi9giLZstzgdC9XLQcd: Int) {
    a0vLRcFFAQ1Lvw2sf4ZIigWKjXjpJpug += vjCKgTT7Cf0ZlEi9giLZstzgdC9XLQcd
  }
}

protocol dVUt_HSz_a1q1JsbyTJVfk0KeXej8a4z {
  func A6PP2E5mcmjEsgOvTeXwy2G44vzYLa6H()
}

extension aqoxMfcPUXffEuurviH_ZPMDW2hCmXDR: dVUt_HSz_a1q1JsbyTJVfk0KeXej8a4z {
  func A6PP2E5mcmjEsgOvTeXwy2G44vzYLa6H() { }
}

```
The resulting obfuscated project is much more difficult to reverse engineer by the attacker.

## Usage

1. Get latest `sirius` executable from [here]().

2. Run:

```bash
$ bin/sirius -projectrootpath <path-to-xcode-project> -obfuscatedproject `<path-for-obfuscated-project>` [-namemappingstrategy <name-mapping-strategy>] [-keepintermediates] [-inplace] [-verbose]
```
where

`<path-to-xcode-project>` is a path to Xcode project root folder. It's the folder that contains both the Xcode project file (.xcodeproj or .xcworkspace) and the source files. It is passed to `file-extractor` tool.

`<path-for-obfuscated-project>` is the path to the directory that the newly generated obfuscated Swift source code files will be written to, as well as the new project. Is is passed to `renamer` tool.

In case when project should be obfuscated in place (without making a copy), `-inplace` argument can be used instead of `-obfuscatedproject`.

`<name-mapping-strategy>` is the optional parameter of type enum string. Is is passed to `name-mapper` tool. Is determines, which of the following strategies is used when generating the obfuscated symbol names:

* `random` strategy generates random alphanumeric strings of length 32, e.g. `gnxWyHU0uN3bXejy8bVAoNbyfg4gRuN8`.
* `deterministic` strategy generates deterministic renames based on symbol's original name, e.g. `T1_RootViewController`.
* `minifying` strategy generates strings as short as possible, e.g. `a`.

When the `-namemappingstrategy` parameter is not provided, the default `random` strategy is used.

`-keepintermediates` is the optional flag. When present, the interemediate files used to pass the necessary info between the tools invoked by _ObfuscatorTool_ (`files.json`, `symbols.json`, `renames.json`) will not be removed after successful obfuscation process.

`-verbose` is the optional flag. When present, the flag is passed to each tool invoked by _ObfuscatorTool_ and all debug info messages from each tool are printed to standard output.

### Verification

Verify the outcome of the obfuscation by opening the obfuscated project in Xcode. Use `verification-suite` and [Hopper](https://www.hopperapp.com) to check symbol names in mach-O file built from the obfuscated project.


## Motivation

This project was developed for a particular iOS app that we needed to obfuscate. It is therefore a non-generalizable tool designed to solve the problem of obfuscating the single source code.

It shows, however, how the Swift compiler might be used as a library for building the powerful and flexible developer tools. 

The app that motivated the development of Sirius is using:

- Swift 4.0 only (no Objective-C)
- Cocoapods
- `.storyboard` files
- CoreData

If your app has the same set of characteristics, we encourage you to try to obfuscate it. It may or may not work, depending on the Swift language constructs that you used.

## Limitations

Sirius is not production-ready. Some code constructs that are allowed in Swift, won't be properly renamed by Sirius. This might lead to obfuscated project that is not compiling or crashes at runtime.

Some code constructs that are not yet supported:

* Backticks
```
func `backticksName`() {}
```
* `#if #else #endif` preprocessor macros
* Old Swift selectors
```
let foo = Selector(("bar:"))
```

Symbols that won't be renamed by Sirius even though they are visible in mach-O binary:

* Enum associated values
```
enum EnumWithAssoc {
  case1(assoc: Int)
}
```

For more examples of unsupported constructs head [here](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer/tree/master/swift/test/Obfuscation/FullProcess).

For constructs that are deliberately excluded from renaming head [here](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer/blob/master/Documentation/ThingsThatAreNotObfuscated.md).

## Components

The Sirius - Swift Obfuscator suite consists of command line tools organized in repositories:

Repository | Tool | Overview
--- | --- | ---
[ObfuscatorTool](https://gitlab2.polidea.com/SwiftObfuscator/ObfuscatorTool) | `sirius` | Umbrella tool that exposes the unified command line interface to perform the obfuscation of Xcode project. It executes tools: `file-extractor`, `symbol-extractor`, `name-mapper`, `renamer` and passes the intermediate files between them.
[FileExtractor](https://gitlab2.polidea.com/SwiftObfuscator/FileExtractor) | `file-extractor` | Extracts the data about Xcode project based on the root project's path (e.g. the list of `.swift` source files, the list of frameworks required to build the project) to `files.json`.
[SymbolExtractorAndRenamer](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer) | `symbol-extractor` | Extracts symbols from `.swift` source files to `symbols.json`.
[SymbolExtractorAndRenamer](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer) | `name-mapper` | Generates the new names for the symbols provided in `symbols.json`.
[SymbolExtractorAndRenamer](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer) | `renamer` | Performs the renaming of symbols based on `renames.json`.
[VerificationSuite](https://gitlab2.polidea.com/SwiftObfuscator/VerificationSuite) | `verification-suite` | Tool for presenting the changes made in obfuscation process.

Projects used for testing various parts of the obfuscation process can be found in [TestProjects](https://gitlab2.polidea.com/SwiftObfuscator/TestProjects).

## Contributing

### Contributing to main command line tool (`sirius`)

If you wish to contribute to `sirius` (umbrella command line tool), head to [BuildNotes](https://gitlab2.polidea.com/SwiftObfuscator/ObfuscatorTool/blob/master/Documentation/BuildNotes.md) and [GettingStarted](https://gitlab2.polidea.com/SwiftObfuscator/ObfuscatorTool/blob/master/Documentation/GettingStarted.md).

### Contributing to other tools from Sirius suite

If you wish to contribute to other tools from Sirius - Swift Obfuscator suite, head to the repositories:

* [FileExtractor](https://gitlab2.polidea.com/SwiftObfuscator/FileExtractor) ( [BuildNotes](https://gitlab2.polidea.com/SwiftObfuscator/FileExtractor/blob/master/README.md#build-notes-for-developers) [GettingStarted](https://gitlab2.polidea.com/SwiftObfuscator/FileExtractor/blob/master/Documentation/GettingStarted.md) [ImportantTopics](https://gitlab2.polidea.com/SwiftObfuscator/FileExtractor/blob/master/Documentation/ImportantTopics.md) )
* [SymbolExtractorAndRenamer](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer) ( [BuildNotes](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer#build-notes-for-developers) [GettingStarted](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer/blob/master/Documentation/GettingStarted.md) Important topics: [SymbolExtractor](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer/blob/master/Documentation/SymbolExtractor-ImportantTopics.md) [NameMapper](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer/blob/master/Documentation/NameMapper-ImportantTopics.md) [Renamer](https://gitlab2.polidea.com/SwiftObfuscator/SymbolExtractorAndRenamer/blame/master/Documentation/Renamer-ImportantTopics.md) )
* [VerificationSuite](https://gitlab2.polidea.com/SwiftObfuscator/VerificationSuite) ( [BuildNotes](https://gitlab2.polidea.com/SwiftObfuscator/VerificationSuite#build-notes-for-developers) )
   
### Contributors to Sirius suite

In the alphabetical order:

* [Jerzy Kleszcz](jerzy.kleszcz@polidea.com)
* [Krzysztof Siejkowski](krzysztof.siejkowski@polidea.com)
* [Jakub Sowa](jakub.sowa@polidea.com)
* [Michał Zieliński](michal.zielinski@polidea.com)

### CLA

We require contributors to have signed [Contributor Licence Agreement](https://en.wikipedia.org/wiki/Contributor_License_Agreement).
   
## Support

Polidea may provide commercial support for extending the Sirius obfuscator to work with your app.

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
