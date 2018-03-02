import AppKit

struct T1_DummyStruct {}

// stored let and var properties of different types
class T1_StoredClass {
  let V1_letInt: Int = 0
  var V1_varInt: Int
  let V1_letString: String = "0"
  var V1_varString: String
  let V1_letStruct: T1_DummyStruct = T1_DummyStruct()
  var V1_varStruct: T1_DummyStruct
}

struct T1_StoredStruct {
  let V2_letInt: Int = 0
  var V2_varInt: Int
  let V2_letString: String = "0"
  var V2_varString: String
  let V2_letStruct: T1_DummyStruct = T1_DummyStruct()
  var V2_varStruct: T1_DummyStruct
}

// computed properties of different types
protocol T1_ComputedProtocol {
  var V3_varInt: Int { get }
  var V3_varString: String { get set }
  var V3_varStruct: T1_DummyStruct { get set }
}

class T1_ComputedClass: T1_ComputedProtocol {
  var V3_varInt: Int { return 42 }
  var V3_varString: String { get { return "42" } set {  } }
  var V3_varStruct = T1_DummyStruct()
}

struct T1_ComputedStruct {
  var V4_varInt: Int { return 42 }
  var V4_varString: String { get { return "42" } set {  } }
  var V4_varStruct: T1_DummyStruct = T1_DummyStruct()
}

//computed properties required by other modules
class T1_OtherStruct: NSValidatedUserInterfaceItem {
  var action: Selector? { return nil }
  var tag: Int = 0
}

// stored properties required by other modules
class T1_ViewClass: NSView {
  override var subviews: [NSView] { get { return [] } set { } }
  override var window: NSWindow? { return nil }
}

// properties usage
class T1_SomeClass<GenericParam> {
  var V1_param: String = ""
}

class T1_GenericUsingClass {
  let V1_array: Array<Int> = []
  let V1_map: [String : Int] = [:]
}

class T1_PropertiesUsingClass {
  var V2_array: Array<Int> = []
  var V2_map: [String : Int] = [:]
  var V1_generic = T1_SomeClass<T1_PropertiesUsingClass>()

  func NF1_foo() -> T1_SomeClass<T1_PropertiesUsingClass> {
    V2_array = [42]
    V2_map["42"] = V2_array[0]
    V1_generic.V1_param = "42"
    return V1_generic
  }
}

// implicit error name in catch block should not be renamed
func NF1_canThrowErrors() throws {}
func NF1_a() {
  do {
    try NF1_canThrowErrors()
  } catch {
    error
  }
}

// implicit variable name inside setter in catch block should not be renamed
struct T1_ImplicitSetter {
  var V1_foo: String {
    get {
      return "foo"
    }
    set {
      newValue
    }
  }
}

class T1_SampleClass {
  var V1_prop: String = ""
}

struct T1_SampleStruct {
  var V1_sample = T1_SampleClass()
  func NF2_foo() {
    V1_sample.V1_prop = "42"
  }
}
