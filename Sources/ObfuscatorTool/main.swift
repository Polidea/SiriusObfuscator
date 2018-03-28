import Foundation
import ShellOut
import Utility

// Progress animation
class Progress {
  
  enum AnimationKind {
    case Extracting
    case NameMapping
    case Renaming
  }
  
  private var extractingAnimationRunning = false
  private var nameMappingAnimationRunning = false
  private var renamingAnimationRunning = false
  
  private func startAnimation(_ animationKind: AnimationKind) {
    
    DispatchQueue.global(qos: .background).async {
  
      // animation frames
      var extractingFrames = ["⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈Extracting⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈",
                              "⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐\u{001B}[38;5;202mE\u{001B}[0;37mxtracting⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐",
                              "⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠E\u{001B}[38;5;202mx\u{001B}[0;37mtracting⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠",
                              "⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀Ex\u{001B}[38;5;202mt\u{001B}[0;37mracting⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀",
                              "⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀Ext\u{001B}[38;5;202mr\u{001B}[0;37macting⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀",
                              "⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄Extr\u{001B}[38;5;202ma\u{001B}[0;37mcting⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄",
                              "⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄Extra\u{001B}[38;5;202mc\u{001B}[0;37mting⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄",
                              "⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀Extrac\u{001B}[38;5;202mt\u{001B}[0;37ming⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀",
                              "⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀Extract\u{001B}[38;5;202mi\u{001B}[0;37mng⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀",
                              "⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠Extracti\u{001B}[38;5;202mn\u{001B}[0;37mg⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠",
                              "⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐Extractin\u{001B}[38;5;202mg\u{001B}[0;37m⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐",
                              "⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈Extractin\u{001B}[38;5;202mg\u{001B}[0;37m⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈"]
      
      
      var renamingFrames = ["⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈Renaming⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈",
                            "⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐\u{001B}[38;5;202mR\u{001B}[0;37menaming⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐",
                            "⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠R\u{001B}[38;5;202me\u{001B}[0;37mnaming⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠",
                            "⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀Re\u{001B}[38;5;202mn\u{001B}[0;37maming⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀",
                            "⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀Ren\u{001B}[38;5;202ma\u{001B}[0;37mming⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀",
                            "⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀Rena\u{001B}[38;5;202mm\u{001B}[0;37ming⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀",
                            "⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀Renam\u{001B}[38;5;202mi\u{001B}[0;37mng⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀",
                            "⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠Renami\u{001B}[38;5;202mn\u{001B}[0;37mg⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠",
                            "⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐Renamin\u{001B}[38;5;202mg\u{001B}[0;37m⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐",
                            "⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈Renamin\u{001B}[38;5;202mg\u{001B}[0;37m⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈"]
      
      var nameMappingFrames = ["⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈Name Mapping⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈",
                               "⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐\u{001B}[38;5;202mN\u{001B}[0;37mame Mapping⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐",
                               "⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠N\u{001B}[38;5;202ma\u{001B}[0;37mme Mapping⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠",
                               "⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀Na\u{001B}[38;5;202mm\u{001B}[0;37me Mapping⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀",
                               "⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀Nam\u{001B}[38;5;202me\u{001B}[0;37m Mapping⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀",
                               "⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄Name\u{001B}[38;5;202m \u{001B}[0;37mMapping⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄",
                               "⠄⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂Name \u{001B}[38;5;202mM\u{001B}[0;37mapping⠄⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂",
                               "⠄⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂Name M\u{001B}[38;5;202ma\u{001B}[0;37mpping⠄⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂",
                               "⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄Name Ma\u{001B}[38;5;202mp\u{001B}[0;37mping⡀⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄",
                               "⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀Name Map\u{001B}[38;5;202mp\u{001B}[0;37ming⡀⡀⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀",
                               "⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀Name Mapp\u{001B}[38;5;202mi\u{001B}[0;37mng⠄⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀",
                               "⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠Name Mappi\u{001B}[38;5;202mn\u{001B}[0;37mg⠄⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠",
                               "⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐Name Mappin\u{001B}[38;5;202mg\u{001B}[0;37m⠂⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐",
                               "⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈Name Mappin\u{001B}[38;5;202mg\u{001B}[0;37m⠁⠂⠄⡀⢀⠠⠐⠈⠁⠂⠄⡀⢀⠠⠐⠈"]
      
      var lastPrintedTime = 0.0

      func getTimeOfDay() -> Double {
        var tv = timeval()
        gettimeofday(&tv, nil)
        return Double(tv.tv_sec) + Double(tv.tv_usec) / 1000000
      }
      
      var frames = extractingFrames
      
      switch animationKind {
        case .Extracting:
          frames = extractingFrames
        case .NameMapping:
          frames = nameMappingFrames
        case .Renaming:
          frames = renamingFrames
      }
      
      var frameIndex = 0
      while(self.extractingAnimationRunning ||
            self.nameMappingAnimationRunning ||
            self.renamingAnimationRunning) {
        
        let currentTime = getTimeOfDay()
        if (currentTime - lastPrintedTime > 0.1) {
          
          let index = frames.index(frames.startIndex,
                                      offsetBy: frameIndex % frames.count)
          let frame = "\(frames[index])"
          
          // ANSI/VT100 Terminal Control Escape Sequences
          // http://www.termsys.demon.co.uk/vtansi.htm
          // \u{1B} - escape code
          // [1A - move cursor 1 row up
          // [K - clear everything to right from cursor
          print("\u{1B}[1A\u{1B}[K\(frame)")
          
          frameIndex = frameIndex+1;
          if(frameIndex == frames.count-1) {
            frameIndex = 0
          }
          lastPrintedTime = currentTime
        }
      }
    }
  }
  
