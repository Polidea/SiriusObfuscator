import Foundation
import Utility

// parse command line arguments

let parser = ArgumentParser(usage: "[options]", overview: "Tool for automatically presenting and veryfying the effectiveness of the obfuscation.")

let xcodeprojBeforeArg: OptionArgument<String> = parser.add(option: "-originalxcodeproj", kind: String.self, usage: "Path to xcodeproj file in project before obfuscation")
let schemeBeforeArg: OptionArgument<String> = parser.add(option: "-originalscheme", kind: String.self, usage: "Scheme name in project before obfuscation")
let xcodeprojAfterArg: OptionArgument<String> = parser.add(option: "-obfuscatedxcodeproj", kind: String.self, usage: "Path to xcodeproj file in project after obfuscation")
let schemeAfterArg: OptionArgument<String> = parser.add(option: "-obfuscatedscheme", kind: String.self, usage: "Scheme name in project after obfuscation")
let printUnchangedSymbolsFlag: OptionArgument<Bool> = parser.add(option: "-printunchangedsymbols", shortName: "-p", kind: Bool.self, usage: "Print unchanged symbols when diffing extracted symbols from original and obfuscated projects")

let buildPathBeforeObfuscation = "UnobfuscatedBuild"
let buildPathAfterObfuscation = "ObfuscatedBuild"

let symbolsBeforeFile = "before.txt"
let symbolsAfterFile = "after.txt"

do {
  
  let arguments = Array(CommandLine.arguments.dropFirst())
  let result = try parser.parse(arguments)

  let xcodeprojBeforeObfuscation = try getRequiredArgument(parsingResult: result, parser: parser, argument: xcodeprojBeforeArg, name: "xcodeprojBefore")
  let schemeBeforeObfuscation = try getRequiredArgument(parsingResult: result, parser: parser, argument: schemeBeforeArg, name: "schemeBefore")
  let xcodeprojAfterObfuscation = try getRequiredArgument(parsingResult: result, parser: parser, argument: xcodeprojAfterArg, name: "xcodeprojAfter")
  let schemeAfterObfuscation = try getRequiredArgument(parsingResult: result, parser: parser, argument: schemeAfterArg, name: "schemeAfter")
  let printUnchangedSymbols = result.get(printUnchangedSymbolsFlag) ?? false

  // build projects and extract executables paths

  let unobfuscatedExecutablePath = try executableFromProjectBuild(xcodeproj: xcodeprojBeforeObfuscation, scheme: schemeBeforeObfuscation, outputPath: buildPathBeforeObfuscation)
  let obfuscatedExecutablePath = try executableFromProjectBuild(xcodeproj: xcodeprojAfterObfuscation, scheme: schemeAfterObfuscation, outputPath: buildPathAfterObfuscation)

  // extract symbol names from executables and demangle them

  let symbolsBefore = try demangle(symbols: extractSymbolNames(executable: unobfuscatedExecutablePath))
  try printToFile(string: symbolsBefore, filename: symbolsBeforeFile)
  
  let symbolsAfter = try demangle(symbols: extractSymbolNames(executable: obfuscatedExecutablePath))
  try printToFile(string: symbolsAfter, filename: symbolsAfterFile)

  // compare symbol names before / after obfuscation

  print("\nDIFF OF SYMBOLS BEFORE | AFTER OBFUSCATION:\n")
  let diff = try diffFiles(before: symbolsBeforeFile, after: symbolsAfterFile, printUnchanged: printUnchangedSymbols)
  print(diff)

  // remove build directories and symbol files

  try removeDirectory(buildPathBeforeObfuscation)
  try removeDirectory(buildPathAfterObfuscation)

  try removeFile(symbolsBeforeFile)
  try removeFile(symbolsAfterFile)
  
} catch ArgumentParserError.expectedArguments(_, let stringArray) {
  print("Missing argument: \(stringArray)")
  
} catch {
  print(error.localizedDescription)
  try? removeDirectory(buildPathBeforeObfuscation)
  try? removeDirectory(buildPathAfterObfuscation)
  
  try? removeFile(symbolsBeforeFile)
  try? removeFile(symbolsAfterFile)
}

