import AppKit

class T1_SomeGenericClass<Param> {}

enum T1_RandomEnum {
  case Foo
}

func NF1_someRandomFunc() -> T1_RandomEnum { return T1_RandomEnum.Foo }

final class T1_TestController2: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for IP1_segue: NSStoryboardSegue, sender: Any?) {
    if case .Foo = NF1_someRandomFunc() , sender is T1_SomeGenericClass<String> {
      let casted = sender as! T1_SomeGenericClass<String>
    }
  }
}

class T1_SampleClass { }
enum T1_SampleEnum {
  case case1
}
let V1_enumCase = T1_SampleEnum.case1
class T1_GenericClass<T> { }

let V1_castedNonOptional = T1_SampleClass()
let V1_castedOptional: T1_SampleClass? = nil
let V1_genericNonOptional = T1_GenericClass<T1_SampleClass>()
let V1_genericOptional: T1_GenericClass<T1_SampleClass>? = nil
let V1_genericParameterOptional: T1_GenericClass<T1_SampleClass>? = nil

// binary-expression with type-casting-operator
let _ = V1_castedNonOptional is T1_SampleClass
let _ = V1_castedNonOptional is T1_SampleClass?
let _ = V1_castedNonOptional is T1_GenericClass<T1_SampleClass>
//let _ = castedNonOptional is GenericClass<SampleClass>? //compiler error
let _ = V1_castedNonOptional is T1_GenericClass<T1_SampleClass?>
let _ = V1_castedNonOptional is T1_GenericClass<Int>
//let _ = castedNonOptional is GenericClass<Int>? //compiler error
let _ = V1_castedNonOptional is T1_GenericClass<Int?>
let _ = V1_castedNonOptional as T1_SampleClass
let _ = V1_castedNonOptional as T1_SampleClass?
//let _ = castedNonOptional as GenericClass<SampleClass> //compiler error
//let _ = castedNonOptional as GenericClass<SampleClass>? //compiler error
//let _ = castedNonOptional as GenericClass<SampleClass?> //compiler error
//let _ = castedNonOptional as GenericClass<Int> //compiler error
//let _ = castedNonOptional as GenericClass<Int>? //compiler error
//let _ = castedNonOptional as GenericClass<Int?> //compiler error
let _ = V1_castedNonOptional as? T1_SampleClass
let _ = V1_castedNonOptional as? T1_SampleClass?
let _ = V1_castedNonOptional as? T1_GenericClass<T1_SampleClass>
//let _ = castedNonOptional as? GenericClass<SampleClass>? //compiler error
let _ = V1_castedNonOptional as? T1_GenericClass<T1_SampleClass?>
let _ = V1_castedNonOptional as? T1_GenericClass<Int>
//let _ = castedNonOptional as? GenericClass<Int>? //compiler error
let _ = V1_castedNonOptional as? T1_GenericClass<Int?>
let _ = V1_castedNonOptional as! T1_SampleClass
let _ = V1_castedNonOptional as! T1_SampleClass?
let _ = V1_castedNonOptional as! T1_GenericClass<T1_SampleClass>
//let _ = castedNonOptional as! GenericClass<SampleClass>? //compiler error
let _ = V1_castedNonOptional as! T1_GenericClass<T1_SampleClass?>
let _ = V1_castedNonOptional as! T1_GenericClass<Int>
//let _ = castedNonOptional as! GenericClass<Int>? //compiler error
let _ = V1_castedNonOptional as! T1_GenericClass<Int?>

