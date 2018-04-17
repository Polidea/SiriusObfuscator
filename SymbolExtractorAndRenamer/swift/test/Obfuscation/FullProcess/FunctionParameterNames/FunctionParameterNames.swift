//RUN: %target-prepare-obfuscation-for-file "FunctionParameterNames" %target-run-full-obfuscation

import AppKit

class SampleClass {}

protocol OtherSampleClass {}

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

func genericFunc2<T: OtherSampleClass & SampleClass>(e i: T) {}

func someFunc3<T>(arg: T) where T: SampleClass, T: OtherSampleClass {}

// overriding functions
class Base {
  func baseFunc(param: String) {}
  func baseFunc2(_ intParam: Int) {}
  func baseFunc3(extParam intParam: SampleClass) {}
}

class Derived: Base {
  override func baseFunc(param: String) {}
  override func baseFunc2(_ intParam: Int) {}
  override func baseFunc3(extParam intParam: SampleClass) {}
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

//overriden constructors
class Parent{
  init(p1: String, p2: Int) {}
  init(foo foo:Int, foo bar: SampleClass) { }
  init(extp1 p1: String, extp2 p2: Int) {}
  init(_ p1: String, extp p2: Int) {}
}
class Child: Parent {
  override init(p1: String, p2: Int) {
    super.init(p1: p1, p2: p2)
  }
  override init(foo foo:Int, foo bar: SampleClass) {
    super.init(foo: foo, foo: bar)
  }
  override init(extp1 p1: String, extp2 p2: Int) {
    super.init(extp1: p1, extp2: p2)
  }
  override init(_ p1: String, extp p2: Int) {
    super.init(p1, extp: p2)
  }
}
let c = Child(p1: "p1", p2:42)
let c2 = Child(foo: 42, foo:SampleClass())
let c3 = Child(extp1: "p1", extp2:42)
let c4 = Child("p1", extp:42)

//convenience constructor
class SuperTest {
  init(convP1: Int) {}
  
  convenience init(convP1: Int, convP2: String) {
    self.init(convP1: convP1)
  }
}

let conv = SuperTest(convP1:1, convP2:"asd")

//protocol constructor
protocol ProtoInit {
  init(protoInitParamA: String, protoInitParamB: Int)
}

class ProtoInitClass: ProtoInit {
  required init(protoInitParamA: String, protoInitParamB: Int) {
  }
}
let pic = ProtoInitClass(protoInitParamA: "", protoInitParamB: 42)

// overridden method parameters
final class TestController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
  }
}

// default values
let defaultValue = 42.0

func withDefaultValues(int: Int = 42, string string: String = "42", _ float: Double = defaultValue) {}

class ClassWithDefaultValues {
  func withDefaultValues(int: Int = 42, string string: String = "42", _ float: Double = defaultValue) {}
}

class ClassWithDefaultValuesInInit {
  init(int: Int = 42, string string: String = "42", _ float: Double = defaultValue) {}
}

let someClassWithDefaultValuesInInit1 = ClassWithDefaultValuesInInit()
let someClassWithDefaultValuesInInit2 = ClassWithDefaultValuesInInit(string: "42")
let someClassWithDefaultValuesInInit3 = ClassWithDefaultValuesInInit(int: 42, defaultValue)
let someClassWithDefaultValuesInInit4 = ClassWithDefaultValuesInInit(int: 42, string: "42", defaultValue)

class Foo {
  var FieldA: String
  var FieldB: String?
  
  init(FieldA: String, FieldB: String? = nil) {}
}

let FooObj1 = Foo(FieldA: "test")
let FooObj2 = Foo(FieldA: "test", FieldB: nil)

//setter parameter
class ClassWithSetter {
  var testVar: String {
    get { return "" }
    set(newTestVar) {}
  }
}

// ?
import CoreData

protocol Entity {
    static func entityName() -> String
}

struct CoreDataOperations<T> where T: NSManagedObject, T: Entity {
    let context: NSManagedObjectContext

    init(managedObjectContext context: NSManagedObjectContext) {
        self.context = context
    }
}