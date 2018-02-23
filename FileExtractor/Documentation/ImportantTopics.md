# `FileExtractor` Important Topics

The goal of this document is to be a bag of important ideas, decisions, concepts and discoveries in the `FileExtractor` project. Currently these include:

1. [Why are we using Ruby for this project?](#ruby)
2. [Why do we use `xcodebuild` for settings discovery?](#xcodebuild)
3. [Why do we need to build dependencies in `FileExtractor`?](#dependencies)
4. [Are we supporting multiple modules (i.e. multiple targets)?](#targets)

# <a name="ruby"></a> Why Ruby?

The reason for using Ruby is so that we can use the gems that are part of [`Cocoapods` project](https://github.com/CocoaPods). Cocoapods is a battle-tested, long-developed tool that work with Xcode project files, is actively maintained and used by so many people that the change in the compatibility-breaking change in the Xcode project files has a strong chance of being fixed quickly.

# <a name="xcodebuild"></a> Xcodebuild for settings

We're using the `xcodebuild -showBuildSettings` flag for detection of the build settings in `FileExtractor`. We're doing it even though some of the settings are explicitely included in the Xcode project files and therefore would not need the additional dependency on command-line tool `xcodebuild`.

The reason is that not all the settings are included in the Xcode project files such as `.xcodeproj`. Xcode has many default settings that are written to build configuration only if changed by the developer. For example, if you check whether there's `LINK_WITH_STANDARD_LIBRARIES` setting in the sample Xcode project file, there will be no such option. But if you ask `xcodebuild -showBuildSettings`, there's the default `LINK_WITH_STANDARD_LIBRARIES = YES` option printed. Since we need to know the value of some settings regardless whether they're explicitly written in the Xcode project files, we need to use `xcodeproj` for that.

# <a name="dependencies"></a> Building dependencies for project

One of the final steps of `FileExtractor` is to build the dependencies for the parsed project. For example, if the Cocoapods project structure is determined, the tool finds the name of the Cocoapods project and ask it to build all the dependencies using `xcodebuild`. It makes the `FileExtractor` invocation long, it is fragile to the possible compiletion errors in the dependencies and it is a surprising side-effect for the user of the obfuscator.

The reason is that to perform the semantic analysis in the Swift compiler we need to link it with all the modules that are imported in the Swift source code. Otherwise the compiler will not only report error that no module can be found, but also wont be able to perform the semantic analysis for any symbol from the other module. Since having the information about semantic analysis is the main reason why we use the Swift compiler in the first place, parsing project without the dependent modules build and linked makes the whole process basically useless.

# <a name="targets"></a> Multiple targets support

For know we're supporting only one target. The underlying assumption is that the app target is the first target in the project. The support for multiple targets is in the future plans.