let _ = V1_castedOptional is T1_SampleClass
let _ = V1_castedOptional is T1_SampleClass?
let _ = V1_castedOptional is T1_GenericClass<T1_SampleClass>
let _ = V1_castedOptional is T1_GenericClass<T1_SampleClass>?
let _ = V1_castedOptional is T1_GenericClass<T1_SampleClass?>
let _ = V1_castedOptional is T1_GenericClass<Int>
let _ = V1_castedOptional is T1_GenericClass<Int>?
let _ = V1_castedOptional is T1_GenericClass<Int?>
//let _ = castedOptional as SampleClass //compiler error
let _ = V1_castedOptional as T1_SampleClass?
//let _ = castedOptional as GenericClass<SampleClass> //compiler error
//let _ = castedOptional as GenericClass<SampleClass>? //compiler error
//let _ = castedOptional as GenericClass<SampleClass?> //compiler error
//let _ = castedOptional as GenericClass<Int> //compiler error
//let _ = castedOptional as GenericClass<Int>? //compiler error
//let _ = castedOptional as GenericClass<Int?> //compiler error
let _ = V1_castedOptional as? T1_SampleClass
let _ = V1_castedOptional as? T1_SampleClass?
let _ = V1_castedOptional as? T1_GenericClass<T1_SampleClass>
let _ = V1_castedOptional as? T1_GenericClass<T1_SampleClass>?
let _ = V1_castedOptional as? T1_GenericClass<T1_SampleClass?>
let _ = V1_castedOptional as? T1_GenericClass<Int>
let _ = V1_castedOptional as? T1_GenericClass<Int>?
let _ = V1_castedOptional as? T1_GenericClass<Int?>
let _ = V1_castedOptional as! T1_SampleClass
let _ = V1_castedOptional as! T1_SampleClass?
let _ = V1_castedOptional as! T1_GenericClass<T1_SampleClass>
let _ = V1_castedOptional as! T1_GenericClass<T1_SampleClass>?
let _ = V1_castedOptional as! T1_GenericClass<T1_SampleClass?>
let _ = V1_castedOptional as! T1_GenericClass<Int>
let _ = V1_castedOptional as! T1_GenericClass<Int>?
let _ = V1_castedOptional as! T1_GenericClass<Int?>

let _ = V1_genericNonOptional is T1_SampleClass
//let _ = genericNonOptional is SampleClass? //compiler error
let _ = V1_genericNonOptional is T1_GenericClass<T1_SampleClass>
let _ = V1_genericNonOptional is T1_GenericClass<T1_SampleClass>?
let _ = V1_genericNonOptional is T1_GenericClass<T1_SampleClass?>
let _ = V1_genericNonOptional is T1_GenericClass<Int>
//let _ = genericNonOptional is GenericClass<Int>? //compiler error
let _ = V1_genericNonOptional is T1_GenericClass<Int?>
//let _ = genericNonOptional as SampleClass //compiler error
//let _ = genericNonOptional as SampleClass? //compiler error
let _ = V1_genericNonOptional as T1_GenericClass<T1_SampleClass>
let _ = V1_genericNonOptional as T1_GenericClass<T1_SampleClass>?
//let _ = genericNonOptional as GenericClass<SampleClass?> //compiler error
//let _ = genericNonOptional as GenericClass<Int> //compiler error
//let _ = genericNonOptional as GenericClass<Int>? //compiler error
//let _ = genericNonOptional as GenericClass<Int?> //compiler error
let _ = V1_genericNonOptional as? T1_SampleClass
//let _ = genericNonOptional as? SampleClass? //compiler error
let _ = V1_genericNonOptional as? T1_GenericClass<T1_SampleClass>
let _ = V1_genericNonOptional as? T1_GenericClass<T1_SampleClass>?
let _ = V1_genericNonOptional as? T1_GenericClass<T1_SampleClass?>
let _ = V1_genericNonOptional as? T1_GenericClass<Int>
//let _ = genericNonOptional as? GenericClass<Int>? //compiler error
let _ = V1_genericNonOptional as? T1_GenericClass<Int?>
let _ = V1_genericNonOptional as! T1_SampleClass
//let _ = genericNonOptional as! SampleClass? //compiler error
let _ = V1_genericNonOptional as! T1_GenericClass<T1_SampleClass>
let _ = V1_genericNonOptional as! T1_GenericClass<T1_SampleClass>?
let _ = V1_genericNonOptional as! T1_GenericClass<T1_SampleClass?>
let _ = V1_genericNonOptional as! T1_GenericClass<Int>
//let _ = genericNonOptional as! GenericClass<Int>? //compiler error
let _ = V1_genericNonOptional as! T1_GenericClass<Int?>

