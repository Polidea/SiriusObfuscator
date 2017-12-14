import Foundation

// check script arguments

if CommandLine.argc != 5 {
  print("Usage: \(CommandLine.arguments[0]) <UNOBFUSCATED project .xcodeproj file> <UNOBFUSCATED project scheme> <OBFUSCATED project .xcodeproj file> <OBFUSCATED project scheme>")
  exit(0)
}


// build projects and extract executables paths

let xcodeprojBeforeObfuscation = CommandLine.arguments[1]
let schemeBeforeObfuscation = CommandLine.arguments[2]
let xcodeprojAfterObfuscation = CommandLine.arguments[3]
let schemeAfterObfuscation = CommandLine.arguments[4]

let buildPathBeforeObfuscation = "UnobfuscatedBuild"
let buildPathAfterObfuscation = "ObfuscatedBuild"

let unobfuscatedExecutablePath = executableFromProjectBuild(xcodeproj: xcodeprojBeforeObfuscation, scheme: schemeBeforeObfuscation, outputPath: buildPathBeforeObfuscation)
let obfuscatedExecutablePath = executableFromProjectBuild(xcodeproj: xcodeprojAfterObfuscation, scheme: schemeAfterObfuscation, outputPath: buildPathAfterObfuscation)


// TODO:
// - extract swift symbols from executables
// - demangle them
// - compare symbols before / after obfuscation


// remove build directories

removeDirectory(buildPathBeforeObfuscation)
removeDirectory(buildPathAfterObfuscation)
