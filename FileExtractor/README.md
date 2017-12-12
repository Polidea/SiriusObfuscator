# FileExtractor

Tool that consumes the Xcode project files (.xcodeproj or .xcworkspace) and generates a json file with deta about what files referenced in the projects should be obfuscated and their metadata.

## Installation

`> git clone ssh://git@gitlab2.polidea.com:23/SwiftObfuscator/FileExtractor.git`

## Building

`> swift build`

## Running

`> .build/debug/FileExtractor`

Please note that `debug` is a name of configuration. If you use configuration other than debug, change the path accordingly.

## Developing

`> ./Scripts/setup_environment.sh`
`> open FileExtractor.xcodeproj`
