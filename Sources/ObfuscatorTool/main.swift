import Foundation
import ShellOut
import Utility

guard let myselfInArguments = CommandLine.arguments.first
  else {
    print("Couldn't parse command line arguments")
    exit(1)
}

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
  let fileExtractorOutput = try shellOut(
    to: "\(selfDir)/file-extractor",
    arguments: ["-projectrootpath", originalPath, "-filesjson", "files.json"]
  )
  print(fileExtractorOutput)
  let symbolExtractorMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

2) Symbol Extractor:

"""
  print(symbolExtractorMessage)
  let symbolExtractorOutput = try shellOut(
    to: "\(selfDir)/symbol-extractor",
    arguments: ["-filesjson", "files.json", "-symbolsjson", "symbols.json"]
  )
  print(symbolExtractorOutput)
  let nameMapperMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

3) Name Mapper:

"""
  print(nameMapperMessage)
  let nameMapperOutput = try shellOut(
    to: "\(selfDir)/name-mapper",
    arguments: ["-symbolsjson",
                "symbols.json",
                "-renamesjson",
                "renames.json",
                "-namemappingstrategy", nameMappingStrategy.rawValue]
  )
  print(nameMapperOutput)
  let renamerMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

4) Renamer:

"""
  print(renamerMessage)
  let renamerOutput = try shellOut(
    to: "\(selfDir)/renamer",
    arguments: [
      "-filesjson",
      "files.json",
      "-renamesjson",
      "renames.json",
      "-obfuscatedproject",
      obfuscatedPath
    ]
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
}

do {
  try execute()
} catch {
  let error = error as! ShellOutError
  print("STDERR: \(error.message)")
  print("STDOUT: \(error.output)")
}