let _ = V1_genericOptional is T1_SampleClass
let _ = V1_genericOptional is T1_SampleClass?
let _ = V1_genericOptional is T1_GenericClass<T1_SampleClass>
let _ = V1_genericOptional is T1_GenericClass<T1_SampleClass>?
let _ = V1_genericOptional is T1_GenericClass<T1_SampleClass?>
let _ = V1_genericOptional is T1_GenericClass<Int>
let _ = V1_genericOptional is T1_GenericClass<Int>?
let _ = V1_genericOptional is T1_GenericClass<Int?>
//let _ = genericOptional as SampleClass //compiler error
//let _ = genericOptional as SampleClass? //compiler error
//let _ = genericOptional as GenericClass<SampleClass> //compiler error
let _ = V1_genericOptional as T1_GenericClass<T1_SampleClass>?
//let _ = genericOptional as GenericClass<SampleClass?> //compiler error
//let _ = genericOptional as GenericClass<Int> //compiler error
//let _ = genericOptional as GenericClass<Int>? //compiler error
//let _ = genericOptional as GenericClass<Int?> //compiler error
let _ = V1_genericOptional as? T1_SampleClass
let _ = V1_genericOptional as? T1_SampleClass?
let _ = V1_genericOptional as? T1_GenericClass<T1_SampleClass>
let _ = V1_genericOptional as? T1_GenericClass<T1_SampleClass>?
let _ = V1_genericOptional as? T1_GenericClass<T1_SampleClass?>
let _ = V1_genericOptional as? T1_GenericClass<Int>
let _ = V1_genericOptional as? T1_GenericClass<Int>?
let _ = V1_genericOptional as? T1_GenericClass<Int?>
let _ = V1_genericOptional as! T1_SampleClass
let _ = V1_genericOptional as! T1_SampleClass?
let _ = V1_genericOptional as! T1_GenericClass<T1_SampleClass>
let _ = V1_genericOptional as! T1_GenericClass<T1_SampleClass>?
let _ = V1_genericOptional as! T1_GenericClass<T1_SampleClass?>
let _ = V1_genericOptional as! T1_GenericClass<Int>
let _ = V1_genericOptional as! T1_GenericClass<Int>?
let _ = V1_genericOptional as! T1_GenericClass<Int?>

let _ = V1_genericParameterOptional is T1_SampleClass
let _ = V1_genericParameterOptional is T1_SampleClass?
let _ = V1_genericParameterOptional is T1_GenericClass<T1_SampleClass>
let _ = V1_genericParameterOptional is T1_GenericClass<T1_SampleClass>?
let _ = V1_genericParameterOptional is T1_GenericClass<T1_SampleClass?>
let _ = V1_genericParameterOptional is T1_GenericClass<Int>
let _ = V1_genericParameterOptional is T1_GenericClass<Int>?
let _ = V1_genericParameterOptional is T1_GenericClass<Int?>
//let _ = genericParameterOptional as SampleClass //compiler error
//let _ = genericParameterOptional as SampleClass? //compiler error
//let _ = genericParameterOptional as GenericClass<SampleClass> //compiler error
let _ = V1_genericParameterOptional as T1_GenericClass<T1_SampleClass>?
//let _ = genericParameterOptional as GenericClass<SampleClass?> //compiler error
//let _ = genericParameterOptional as GenericClass<Int> //compiler error
//let _ = genericParameterOptional as GenericClass<Int>? //compiler error
//let _ = genericParameterOptional as GenericClass<Int?> //compiler error
let _ = V1_genericParameterOptional as? T1_SampleClass
let _ = V1_genericParameterOptional as? T1_SampleClass?
let _ = V1_genericParameterOptional as? T1_GenericClass<T1_SampleClass>
let _ = V1_genericParameterOptional as? T1_GenericClass<T1_SampleClass>?
let _ = V1_genericParameterOptional as? T1_GenericClass<T1_SampleClass?>
let _ = V1_genericParameterOptional as? T1_GenericClass<Int>
let _ = V1_genericParameterOptional as? T1_GenericClass<Int>?
let _ = V1_genericParameterOptional as? T1_GenericClass<Int?>
let _ = V1_genericParameterOptional as! T1_SampleClass
let _ = V1_genericParameterOptional as! T1_SampleClass?
let _ = V1_genericParameterOptional as! T1_GenericClass<T1_SampleClass>
let _ = V1_genericParameterOptional as! T1_GenericClass<T1_SampleClass>?
let _ = V1_genericParameterOptional as! T1_GenericClass<T1_SampleClass?>
let _ = V1_genericParameterOptional as! T1_GenericClass<Int>
let _ = V1_genericParameterOptional as! T1_GenericClass<Int>?
let _ = V1_genericParameterOptional as! T1_GenericClass<Int?>

