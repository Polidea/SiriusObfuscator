//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedDropnote" %target-run-full-obfuscation
import Foundation

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

//override init
class Parent{
  init(p1: String, p2: Int) {}
}
class Child: Parent {
  override init(p1: String, p2: Int){}
}
let c = Child(p1: "p1", p2:42)
