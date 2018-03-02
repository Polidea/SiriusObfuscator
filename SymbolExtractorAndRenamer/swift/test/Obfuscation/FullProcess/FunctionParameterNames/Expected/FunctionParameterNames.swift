
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
  override func NF1_baseFunc(SP3_param: String) {}
  override func NF1_baseFunc2(_ IP5_intParam: Int) {}
  override func NF1_baseFunc3(EP3_extParam IP6_intParam: T1_SampleClass) {}
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

//overriden constructors
class T1_Parent{
  init(SP1_p1: String, SP1_p2: Int) {}
  init(EP3_foo IP2_foo:Int, EP4_foo IP2_bar: T1_SampleClass) { }
  init(EP1_extp1 IP1_p1: String, EP1_extp2 IP1_p2: Int) {}
  init(_ IP1_p1: String, EP1_extp IP1_p2: Int) {}
}
class T1_Child: T1_Parent {
  override init(SP1_p1: String, SP1_p2: Int) {
    super.init(SP1_p1: SP1_p1, SP1_p2: SP1_p2)
  }
  override init(EP3_foo IP3_foo:Int, EP4_foo IP3_bar: T1_SampleClass) {
    super.init(EP3_foo: IP3_foo, EP4_foo: IP3_bar)
  }
  override init(EP1_extp1 IP2_p1: String, EP1_extp2 IP2_p2: Int) {
    super.init(EP1_extp1: IP2_p1, EP1_extp2: IP2_p2)
  }
  override init(_ IP2_p1: String, EP1_extp IP2_p2: Int) {
    super.init(IP2_p1, EP1_extp: IP2_p2)
  }
}
let V1_c = T1_Child(SP1_p1: "p1", SP1_p2:42)
let V1_c2 = T1_Child(EP3_foo: 42, EP4_foo:T1_SampleClass())
let V1_c3 = T1_Child(EP1_extp1: "p1", EP1_extp2:42)
let V1_c4 = T1_Child("p1", EP1_extp:42)

//convenience constructor
class T1_SuperTest {
  init(SP1_convP1: Int) {}
  
  convenience init(SP2_convP1: Int, SP1_convP2: String) {
    self.init(SP1_convP1: SP2_convP1)
  }
}

let V1_conv = T1_SuperTest(SP2_convP1:1, SP1_convP2:"asd")

// default values

let V1_defaultValue = 42.0

func NF1_withDefaultValues(SP1_int: Int = 42, EP1_string IP1_string: String = "42", _ IP1_float: Double = V1_defaultValue) {}

class T1_ClassWithDefaultValues {
  func NF2_withDefaultValues(SP2_int: Int = 42, EP2_string IP2_string: String = "42", _ IP2_float: Double = V1_defaultValue) {}
}

class T1_ClassWithDefaultValuesInInit {
  init(SP3_int: Int = 42, EP3_string IP3_string: String = "42", _ IP3_float: Double = V1_defaultValue) {}
}

let V1_someClassWithDefaultValuesInInit1 = T1_ClassWithDefaultValuesInInit()
let V1_someClassWithDefaultValuesInInit2 = T1_ClassWithDefaultValuesInInit(EP3_string: "42")
let V1_someClassWithDefaultValuesInInit3 = T1_ClassWithDefaultValuesInInit(SP3_int: 42, V1_defaultValue)
let V1_someClassWithDefaultValuesInInit4 = T1_ClassWithDefaultValuesInInit(SP3_int: 42, EP3_string: "42", V1_defaultValue)

class T1_Foo {
  var V1_FieldA: String
  var V1_FieldB: String?
  
  init(SP1_FieldA: String, SP1_FieldB: String? = nil) {}
}

let V1_FooObj1 = T1_Foo(SP1_FieldA: "test")
let V1_FooObj2 = T1_Foo(SP1_FieldA: "test", SP1_FieldB: nil)
