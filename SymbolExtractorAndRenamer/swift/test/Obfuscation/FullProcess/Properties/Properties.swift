//RUN: %target-prepare-obfuscation-for-file "Properties" %target-run-full-obfuscation

import AppKit

struct DummyStruct {}

// stored let and var properties of different types
class StoredClass {
  let letInt: Int = 0
  var varInt: Int
  let letString: String = "0"
  var varString: String
  let letStruct: DummyStruct = DummyStruct()
  var varStruct: DummyStruct
}

struct StoredStruct {
  let letInt: Int = 0
  var varInt: Int
  let letString: String = "0"
  var varString: String
  let letStruct: DummyStruct = DummyStruct()
  var varStruct: DummyStruct
}

// computed properties of different types
protocol ComputedProtocol {
  var varInt: Int { get }
  var varString: String { get set }
  var varStruct: DummyStruct { get set }
}

class ComputedClass: ComputedProtocol {
  var varInt: Int { return 42 }
  var varString: String { get { return "42" } set {  } }
  var varStruct = DummyStruct()
}

struct ComputedStruct {
  var varInt: Int { return 42 }
  var varString: String { get { return "42" } set {  } }
  var varStruct: DummyStruct = DummyStruct()
}

//computed properties required by other modules
class OtherStruct: NSValidatedUserInterfaceItem {
  var action: Selector? { return nil }
  var tag: Int = 0
}

// stored properties required by other modules
class ViewClass: NSView {
  override var subviews: [NSView] { get { return [] } set { } }
  override var window: NSWindow? { return nil }
}

// properties usage
class SomeClass<GenericParam> {
  var param: String = ""
}

class GenericUsingClass {
  let array: Array<Int> = []
  let map: [String : Int] = [:]
}

class PropertiesUsingClass {
  var array: Array<Int> = []
  var map: [String : Int] = [:]
  var generic = SomeClass<PropertiesUsingClass>()

  func foo() -> SomeClass<PropertiesUsingClass> {
    array = [42]
    map["42"] = array[0]
    generic.param = "42"
    return generic
  }
}

// implicit error name in catch block should not be renamed
func canThrowErrors() throws {}
func a() {
  do {
    try canThrowErrors()
  } catch {
    error
  }
}

// implicit variable name inside setter in catch block should not be renamed
struct ImplicitSetter {
  var foo: String {
    get {
      return "foo"
    }
    set {
      newValue
    }
  }
}

// protocol vars in extensions and explicit setter
class TestWithBool {
  var isFoo = false
}

func foo(boolParam: Bool) {}

protocol Activable {
  var active: Bool { get set }
}

extension Activable where Self: TestWithBool {
  var active: Bool {
    get {
      return isFoo
    }
    set(activeValue) {
      foo(boolParam: activeValue)
    }
  }
}

class SampleClass {
  var prop: String = ""
}

struct SampleStruct {
  var sample = SampleClass()
  func foo() {
    sample.prop = "42"
  }
}

// for each stuff

final class ForEachController: NSViewController {
  
  var unitsSegmentedControl: NSSegmentedControl!
  
  var titles: [String] = []
  
  fileprivate func buggyFunc() {
    titles.enumerated().map {
      index, title in (title, index)
      }.forEach(unitsSegmentedControl.setLabel(_:forSegment:))
    
    unitsSegmentedControl.selectedSegment = 0
  }
}