  func startExtractingProgressAnimation() {
    extractingAnimationRunning = true
    nameMappingAnimationRunning = false
    renamingAnimationRunning = false
    startAnimation(AnimationKind.Extracting)
  }
  
  func stopExtractingProgressAnimation() {
    extractingAnimationRunning = false
  }
  
  func startNameMappingProgressAnimation() {
    nameMappingAnimationRunning = true
    extractingAnimationRunning = false
    renamingAnimationRunning = false
    startAnimation(AnimationKind.NameMapping)
  }
  
  func stopNameMappingProgressAnimation() {
    nameMappingAnimationRunning = false
  }
  
  func startRenamingProgressAnimation() {
    renamingAnimationRunning = true
    extractingAnimationRunning = false
    nameMappingAnimationRunning = false
    startAnimation(AnimationKind.Renaming)
  }
  
  func stopRenamingProgressAnimation() {
    renamingAnimationRunning = false
  }
}

let progress = Progress()

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
  
  let inPlaceArgument = parser.add(
    option: "-inplace",
    kind: Bool.self,
    usage: """
    Obfuscate project in place (without making a copy).
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
  
  let inPlace = result.get(inPlaceArgument) ?? false

  guard let obfuscatedPath = result.get(obfuscatedPathArgument) else {
    if(!inPlace) {
      print("Either -obfuscatedproject or -inplace parameter is required")
    }
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
  progress.startExtractingProgressAnimation()
  var fileExtractorArguments = [
    "-projectrootpath", originalPath,
    "-filesjson", filesJson
  ]
  if verbose { fileExtractorArguments.append("-verbose") }
  
  let fileExtractorOutput = try shellOut(
    to: "\(selfDir)/file-extractor",
    arguments: fileExtractorArguments
  )
  progress.stopExtractingProgressAnimation()
  print(fileExtractorOutput)
  let symbolExtractorMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

2) Symbol Extractor:

"""
  print(symbolExtractorMessage)
  progress.startExtractingProgressAnimation()
  var symbolExtractorArguments = [
    "-filesjson", filesJson,
    "-symbolsjson", symbolsJson
  ]
  if verbose { symbolExtractorArguments.append("-verbose") }
  
  let symbolExtractorOutput = try shellOut(
    to: "\(selfDir)/symbol-extractor",
    arguments: symbolExtractorArguments
  )
  progress.stopExtractingProgressAnimation()
  print(symbolExtractorOutput)
  let nameMapperMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

3) Name Mapper:

"""
  print(nameMapperMessage)
  progress.startNameMappingProgressAnimation()
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
  progress.stopNameMappingProgressAnimation()
  print(nameMapperOutput)
  let renamerMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

4) Renamer:

"""
  print(renamerMessage)
  progress.startRenamingProgressAnimation()
  var renamerArguments = [
    "-filesjson", filesJson,
    "-renamesjson", renamesJson,
    "-obfuscatedproject", obfuscatedPath
  ]
  if verbose { renamerArguments.append("-verbose") }
  if inPlace { renamerArguments.append("-inplace") }
  
  let renamerOutput = try shellOut(
    to: "\(selfDir)/renamer",
    arguments: renamerArguments
  )
  progress.stopRenamingProgressAnimation()
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
  progress.stopExtractingProgressAnimation()
  progress.stopNameMappingProgressAnimation()
  progress.stopRenamingProgressAnimation()
  
  let error = error as! ShellOutError
  print("STDERR: \(error.message)")
  print("STDOUT: \(error.output)")
  
  try? cleanup()
}
