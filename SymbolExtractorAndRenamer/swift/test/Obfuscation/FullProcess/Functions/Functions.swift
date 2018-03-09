//RUN: %target-prepare-obfuscation-for-file "Functions" %target-run-full-obfuscation
import AppKit

// Top-level functions
func firstFunction() { }
func secondFunction() -> Int { return 0 }

firstFunction()
_ = secondFunction()

// Struct methods
struct FirstStruct {
  func method() { }
  static func staticMethod() { }
}

let fsi = FirstStruct()
fsi.method()
FirstStruct.staticMethod()

struct SecondStruct {
  func method() { }
  static func staticMethod() { }
}

let ssi = SecondStruct()
ssi.method()
SecondStruct.staticMethod()

// Class methods
class BaseClass {
  func method() { }
  static func staticMethod() -> Int { return 0 }
}

let bci = BaseClass()
bci.method()
_ = BaseClass.staticMethod()

class DerivedClass: BaseClass {
  override func method() { }
}

let dci = DerivedClass()
dci.method()
_ = DerivedClass.staticMethod()

class SampleClass {
  func method() -> FirstStruct { return FirstStruct() }
  static func staticMethod() { }
}

let sci = SampleClass()
_ = sci.method()
SampleClass.staticMethod()

// Enum methods
enum FirstEnum {
  case value
  func method() { }
}

FirstEnum.value.method()

enum SecondEnum {
  case value
  func method() { }
}

SecondEnum.value.method()

// Protocol methods

protocol SampleProtocol {
  func method()
}

class ConformingClass: SampleProtocol {
  func method() { }
}

struct ConformingStruct: SampleProtocol {
  func method() { }
}

// SDK subclass methods
class CustomView: NSView {
  override func prepareForReuse() { }
}

let cvi = CustomView()
cvi.prepareForReuse()

// SDK protocol methods
class CustomFMDelegate: NSObject, FileManagerDelegate {
  func fileManager(_ fileManager: FileManager, shouldRemoveItemAtPath path: String) -> Bool {
    return false
  }
}

let cfmdi = CustomFMDelegate()
_ = cfmdi.fileManager(FileManager.default, shouldRemoveItemAtPath: "")

// Generic top-level functions
func function<T>() -> T { return T() }
let fvi: Int = function()
let fvsc: SampleClass = function()

// Nested functions
func outerFunction() -> String {
  func innerFunction() -> Int { return 1 }
  return "\(innerFunction())"
}

_ = outerFunction()

// Generic class methods
class GenericClass<T> {
  func method() -> T { return T() }
}

let gcii = GenericClass<Int>()
_ = gcii.method()

let gcsi = GenericClass<SampleClass>()
_ = gcsi.method()

// Protocol extensions
protocol Proto {
  func hello()
}
extension NSString: Proto {}
extension Proto where Self: NSString {
  func hello() {}
}

// Overridden and conforming to protocol at the same time
class Test {}

protocol TestProto {
  func foo(a b: Test)
}

protocol TestProto2 {
  func foo(a b: Test)
}

class Parent {
  func foo(a b: Test) {}
}

class Child: Parent, TestProto, TestProto2 {
  override func foo(a b: Test) { super.foo(a: b) }
}

class Parent2: Parent, TestProto2 {
  override func foo(a b: Test) { super.foo(a: b) }
}

class Child2: Parent2, TestProto {
  override func foo(a b: Test) { super.foo(a: b) }
}

let p = Parent()
p.foo(a: Test())

let c = Child()
c.foo(a: Test())

let p2 = Parent2()
p2.foo(a: Test())

let c2 = Child2()
c2.foo(a: Test())

// parameter names when calling nested functions
class NestedFuncs {
  
  fileprivate func broken() -> [Int] {
    
    func makeInt(withIdentifier identifier: String, model: Int) -> Int {
      return 42
    }
    
    var ints = [Int]()
    ints.append(makeInt(withIdentifier: "", model: 42))
    ints.append(makeInt(withIdentifier: "", model: 42))
    return ints

  }
}

// protocols with associated types
struct TestStruct {}
enum TestEnum {}

protocol ParentProtocol {
  associatedtype Fuzz
  associatedtype Bazz
  associatedtype Gazz

  func foo(_ indexPath: Int) -> String
  func bar(_ fuzz: Fuzz, extBazz bazz: Bazz, extGazz gazz: Gazz, atIndexPath indexPath: Int)
}

protocol ChildProtocol: ParentProtocol {
  var items: [[Gazz]] { get }
}


protocol ChildProtocol2: ChildProtocol { }


final class TestClass {

  var items: [[Gazz]] = [[

    ]]
}

extension TestClass: ChildProtocol2 {

  func foo(_ indexPath: Int) -> String { return "" }

  func bar(_ fuzz: String, extBazz bazz: TestStruct, extGazz gazz: TestEnum, atIndexPath indexPath: Int) {}
}

protocol ParentProtocol2 {
  associatedtype Fuzz
  associatedtype Bazz
  associatedtype Gazz

  func bar(_ fuzz: Fuzz, extBazz bazz: Bazz, gazz: Gazz) -> Void
}

protocol ParentProtocol3 {
  associatedtype Fuzz2
  associatedtype Bazz2
  associatedtype Gazz2

  func bar(_ fuzz: Fuzz2, extBazz bazz: Bazz2, gazz: Gazz2) -> ()
}

extension TestClass: ParentProtocol2, ParentProtocol3 {
  typealias Fuzz = String
  typealias Bazz = TestStruct
  typealias Gazz = TestEnum

  typealias Fuzz2 = TestEnum
  typealias Bazz2 = TestStruct
  typealias Gazz2 = TestEnum

  func bar(_ fuzz: String, extBazz bazz: TestStruct, gazz: TestEnum) {}

  func bar(_ fuzz: TestEnum, extBazz bazz: TestStruct, gazz: TestEnum) {}
}

// protocol functions strikes back

class NotWorkingParent {
  func addSearchItem() {
  }
}

final class NextNotWorking: NotWorkingParent {
  
  override func addSearchItem() {
    let inserter = ItemInserter()
    do {
      let coffee = try inserter.insertEntityWithName("")
      
    } catch {
      
    }
  }
}

protocol ItemInserterType {
  associatedtype Entity
  func insertEntityWithName(_ name: String) throws -> Entity
}

struct ItemInserter: ItemInserterType {
  
  func insertEntityWithName(_ name: String) throws -> String {
    return ""
  }
}
