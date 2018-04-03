# Getting started with Sirius project

This document presents how to start developing in the Sirius project. It aims at answering following questions:

1. [What is the purpose of Sirius?](#purpose)
2. [Why is Sirius having the source code of all the other tools?](#why)
3. [How to start developing in Sirius?](#how)
4. [What format is Sirius distributed in?](#what)

# <a name="purpose"></a> Purpose

Sirius provides a simple interface to the whole obfuscation process. Under the hood, it executes tool after tool from the toolchain, passing the right flags and right parameter values.

First, it executes `FileExtractor`. It takes the project root path as parameter, so `Sirius` has a similar parameter in its own command line interface. The location of `Files.json` file is internal to the tool and therefore we don't need to ask the user about it.

Second, it executes `SymbolExtractor` with the `Files.json` path as parameter. The path to the resulting `Symbols.json` file is again internal to the tool, so we don't ask the user about it.

Third, it executes `NameMapper` with `Symbols.json` file as parameter. The resulting `Renames.json` path is internal to tool.

Fourth, it executes `Renamer` with `Renames.json` path (internal to tool), `Files.json` path (internal to tool) and the path to the resulting obfuscated copy of the original project. Since the path to the copy is a user-provided information, it's a part of the `Sirius` command line interface.

The user sees all these steps as one step that takes the original project path and the obfuscated project path and creates the obfuscated project.

# <a name="why"></a> Why are there all the other tools in this repo?

As described above, the `Sirius` is an single command-line interface for the whole obfuscation process. Therefore it requires to have all the obfuscation subtools included. It also plays the role of being the distribution version of the Swift obfuscator, so it's ensuring the tools are build with release configurations that are also distributable to other OSX machines. Since we want to have the versioning of the `Sirius` separate from the work on the sub-projects, we're using the git subtrees convention to include all the subtools into the `Sirius` repo.

# <a name="how"></a> Start developing

`Sirius` is a relatively small project that plays multiple roles. Therefore if you want to:

1. Change the way that subtools are being included in the main repo, such as which version is chosen, see the `Scripts` directory, especially `git_updates.sh` script.

2. Change that way that subprojects and the main project is build and prepared for distribution, see `Scripts` directory, especially `build.sh` script.

3. Change the actual command line interface of the `Sirius` and how it's launching the subtools one by one, including the flags it's passing, ways it's logging their output and the paths to the `Files.json`, `Symbols.json` and `Renames.json` files, see the `Sources` directory for the Swift script sources and `Package.swift` file for the dependencies.

# <a name="what"></a> Distribution

The distribution of `Sirius` requires building all the subprojects, see `Scripts/build.sh` script. After they're build, there are two directories that they're copied to:

* `bin` has all the binaries for subtools as well as the `FileExtractor` Ruby source code in `bin/lib` directory.

* `lib` directory (separate from `bin/lib`) has all the Swift stdlib and shims to the system libraries that are required for semantic analysis of the Swift source code.
