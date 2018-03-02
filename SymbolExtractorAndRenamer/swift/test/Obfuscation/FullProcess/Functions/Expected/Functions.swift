import AppKit

// Top-level functions
func NF1_firstFunction() { }
func NF1_secondFunction() -> Int { return 0 }

NF1_firstFunction()
_ = NF1_secondFunction()

// Struct methods
struct T1_FirstStruct {
  func NF1_method() { }
  static func NF1_staticMethod() { }
}

let V1_fsi = T1_FirstStruct()
V1_fsi.NF1_method()
T1_FirstStruct.NF1_staticMethod()

struct T1_SecondStruct {
  func NF2_method() { }
  static func NF2_staticMethod() { }
}

let V1_ssi = T1_SecondStruct()
V1_ssi.NF2_method()
T1_SecondStruct.NF2_staticMethod()

// Class methods
class T1_BaseClass {
  func NF3_method() { }
  static func NF3_staticMethod() -> Int { return 0 }
}

let V1_bci = T1_BaseClass()
V1_bci.NF3_method()
_ = T1_BaseClass.NF3_staticMethod()

class T1_DerivedClass: T1_BaseClass {
  override func NF3_method() { }
}

let V1_dci = T1_DerivedClass()
V1_dci.NF3_method()
_ = T1_DerivedClass.NF3_staticMethod()

class T1_SampleClass {
  func NF4_method() -> T1_FirstStruct { return T1_FirstStruct() }
  static func NF4_staticMethod() { }
}

let V1_sci = T1_SampleClass()
_ = V1_sci.NF4_method()
T1_SampleClass.NF4_staticMethod()

// Enum methods
enum T1_FirstEnum {
  case value
  func NF5_method() { }
}

T1_FirstEnum.value.NF5_method()

enum T1_SecondEnum {
  case value
  func NF6_method() { }
}

T1_SecondEnum.value.NF6_method()

// Protocol methods

protocol T1_SampleProtocol {
  func NF7_method()
}

class T1_ConformingClass: T1_SampleProtocol {
  func NF7_method() { }
}

struct T1_ConformingStruct: T1_SampleProtocol {
  func NF7_method() { }
}

// SDK subclass methods
class T1_CustomView: NSView {
  override func prepareForReuse() { }
}

let V1_cvi = T1_CustomView()
V1_cvi.prepareForReuse()

// SDK protocol methods
class T1_CustomFMDelegate: NSObject, FileManagerDelegate {
  func fileManager(_ IP1_fileManager: FileManager, shouldRemoveItemAtPath IP1_path: String) -> Bool {
    return false
  }
}

let V1_cfmdi = T1_CustomFMDelegate()
_ = V1_cfmdi.fileManager(FileManager.default, shouldRemoveItemAtPath: "")

// Generic top-level functions
func NF1_function<T>() -> T { return T() }
let V1_fvi: Int = NF1_function()
let V1_fvsc: T1_SampleClass = NF1_function()

// Nested functions
func NF1_outerFunction() -> String {
  func NF1_innerFunction() -> Int { return 1 }
  return "\(NF1_innerFunction())"
}

_ = NF1_outerFunction()

// Generic class methods
class T1_GenericClass<T> {
  func NF8_method() -> T { return T() }
}

let V1_gcii = T1_GenericClass<Int>()
_ = V1_gcii.NF8_method()

let V1_gcsi = T1_GenericClass<T1_SampleClass>()
_ = V1_gcsi.NF8_method()

// Protocol extensions
protocol T1_Proto {
  func NF1_hello()
}
extension NSString: T1_Proto {}
extension T1_Proto where Self: NSString {
  func NF1_hello() {}
}

// Overridden and conforming to protocol at the same time
class T1_Test {}

protocol T1_TestProto {
  func NF1_foo(EP1_a IP1_b: T1_Test)
}

protocol T1_TestProto2 {
  func NF1_foo(EP1_a IP1_b: T1_Test)
}

class T1_Parent {
  func NF1_foo(EP1_a IP2_b: T1_Test) {}
}

class T1_Child: T1_Parent, T1_TestProto, T1_TestProto2 {
  override func NF1_foo(EP1_a IP1_b: T1_Test) { super.NF1_foo(EP1_a: IP1_b) }
}

class T1_Parent2: T1_Parent, T1_TestProto2 {
  override func NF1_foo(EP1_a IP1_b: T1_Test) { super.NF1_foo(EP1_a: IP1_b) }
}

class T1_Child2: T1_Parent2, T1_TestProto {
  override func NF1_foo(EP1_a IP1_b: T1_Test) { super.NF1_foo(EP1_a: IP1_b) }
}

let V1_p = T1_Parent()
V1_p.NF1_foo(EP1_a: T1_Test())

let V1_c = T1_Child()
V1_c.NF1_foo(EP1_a: T1_Test())

let V1_p2 = T1_Parent2()
V1_p2.NF1_foo(EP1_a: T1_Test())

let V1_c2 = T1_Child2()
V1_c2.NF1_foo(EP1_a: T1_Test())
