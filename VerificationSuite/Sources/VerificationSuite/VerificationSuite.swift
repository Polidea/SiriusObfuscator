import Foundation
import Utility
import ShellOut

enum Project {
  case built(executable: String)
  case notBuilt(xcodeproj: String, scheme: String, outputPath: String)
}

func projectFromArgs(parsingResult: ArgumentParser.Result, parser: ArgumentParser, xcodeprojArg: OptionArgument<String>, schemeArg: OptionArgument<String>, outputBuildPath: String, executableArg: OptionArgument<String>) throws -> Project {

  let xcodeproj = parsingResult.get(xcodeprojArg)
  let scheme = parsingResult.get(schemeArg)
  let executable = parsingResult.get(executableArg)

  if let executable = executable {
    return .built(executable: executable)
  } else if let xcodeproj = xcodeproj, let scheme = scheme {
    return .notBuilt(xcodeproj: xcodeproj, scheme: scheme, outputPath: outputBuildPath)
  } else {
    throw ArgumentParserError.expectedArguments(parser, ["xcodeproj", "scheme"])
  }
}

func executableFromProject(_ project: Project) throws -> String {
  switch project {
  case .built(let executable):
    return executable
    
  case .notBuilt(let xcodeproj, let scheme, let outputPath):
    let buildSettingsDict: [String:String] =
      try xcodebuild(project: xcodeproj, scheme: scheme, outputBuildPath: outputPath)
        .components(separatedBy: "\n")
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .reduce(into: [:]) { dict, settingLine in
          let pair = settingLine.components(separatedBy: " = ")
          guard pair.count == 2 else {
            return
          }
          dict[pair[0]] = pair[1]
    }
    
    guard let productsPathComponent = buildSettingsDict["BUILT_PRODUCTS_DIR"],
      let executablePathComponent = buildSettingsDict["EXECUTABLE_PATH"] else {
        print("Failed to extract executable path from built project")
        exit(0)
    }
    let executablePath = productsPathComponent + "/" + executablePathComponent
    
    return executablePath
  }
}

func xcodebuild(project: String, scheme: String, outputBuildPath: String) throws -> String {
  // build project
  var arguments = [
    "-project", project,
    "-derivedDataPath", outputBuildPath,
    "-scheme", scheme,
    "-configuration", "Release",
    ]
  try shellOut(to: "xcodebuild", arguments: arguments)
  
  // return build settings for the same build parameters
  arguments.append("-showBuildSettings")
  return try shellOut(to: "xcodebuild", arguments: arguments)
}

func extractSymbolNames(executable: String) throws -> [String] {
  // TODO: for now, we expect the system to provide us with the nm tool available and globally linked
  // - consider adding nm tool path as script parameter
  let nmOutput = try shellOut(to: "nm", arguments: [
    executable,
    "-format=posix",
    "-p"  // don't sort, display in symbol-table order
    ])
  let lines = nmOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
  let symbolNames = lines.map { $0.components(separatedBy: " ").first! }
  return symbolNames
}

func demangle(symbols: [String]) throws -> String {
  // TODO: for now, we expect the system to provide us with the xcrun tool available and globally linked
  // - consider adding xcrun tool path as script parameter
  let demangleExec = try shellOut(to: "xcrun", arguments: ["--find", "swift-demangle"])
  return try shellOut(to: demangleExec, arguments: [
    "-compact", // compact mode (only emit the demangled names)
    "-simplified" // don't display module names or implicit self types
    ] + symbols)
}

func printToFile(string: String, filename: String) throws {
  try shellOut(to: "echo", arguments: ["'\(string)'", ">", filename])
}

func diffFiles(before: String, after: String, printUnchanged: Bool) throws -> String {
  let columnWidth = 200
  var arguments = [
    before,
    after,
    "--report-identical-files",
    "--side-by-side",
    "--width=\(columnWidth)"
  ]
  if !printUnchanged {
    arguments.append("--suppress-common-lines")
  }
  do {
    return try shellOut(to: "diff", arguments: arguments)
  } catch let error as ShellOutError {
    // Ignore error if the message is empty
    if error.message.isEmpty {
      return error.output
    } else {
      throw error
    }
  }
}

func removeDirectory(_ path: String) throws {
  try shellOut(to: "rm", arguments: ["-rf", path])
}

func removeFile(_ path: String) throws {
  try shellOut(to: "rm", arguments: [path])
}

