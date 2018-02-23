//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedDropnote" %target-run-full-obfuscation
import Foundation

class Test {
  func testFunc() {}
}

// init param FieldA is not renamed if there is a second param with default value
class Foo {
  var FieldA: String
  var FieldB: String?
  
  init(FieldA: String, FieldB: String? = nil) {}
}
let FooObj = Foo(FieldA: "test")

// type is not renamed in if case
let num = 42
if case 0...225 = num, num is Test {
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

//error name in catch block should not be renamed
func canThrowErrors() throws {}
func a() {
  do {
    try canThrowErrors()
  } catch {
    error
  }
}

//protocol stuff
protocol Proto {
  func hello()
}
extension NSString: Proto {}
extension Proto where Self: NSString {
  func hello() {}
}
