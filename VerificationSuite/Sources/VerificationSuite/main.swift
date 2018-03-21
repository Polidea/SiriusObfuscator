import Foundation
import Utility

// parse command line arguments

let buildPathBefore = "UnobfuscatedBuild"
let buildPathAfter = "ObfuscatedBuild"

let symbolsFileBefore = "before.txt"
let symbolsFileAfter = "after.txt"

do {
  
  let parser = ArgumentParser(usage: "[options]", overview: "Tool for automatically presenting and veryfying the effectiveness of the obfuscation.")
  
  let xcodeprojBeforeArg = parser.add(option: "-originalxcodeproj", kind: String.self, usage: "Path to xcodeproj file in project before obfuscation")
  let schemeBeforeArg = parser.add(option: "-originalscheme", kind: String.self, usage: "Scheme name in project before obfuscation")
  let executableBeforeArg = parser.add(option: "-originalexecutable", kind: String.self, usage: "Executable build from project before obfuscation")
  
  let xcodeprojAfterArg = parser.add(option: "-obfuscatedxcodeproj", kind: String.self, usage: "Path to xcodeproj file in project after obfuscation")
  let schemeAfterArg = parser.add(option: "-obfuscatedscheme", kind: String.self, usage: "Scheme name in project after obfuscation")
  let executableAfterArg = parser.add(option: "-obfuscatedexecutable", kind: String.self, usage: "Executable build from project after obfuscation")
  
  let printUnchangedSymbolsFlag = parser.add(option: "-printunchangedsymbols", shortName: "-p", kind: Bool.self, usage: "Print unchanged symbols when diffing extracted symbols from original and obfuscated projects")
  
  let arguments = Array(CommandLine.arguments.dropFirst())
  let result = try parser.parse(arguments)
  
  let projectBefore = try projectFromArgs(parsingResult: result, parser: parser, xcodeprojArg: xcodeprojBeforeArg, schemeArg: schemeBeforeArg, outputBuildPath: buildPathBefore, executableArg: executableBeforeArg)
  let projectAfter = try projectFromArgs(parsingResult: result, parser: parser, xcodeprojArg: xcodeprojAfterArg, schemeArg: schemeAfterArg, outputBuildPath: buildPathAfter, executableArg: executableAfterArg)
  
  let printUnchangedSymbols = result.get(printUnchangedSymbolsFlag) ?? false

  // extract executables paths, build project if necessary

  let unobfuscatedExecutablePath = try executableFromProject(projectBefore)
  let obfuscatedExecutablePath = try executableFromProject(projectAfter)

  // extract symbol names from executables and demangle them

  let symbolsBefore = try demangle(symbols: extractSymbolNames(executable: unobfuscatedExecutablePath))
  try printToFile(string: symbolsBefore, filename: symbolsFileBefore)
  
  let symbolsAfter = try demangle(symbols: extractSymbolNames(executable: obfuscatedExecutablePath))
  try printToFile(string: symbolsAfter, filename: symbolsFileAfter)

  // compare symbol names before / after obfuscation

  print("\nDIFF OF SYMBOLS BEFORE | AFTER OBFUSCATION:\n")
  let diff = try diffFiles(before: symbolsFileBefore, after: symbolsFileAfter, printUnchanged: printUnchangedSymbols)
  print(diff)

  // remove build directories and symbol files

  try removeDirectory(buildPathBefore)
  try removeDirectory(buildPathAfter)

  try removeFile(symbolsFileBefore)
  try removeFile(symbolsFileAfter)
  
} catch ArgumentParserError.expectedArguments(_, let stringArray) {
  print("Missing arguments: \(stringArray)")
  
} catch {
  print(error.localizedDescription)
  try? removeDirectory(buildPathBefore)
  try? removeDirectory(buildPathAfter)
  
  try? removeFile(symbolsFileBefore)
  try? removeFile(symbolsFileAfter)
}

