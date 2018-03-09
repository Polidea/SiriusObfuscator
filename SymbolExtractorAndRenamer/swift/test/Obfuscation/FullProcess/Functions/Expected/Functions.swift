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

// parameter names when calling nested functions
class T1_NestedFuncs {
  
  fileprivate func NF1_broken() -> [Int] {
    
    func NF1_makeInt(EP1_withIdentifier IP1_identifier: String, SP1_model: Int) -> Int {
      return 42
    }
    
    var ints = [Int]()
    ints.append(NF1_makeInt(EP1_withIdentifier: "", SP1_model: 42))
    ints.append(NF1_makeInt(EP1_withIdentifier: "", SP1_model: 42))
    return ints
  }
}

// protocols with associated types
struct T1_TestStruct {}
enum T1_TestEnum {}

protocol T1_ParentProtocol {
  associatedtype Fuzz
  associatedtype Bazz
  associatedtype Gazz

  func NF2_foo(_ IP1_indexPath: Int) -> String
  func NF1_bar(_ IP1_fuzz: Fuzz, EP1_extBazz IP1_bazz: Bazz, EP1_extGazz IP1_gazz: Gazz, EP1_atIndexPath IP2_indexPath: Int)
}

protocol T1_ChildProtocol: T1_ParentProtocol {
  var V1_items: [[Gazz]] { get }
}


protocol T1_ChildProtocol2: T1_ChildProtocol { }


final class T1_TestClass {

  var V1_items: [[Gazz]] = [[

    ]]
}

extension T1_TestClass: T1_ChildProtocol2 {

  func NF2_foo(_ IP1_indexPath: Int) -> String { return "" }

  func NF1_bar(_ IP1_fuzz: String, EP1_extBazz IP1_bazz: T1_TestStruct, EP1_extGazz IP1_gazz: T1_TestEnum, EP1_atIndexPath IP2_indexPath: Int) {}
}

protocol T1_ParentProtocol2 {
  associatedtype Fuzz
  associatedtype Bazz
  associatedtype Gazz

  func NF2_bar(_ IP2_fuzz: Fuzz, EP2_extBazz IP2_bazz: Bazz, SP1_gazz: Gazz) -> Void
}

protocol T1_ParentProtocol3 {
  associatedtype Fuzz2
  associatedtype Bazz2
  associatedtype Gazz2

  func NF2_bar(_ IP2_fuzz: Fuzz2, EP2_extBazz IP2_bazz: Bazz2, SP1_gazz: Gazz2) -> ()
}

extension T1_TestClass: T1_ParentProtocol2, T1_ParentProtocol3 {
  typealias Fuzz = String
  typealias Bazz = T1_TestStruct
  typealias Gazz = T1_TestEnum

  typealias Fuzz2 = T1_TestEnum
  typealias Bazz2 = T1_TestStruct
  typealias Gazz2 = T1_TestEnum

  func NF2_bar(_ IP2_fuzz: String, EP2_extBazz IP2_bazz: T1_TestStruct, SP1_gazz: T1_TestEnum) {}

  func NF2_bar(_ IP2_fuzz: T1_TestEnum, EP2_extBazz IP2_bazz: T1_TestStruct, SP1_gazz: T1_TestEnum) {}
}

// protocol functions strikes back

class T1_NotWorkingParent {
  func NF1_addSearchItem() {
  }
}

final class T1_NextNotWorking: T1_NotWorkingParent {
  
  override func NF1_addSearchItem() {
    let inserter = T1_ItemInserter()
    do {
      let coffee = try inserter.NF1_insertEntityWithName("")
      
    } catch {
      
    }
  }
}

protocol T1_ItemInserterType {
  associatedtype Entity
  func NF1_insertEntityWithName(_ IP1_name: String) throws -> Entity
}

struct T1_ItemInserter: T1_ItemInserterType {
  
  func NF1_insertEntityWithName(_ IP1_name: String) throws -> String {
    return ""
  }
}
