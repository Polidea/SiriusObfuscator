import Foundation
import ShellOut

guard let myselfInArguments = CommandLine.arguments.first
else {
    print("Couldn't parse command line arguments")
    exit(1)
}

let arguments = Array(CommandLine.arguments.dropFirst())

do {
  let dirName = try shellOut(to: "dirname", arguments: [myselfInArguments])
  let selfDir = try shellOut(to: ["cd \(dirName)", "pwd"])
  let output = try shellOut(
    to: [
      "export BUNDLE_GEMFILE=\"\(selfDir)/lib/vendor/Gemfile\"",
      "unset BUNDLE_IGNORE_CONFIG",
      "exec \"\(selfDir)/lib/ruby/bin/ruby\" -rbundler/setup \"\(selfDir)/lib/file-extractor/bin/file-extractor\" \"\(arguments.joined(separator: "\" \""))\""
    ]
  )
  print(output)
} catch {
  let error = error as! ShellOutError
  print("STDERR: \(error.message)")
  print("STDOUT: \(error.output)")
}
