import Foundation
import ShellOut
import Utility

guard let myselfInArguments = CommandLine.arguments.first
  else {
    print("Couldn't parse command line arguments")
    exit(1)
}

let filesJson = "files.json"
let symbolsJson = "symbols.json"
let renamesJson = "renames.json"

func execute() throws {
  
  let parser = ArgumentParser(
    usage: "-projectrootpath [PROJECTROOTPATH] -obfuscatedproject [OBFUSCATEDPROJECTPATH] -namemappingstrategy [MAPPINGSTRATEGY]",
    overview: "Obfuscator tool"
  )
  
  let originalPathArgument: OptionArgument<String> = parser.add(
    option: "-projectrootpath",
    kind: String.self,
    usage: """
    Path to Xcode project root folder. It's the folder that contains the Xcode project file (.xcodeproj or .xcworkspace) and the source files. It's a required parameter.
    """
  )
  
  let obfuscatedPathArgument: OptionArgument<String> = parser.add(
    option: "-obfuscatedproject",
    kind: String.self,
    usage: """
    Path to the directory to which the obfuscated project will be copied. It's a required parameter.
    """
  )
  
  enum NameMappingStrategy: String, StringEnumArgument {
    case random = "random"
    case deterministic = "deterministic"
    case minified = "minifying"
    
    static var `default`: NameMappingStrategy = .random
    var argDescription: String {
      switch self {
      case .random: return "Generate random unique identifiers (default)"
      case .deterministic: return "Generate deterministic identifiers (useful for testing)"
      case .minified: return "Generate minified identifiers"
      }
    }
    static var allValues: [NameMappingStrategy] { return [.random, .deterministic, .minified] }
    static var completion: ShellCompletion = .none
  }
  
  let nameMappingStrategyArgument: OptionArgument<NameMappingStrategy> = parser.add(
    option: "-namemappingstrategy",
    kind: NameMappingStrategy.self,
    usage: "Strategy of creating the mapping: original to obfuscated name. Options: " +
      NameMappingStrategy.allValues.reduce(into: "", { string, value in
        string += "\n\t\(value.rawValue)\t\(value.argDescription)"
      })
  )
  
  let verboseArgument = parser.add(
    option: "-verbose",
    kind: Bool.self,
    usage: """
    Print debugging info.
    """
  )
  
  let keepIntermediatesArgument = parser.add(
    option: "-keepintermediates",
    kind: Bool.self,
    usage: """
    Keep intermediate files (files.json symbols.json, renames.json).
    """
  )
  
  var arguments = Array(CommandLine.arguments.dropFirst())
  if arguments.isEmpty {
    arguments.append("-help")
  }
  
  let result = try parser.parse(arguments)
  
  guard let originalPath = result.get(originalPathArgument) else {
    print("Parameter -projectrootpath is required")
    return;
  }
  
  guard let obfuscatedPath = result.get(obfuscatedPathArgument) else {
    print("Parameter -obfuscatedproject is required")
    return;
  }
  
  let nameMappingStrategy: NameMappingStrategy = result.get(nameMappingStrategyArgument) ?? NameMappingStrategy.default
  
  let verbose = result.get(verboseArgument) ?? false
  
  let keepIntermediates = result.get(keepIntermediatesArgument) ?? false
  
  let dirName = try shellOut(to: "dirname", arguments: [myselfInArguments])
  let selfDir = try shellOut(to: ["cd \(dirName)", "pwd"])
  let introMessage = """
\u{001B}[0;35m===========================\u{001B}[0;37m

Welcome to Swift Obfuscator

"""
  print(introMessage)
  let fileExtractorMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

1) File Extractor:

"""
  print(fileExtractorMessage)
  
  var fileExtractorArguments = [
    "-projectrootpath", originalPath,
    "-filesjson", filesJson
  ]
  if verbose { fileExtractorArguments.append("-verbose") }
  
  let fileExtractorOutput = try shellOut(
    to: "\(selfDir)/file-extractor",
    arguments: fileExtractorArguments
  )
  print(fileExtractorOutput)
  let symbolExtractorMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

2) Symbol Extractor:

"""
  print(symbolExtractorMessage)
  
  var symbolExtractorArguments = [
    "-filesjson", filesJson,
    "-symbolsjson", symbolsJson
  ]
  if verbose { symbolExtractorArguments.append("-verbose") }
  
  let symbolExtractorOutput = try shellOut(
    to: "\(selfDir)/symbol-extractor",
    arguments: symbolExtractorArguments
  )
  print(symbolExtractorOutput)
  let nameMapperMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

3) Name Mapper:

"""
  print(nameMapperMessage)
  
  var nameMapperArguments = [
    "-symbolsjson", symbolsJson,
    "-renamesjson", renamesJson,
    "-namemappingstrategy", nameMappingStrategy.rawValue
  ]
  if verbose { nameMapperArguments.append("-verbose") }
  
  let nameMapperOutput = try shellOut(
    to: "\(selfDir)/name-mapper",
    arguments: nameMapperArguments
  )
  print(nameMapperOutput)
  let renamerMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

4) Renamer:

"""
  print(renamerMessage)
  
  var renamerArguments = [
    "-filesjson", filesJson,
    "-renamesjson", renamesJson,
    "-obfuscatedproject", obfuscatedPath
  ]
  if verbose { renamerArguments.append("-verbose") }
  
  let renamerOutput = try shellOut(
    to: "\(selfDir)/renamer",
    arguments: renamerArguments
  )
  print(renamerOutput)
  let farewellMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

Obfuscation process has finished correctly.

You might want to run Verification Suite to see the results of obfuscation.

Please consult:

$ bin/verification-suite -help

for more information.

\u{001B}[0;35m===========================\u{001B}[0;37m
"""
  print(farewellMessage)
  
  if !keepIntermediates { try cleanup() }
}

func cleanup() throws {
  try shellOut(to: "rm", arguments: [filesJson])
  try shellOut(to: "rm", arguments: [symbolsJson])
  try shellOut(to: "rm", arguments: [renamesJson])
}

do {
  try execute()
} catch {
  let error = error as! ShellOutError
  print("STDERR: \(error.message)")
  print("STDOUT: \(error.output)")
  
  try? cleanup()
}
