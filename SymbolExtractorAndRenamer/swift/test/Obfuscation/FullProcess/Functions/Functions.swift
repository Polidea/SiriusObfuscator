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
