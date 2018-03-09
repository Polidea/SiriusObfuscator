//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedDropnote" %target-run-full-obfuscation


import AppKit

class Test {
  func testFunc() {}
}

// debug blocks are omitted
final class DebugBlock {
  fileprivate init() {
    #if !DEBUG
      let testInDebug = Test()
    #endif
  }
}
