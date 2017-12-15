import Foundation
import ShellOut

guard let myselfInArguments = CommandLine.arguments.first
  else {
    print("Couldn't parse command line arguments")
    exit(1)
}

do {
  let dirName = try shellOut(to: "dirname", arguments: [myselfInArguments])
  let selfDir = try shellOut(to: ["cd \(dirName)", "pwd"])
  let introMessage = """
\u{001B}[0;35m===========================\u{001B}[0;37m

Welcome to Swift obfuscator

\u{001B}[0;35m===========================\u{001B}[0;37m

The obfuscation process consists of multiple steps. We'll do them one by one.
"""
  print(introMessage)
  let fileExtractorMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

1) First, let's launch File Extractor

File Extractor output:

"""
  print(fileExtractorMessage)
  let fileExtractorOutput = try shellOut(to: "\(selfDir)/file-extractor", arguments: [])
  print(fileExtractorOutput)
  let symbolExtractorMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

2) Then, let's launch Symbol Extractor

Symbol Extractor output:

"""
  print(symbolExtractorMessage)
  let symbolExtractorOutput = try shellOut(to: "\(selfDir)/symbol-extractor", arguments: [])
  print(symbolExtractorOutput)
  let nameMapperMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

3) Then, let's run Name Mapper

Name Mapper output:

"""
  print(nameMapperMessage)
  let nameMapperOutput = try shellOut(to: "\(selfDir)/name-mapper", arguments: [])
  print(nameMapperOutput)
  let renamerMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

4) Then, let's run Renamer. This it the steps that performs the actual renaming

Renamer output:

"""
  print(renamerMessage)
  let renamerOutput = try shellOut(to: "\(selfDir)/renamer", arguments: [])
  print(renamerOutput)
  let verificationSuiteMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

5) Finally, let's run Verification Suite to see what has just happened

Verification Suite output:

"""
  print(verificationSuiteMessage)
  let verificationSuiteOutput = try shellOut(to: "\(selfDir)/verification-suite", arguments: [])
  print(verificationSuiteOutput)
  let farewellMessage = """

\u{001B}[0;35m===========================\u{001B}[0;37m

That's the full process of obfuscation in the Swift Obfuscator 1.0.

It doesn't do anything right now, but stay tuned!

\u{001B}[0;35m===========================\u{001B}[0;37m
"""
  print(farewellMessage)
} catch {
  let error = error as! ShellOutError
  print("STDERR: \(error.message)")
  print("STDOUT: \(error.output)")
}
