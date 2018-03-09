//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedFunctionParameterNames" %target-run-full-obfuscation

class SampleClass {}

func `backticksName`(`backticksExtName` `backTicksIntName`: SampleClass) {}

// overriding functions
class Base {  
  subscript(index: Int) -> String { return "" }
  subscript(_ indexInt: Int) -> String { return "" }
  subscript(indexExt indexInt: Int) -> String { return "" }
}

class Derived: Base {  
  override subscript(index: Int) -> String { return "" }
  override subscript(_ indexInt: Int) -> String { return "" }
  override subscript(indexExt indexInt: Int) -> String { return "" }
}

//protocol functions - internal parameter names in protocol function's definition and implementation should be different
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
