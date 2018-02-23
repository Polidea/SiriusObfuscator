//XFAIL: *

//RUN: %target-prepare-obfuscation-for-file "UnsupportedFunctionParameterNames" %target-run-full-obfuscation

class SampleClass {}

func `backticksName`(`backticksExtName` `backTicksIntName`: SampleClass) {}

// overriding functions
class Base {
  func baseFunc2(_ intParam: Int) {}
  func baseFunc3(extParam intParam: SampleClass) {}
  
  subscript(index: Int) -> String { return "" }
  subscript(_ indexInt: Int) -> String { return "" }
  subscript(indexExt indexInt: Int) -> String { return "" }
  
  var testVar: String {
    get{ return "" }
    set(newTestVar) {}
  }
}

class Derived: Base {
  override func baseFunc2(_ intParam: Int) {}
  override func baseFunc3(extParam intParam: SampleClass) {}
  
  override subscript(index: Int) -> String { return "" }
  override subscript(_ indexInt: Int) -> String { return "" }
  override subscript(indexExt indexInt: Int) -> String { return "" }
}

//protocol functions
protocol ProtocolFunc {
  func pFunc2(_ pFunc: Int)
  func pFunc3(extpFunc intpFunc: Int)
  func pFunc4(singleFunc: Int)
}

class ProtocolFunClass: ProtocolFunc {
  func pFunc2(_ pFunc: Int) {}
  func pFunc3(extpFunc intpFunc: Int) {}
  func pFunc4(singleFunc singleIntFunc: Int) {}
}
