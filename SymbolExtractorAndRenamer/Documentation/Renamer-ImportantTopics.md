# Important topics for Renamer

The goal of this document is to be a bag of important ideas, decisions, concepts and discoveries in the `Renamer` project. Currently these include:

1. [How does renaming process work?](#renaming)
2. [Why is `Renamer` doing the semantic analysis if it was already done once in the `SymbolExtractor`?](#double)
3. [Where does `Renamer` take new (obfuscated) names from?](#names)
4. [Do you support layout files like `.xib` and `.storyboard`?](#layouts)
5. [Is it possible to exclude parts of the code from being obfuscated?](#exclude)
6. [How can I verify if the code was renamed correctly?](#verification)
7. [Why is `Renamer` creating a copy of project to obfuscate the files in?](#copy)

# <a name="renaming"></a> How does renaming process work?

Renaming is a separate part of the obfuscation process done by the `Renamer` command line tool. It's the step in which the actual obfuscation is performed; before `Renamer` only the infrastructure work is done, like identifying and building dependencies or creating the `Files.json`, `Symbols.json` and `Renames.json` medata files. No change to the original Xcode project is done yet nor any copy is created.

The `Renamer` than takes three pieces of information to perform obfuscation (they correspond to the command line interface of the tool and parameters it requires):

* `Files.json` file so that it's able to identify the location of the original Xcode project, which files should be renamed, and what information does the compiler need to perform the semantic analysis,

* `Renames.json` file with a list of symbols that might get renamed and the proposed renamings,

* a path under which the obfuscated copy of the original project should be created.

Having the three pieces of information the renamer performs following steps:

* creates a copy of the original project under the path provided by the user,

* creates the compiler invocation using information from  `Files.json` and performs the semantic analysis,

* traverses the resulting AST and identifies all the symbols in it in the same way as the [`SymbolExtractor`](./SymbolExtractor-ImportantTopics.md) does,

* decides for each symbol whether it should be renamed and if it should, tries to find it in the `Renames.json` file. If the symbol is found in the `Renames.json`, the actual writing to the file is done, with the proper change (obfuscated name in place of the original one),

* the same process is then performed for XIB / Storyboard files.

# <a name="double"></a> Why renaming requires another semantic analysis?

In the `Renamer` we're performing the same semantic analysis process that is already done once in the `SymbolExtractor`. While it might seem as the waste of work, there's a number of underlying reasons for it:

* decoupling of the symbol extraction and the renaming makes it possible to identify the symbols in one source code and use them for renaming in a separate source code. While this might be an edge case to change the source code between the symbol extraction and renaming, it may happen if the project incorporates the code generation steps or automatic linting,

* the symbol extractor identifies the symbols, not their occurences. One identifier that's occuring multiple time in the source code will be represented by just one symbol in the `Symbols.json` file. It makes the tools working on `Symbols.json` way simpler, the schema more readable and the whole data set smaller,

* writing all the occurences of identifier in `Symbols.json` would mean that we need to write the location in the source file under which the identifier should be renamed. The actual renaming changes that location; for example, if the obfuscated name is longer than the original name, the location should be offset further to accomodate for additional characters in the obfuscated name. The location correction logic would be tricky to implement and at the same time any bug in it would render the whole project unable to be compiled.

# <a name="names"></a> Where are new names coming from?

The obfuscated names for symbols come from [`NameMapper` tool](./NameMapper-ImportantTopics.md) which output is `Renames.json`. This file contains all information needed to perform renaming such as `originalName` and `obfuscatedName` for each symbol and is later consumed by `Renamer` tool which performs actual renaming.

# <a name="layouts"></a> Are layout files renamed?

Yes, layout files are being renamed.

First [`FileExtractor` tool](./ImportantTopics.md) extracts information about all layout (`.xib` and `.storyboard`) files that are present in the project.
Then when `Renamer` is renaming symbols, it also stores each successfully renamed symbol in a set. After that it iterates over gathered layout files and renames them one by one. Both `.xib` and `.storyboard` are `.xml` files. `Renamer` parses them using `libxml` and then traverses the tree looking for types and functions that can be renamed. It decides if a found name should be renamed by checking if such symbol was renamed during symbol renaming. Such check is possible because it has access to the set containing all renamed symbols. After the file is finally processed `Renamer` saves the result in obfuscated project directory.

Currently the tool renames:
  - class names
  - outlets
  - actions (without parameters or with one default parameter, support for general selectors support is in the future plans)

# <a name="exclude"></a> Excluding parts of code from obfuscation

It's not possible currently. The feature is in the future plans.

# <a name="verification"></a> Verify if the code was correctly renamed

The verification of the correct renaming is done with the [integration tests](./IntegrationTesting.md).

# <a name="copy"></a> Why is `Renamer` creating a copy of project to obfuscate the files in?

Our main goal is to be as little invasive and as developer-friendly as possible. While it's entirely possible to rename files in place (and there're plans to bring this option in the future), creating a copy ensures that the developer won't have any chance of destroying or corrupting their original project.
