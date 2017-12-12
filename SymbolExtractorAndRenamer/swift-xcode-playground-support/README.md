
# Swift Xcode Playground Support

**Welcome to Swift Xcode Playground Support!**

The Xcode Playground Support project enables Xcode playgrounds to
communicate their results in a displayable fashion, and to control some
aspects of playground behavior. In order to use a custom build of Swift
with Xcode the frameworks described below must be compiled with the new
Swift compiler and included in a toolchain. Snapshots will include this
project to deliver everything required. Just download, install, and
select the toolchain to work with the corresponding Swift features in
Xcode playgrounds.

## Contents

The project contains these frameworks:

* **PlaygroundSupport.** This framework defines API that may be
explicitly referred to by playground code to communicate with Xcode. For
example: this is typical for playgrounds that identify a particular
view to display live for animation or interaction, and when playgrounds
automatically move between pages when defined criteria are met. A legacy
XCPlayground version is also provided for compatibility with older
playgrounds.

* **PlaygroundLogger.** This project is used implicitly to record values
of interest on a line-by-line basis and communicate them to Xcode. Calls
are automatically injected into playground code so no explicit reference
is required.

## Documentation

PlaygroundSupport offers a limited set of APIs for communicating specific
requests to Xcode and should be self-explanatory.

PlaygroundLogger is more complex and includes documentation on the API in
[PlaygroundLogger/Documentation/LoggerAPI.md](PlaygroundLogger/Documentation/LoggerAPI.md)
and communication format in
[PlaygroundLogger/Documentation/LoggerFormat.md](PlaygroundLogger/Documentation/LoggerFormat.md).

## Working with Xcode Playground Support

### Getting Started

The standard Swift build script included in the [Swift repository](http://github.com/apple/swift)
automatically pulls and builds the Xcode Playground Support source.

### Getting Sources Directly

**Via HTTPS**  For those checking out sources as read-only, HTTPS works best:

    git clone https://github.com/apple/swift-xcode-playground-support.git
    cd swift-xcode-playground-support

**Via SSH**  For those who plan on regularly making direct commits,
cloning over SSH may provide a better experience (which requires
uploading SSH keys to GitHub):

    git clone git@github.com:apple/swift-xcode-playground-support.git
    cd swift-xcode-playground-support

### Building Individual Frameworks

#### Inside Xcode

PlaygroundSupport and PlaygroundLogger can be built individually building the
respective Xcode projects. It is critical that they're built using the Swift
compiler they're intended to be used with, which can be achieved by building,
installing, and selecting the corresponding toolchain in the Xcode UI.

Both projects contain universal targets that build all applicable products.
The target in PlaygroundLogger is named `All Platforms Logger`; in
PlaygroundSupport it is named `AllProducts`.

For testing purposes, PlaygroundLogger requires the presence of the
`StdlibUnittest` module which is part of Swift. This can be overriden either by
using the `BuildAndIntegration` configuration, or via the `NOSTDLIBUNITTEST`
conditional compilation directive.

#### Command-Line Builds

Command-line builds using `xcodebuild` require setting the `SWIFT_EXEC`
environment variable to a fully-qualified path for the corresponding Swift
compiler.

## Contributing to Swift Xcode Playground Support

Swift Xcode Playground Support changes may be required as the Swift language
evolves. As with other aspects of Swift, contributions are welcomed and encouraged!
Please see the [Contributing to Swift guide](https://swift.org/contributing/).

To be a truly great community, [Swift.org](https://swift.org/) needs to welcome developers from all
walks of life, with different backgrounds, and with a wide range of experience.
A diverse and friendly community will have more great ideas, more unique
perspectives, and produce more great code. We will work diligently to make the
Swift community welcoming to everyone.

To give clarity of what is expected of our members, Swift has adopted the
code of conduct defined by the Contributor Covenant. This document is used
across many open source communities, and we think it articulates our values
well. For more, see the [Code of Conduct](https://swift.org/community/#code-of-conduct).
