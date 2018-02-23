
class T1_SampleClass {}

func NF1_noParams() {}

func NF1_singleParam(SP1_param: T1_SampleClass) {}

func NF1_singleParam2(EP1_extParam IP1_intParam: T1_SampleClass) {}

func NF1_returnValue() -> T1_SampleClass {
  return T1_SampleClass()
}

func NF1_returnValue2() -> String {
  return "String";
}

func NF1_paramAndReturnValue(SP2_param: T1_SampleClass, EP2_extParam IP2_intParam: Int) -> String {
  return "String";
}

func NF1_intExtParams(EP1_foo IP1_foo:Int, EP2_foo IP1_bar: T1_SampleClass) -> Any? {
  return nil
}

func NF1_genericFun<T, R>(_ IP1_a: inout T, _ IP1_b: inout R) {}

func NF1_genericFunc2<T: String & T1_SampleClass>(EP1_e IP1_i: T) {}

func NF1_someFunc3<T>(SP1_arg: T) where T:T1_SampleClass, T:Int {}

// overriding functions
class T1_Base {
  func NF1_baseFunc(SP3_param: String) {}
  func NF1_baseFunc2(_ IP3_intParam: Int) {}
  func NF1_baseFunc3(EP3_extParam IP4_intParam: T1_SampleClass) {}
}

class T1_Derived: T1_Base {
  override func NF1_baseFunc(param: String) {}
}

// explicit constructor params
class T1_ConstructorParam {
  init(SP1_str: String) {}
  init(_ IP1_int: Int) {}
  init(EP1_extP IP1_intP: T1_SampleClass) {}
}

let _ = T1_ConstructorParam(SP1_str: "")
let _ = T1_ConstructorParam(1)
let _ = T1_ConstructorParam(EP1_extP: T1_SampleClass())

// memberwise constructor params
struct T1_MemberwiseConstructorParam {
  let V1_fieldA: Int
  let V1_fieldB: String
}

let V1_test = T1_MemberwiseConstructorParam(V1_fieldA: 1, V1_fieldB: "")

// default constructor params
struct T1_DefaultConstructorParam {
  let V2_fieldA: Int = 1
  let V2_fieldB: String = ""
}

let _ = T1_DefaultConstructorParam()

//protocol functions
protocol T1_ProtocolFunc {
  func NF1_pFunc(SP1_pFunc: Int)
}

class T1_ProtocolFunClass: T1_ProtocolFunc {
  func NF1_pFunc(SP1_pFunc: Int) {}
}
