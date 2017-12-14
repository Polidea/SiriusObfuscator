import Foundation
import ShellOut

func executableFromProjectBuild(xcodeproj: String, scheme: String, outputPath: String) -> String {
  
  let buildSettingsDict: [String:String] =
    xcodebuild(project: xcodeproj, scheme: scheme, outputBuildPath: outputPath)
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

func xcodebuild(project: String, scheme: String, outputBuildPath: String) -> String {
  // build project
  var arguments = [
    "-project", project,
    "-derivedDataPath", outputBuildPath,
    "-scheme", scheme,
    "-configuration", "Release",
    ]
  try! shellOut(to: "xcodebuild", arguments: arguments)
  
  // return build settings for the same build parameters
  arguments.append("-showBuildSettings")
  return try! shellOut(to: "xcodebuild", arguments: arguments)
}

func removeDirectory(_ path: String) {
  try! shellOut(to: "rm", arguments: ["-rf", path])
}
