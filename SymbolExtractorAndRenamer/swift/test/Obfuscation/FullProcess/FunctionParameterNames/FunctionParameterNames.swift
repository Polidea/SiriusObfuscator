//RUN: %target-prepare-obfuscation-for-file "FunctionParameterNames" %target-run-full-obfuscation

class SampleClass {}

func noParams() {}

func singleParam(param: SampleClass) {}

func singleParam2(extParam intParam: SampleClass) {}

func returnValue() -> SampleClass {
  return SampleClass()
}

func returnValue2() -> String {
  return "String";
}

func paramAndReturnValue(param: SampleClass, extParam intParam: Int) -> String {
  return "String";
}

func intExtParams(foo foo:Int, foo bar: SampleClass) -> Any? {
  return nil
}

func genericFun<T, R>(_ a: inout T, _ b: inout R) {}

func genericFunc2<T: String & SampleClass>(e i: T) {}

func someFunc3<T>(arg: T) where T:SampleClass, T:Int {}

// overriding functions
class Base {
  func baseFunc(param: String) {}
  func baseFunc2(_ intParam: Int) {}
  func baseFunc3(extParam intParam: SampleClass) {}
}

class Derived: Base {
  override func baseFunc(param: String) {}
}

// explicit constructor params
class ConstructorParam {
  init(str: String) {}
  init(_ int: Int) {}
  init(extP intP: SampleClass) {}
}

let _ = ConstructorParam(str: "")
let _ = ConstructorParam(1)
let _ = ConstructorParam(extP: SampleClass())

// memberwise constructor params
struct MemberwiseConstructorParam {
  let fieldA: Int
  let fieldB: String
}

let test = MemberwiseConstructorParam(fieldA: 1, fieldB: "")

// default constructor params
struct DefaultConstructorParam {
  let fieldA: Int = 1
  let fieldB: String = ""
}

let _ = DefaultConstructorParam()

//protocol functions
protocol ProtocolFunc {
  func pFunc(pFunc: Int)
}

class ProtocolFunClass: ProtocolFunc {
  func pFunc(pFunc: Int) {}
}