// type-casting-pattern in case-condition
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_SampleClass { }
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_SampleClass? { }
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_GenericClass<T1_SampleClass> { }
//if case .case1 = enumCase, castedNonOptional is GenericClass<SampleClass>? { } //compiler error
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_GenericClass<Int> { }
//if case .case1 = enumCase, castedNonOptional is GenericClass<Int>? { } //compiler error
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = castedNonOptional as SampleClass { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as T1_SampleClass? { }
//if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<SampleClass> { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<SampleClass>? { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<Int> { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<Int>? { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<Int?> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as? T1_SampleClass { }
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as? T1_SampleClass? { }
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as? T1_GenericClass<T1_SampleClass> { }
//if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<SampleClass>? { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as? T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as? T1_GenericClass<Int> { }
//if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<Int>? { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as? T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = castedNonOptional as! SampleClass { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as! T1_SampleClass? { }
//if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<SampleClass> { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<SampleClass>? { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<Int> { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<Int>? { } //compiler error
//if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<Int?> { } //compiler error

if case .case1 = V1_enumCase, V1_castedOptional is T1_SampleClass { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_SampleClass? { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_GenericClass<Int> { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_GenericClass<Int>? { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = castedOptional as SampleClass { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedOptional as T1_SampleClass? { }
//if case .case1 = enumCase, let _ = castedOptional as GenericClass<SampleClass> { } //compiler error
//if case .case1 = enumCase, let _ = castedOptional as GenericClass<SampleClass>? { } //compiler error
//if case .case1 = enumCase, let _ = castedOptional as GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = castedOptional as GenericClass<Int> { } //compiler error
//if case .case1 = enumCase, let _ = castedOptional as GenericClass<Int>? { } //compiler error
//if case .case1 = enumCase, let _ = castedOptional as GenericClass<Int?> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_SampleClass { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_SampleClass? { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_GenericClass<Int> { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_GenericClass<Int>? { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as? T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = castedOptional as! SampleClass { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedOptional as! T1_SampleClass? { }
//if case .case1 = enumCase, let _ = castedOptional as! GenericClass<SampleClass> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedOptional as! T1_GenericClass<T1_SampleClass>? { }
//if case .case1 = enumCase, let _ = castedOptional as! GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = castedOptional as! GenericClass<Int> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_castedOptional as! T1_GenericClass<Int>? { }
//if case .case1 = enumCase, let _ = castedOptional as! GenericClass<Int?> { } //compiler error

if case .case1 = V1_enumCase, V1_genericNonOptional is T1_SampleClass { }
//if case .case1 = enumCase, genericNonOptional is SampleClass? { } //compiler error
if case .case1 = V1_enumCase, V1_genericNonOptional is T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, V1_genericNonOptional is T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, V1_genericNonOptional is T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, V1_genericNonOptional is T1_GenericClass<Int> { }
//if case .case1 = enumCase, genericNonOptional is GenericClass<Int>? { } //compiler error
if case .case1 = V1_enumCase, V1_genericNonOptional is T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = genericNonOptional as SampleClass { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as SampleClass? { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<SampleClass> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as T1_GenericClass<T1_SampleClass>? { }
//if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<Int> { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<Int>? { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<Int?> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as? T1_SampleClass { }
//if case .case1 = enumCase, let _ = genericNonOptional as? SampleClass? { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as? T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as? T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as? T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as? T1_GenericClass<Int> { }
//if case .case1 = enumCase, let _ = genericNonOptional as? GenericClass<Int>? { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as? T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = genericNonOptional as! SampleClass { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as! SampleClass? { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<SampleClass> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericNonOptional as! T1_GenericClass<T1_SampleClass>? { }
//if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<Int> { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<Int>? { } //compiler error
//if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<Int?> { } //compiler error

if case .case1 = V1_enumCase, V1_genericOptional is T1_SampleClass { }
if case .case1 = V1_enumCase, V1_genericOptional is T1_SampleClass? { }
if case .case1 = V1_enumCase, V1_genericOptional is T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, V1_genericOptional is T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, V1_genericOptional is T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, V1_genericOptional is T1_GenericClass<Int> { }
if case .case1 = V1_enumCase, V1_genericOptional is T1_GenericClass<Int>? { }
if case .case1 = V1_enumCase, V1_genericOptional is T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = genericOptional as SampleClass { } //compiler error
//if case .case1 = enumCase, let _ = genericOptional as SampleClass? { } //compiler error
//if case .case1 = enumCase, let _ = genericOptional as GenericClass<SampleClass> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericOptional as T1_GenericClass<T1_SampleClass>? { }
//if case .case1 = enumCase, let _ = genericOptional as GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = genericOptional as GenericClass<Int> { } //compiler error
//if case .case1 = enumCase, let _ = genericOptional as GenericClass<Int>? { } //compiler error
//if case .case1 = enumCase, let _ = genericOptional as GenericClass<Int?> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_SampleClass { }
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_SampleClass? { }
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_GenericClass<Int> { }
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_GenericClass<Int>? { }
if case .case1 = V1_enumCase, let _ = V1_genericOptional as? T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = genericOptional as! SampleClass { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericOptional as! T1_SampleClass? { }
//if case .case1 = enumCase, let _ = genericOptional as! GenericClass<SampleClass> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericOptional as! T1_GenericClass<T1_SampleClass>? { }
//if case .case1 = enumCase, let _ = genericOptional as! GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = genericOptional as! GenericClass<Int> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericOptional as! T1_GenericClass<Int>? { }
//if case .case1 = enumCase, let _ = genericOptional as! GenericClass<Int?> { } //compiler error

if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_SampleClass { }
if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_SampleClass? { }
if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_GenericClass<Int> { }
if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_GenericClass<Int>? { }
if case .case1 = V1_enumCase, V1_genericParameterOptional is T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = genericParameterOptional as SampleClass { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as SampleClass? { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<SampleClass> { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<SampleClass>? { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<Int> { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<Int>? { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<Int?> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_SampleClass { }
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_SampleClass? { }
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_GenericClass<T1_SampleClass> { }
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_GenericClass<T1_SampleClass>? { }
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_GenericClass<T1_SampleClass?> { }
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_GenericClass<Int> { }
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_GenericClass<Int>? { }
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as? T1_GenericClass<Int?> { }
//if case .case1 = enumCase, let _ = genericParameterOptional as! SampleClass { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as! T1_SampleClass? { }
//if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<SampleClass> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as! T1_GenericClass<T1_SampleClass>? { }
//if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<SampleClass?> { } //compiler error
//if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<Int> { } //compiler error
if case .case1 = V1_enumCase, let _ = V1_genericParameterOptional as! T1_GenericClass<Int>? { }
//if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<Int?> { } //compiler error
