import Foundation

class SampleClass { }

enum SampleEnum {
  case case1
}

class GenericClass<T> { }


class TestClass {
  let enumCase = SampleEnum.case1
  
  let castedNonOptional = SampleClass()
  let castedOptional: SampleClass? = nil
  let genericNonOptional = GenericClass<SampleClass>()
  let genericOptional: GenericClass<SampleClass>? = nil
  let genericParameterOptional: GenericClass<SampleClass>? = nil
  
  func testFunc() {

    // binary-expression with type-casting-operator
    let _ = castedNonOptional is SampleClass
    let _ = castedNonOptional is SampleClass?
    let _ = castedNonOptional is GenericClass<SampleClass>
    //let _ = castedNonOptional is GenericClass<SampleClass>? //compiler error
    let _ = castedNonOptional is GenericClass<SampleClass?>
    let _ = castedNonOptional is GenericClass<Int>
    //let _ = castedNonOptional is GenericClass<Int>? //compiler error
    let _ = castedNonOptional is GenericClass<Int?>
    let _ = castedNonOptional as SampleClass
    let _ = castedNonOptional as SampleClass?
    //let _ = castedNonOptional as GenericClass<SampleClass> //compiler error
    //let _ = castedNonOptional as GenericClass<SampleClass>? //compiler error
    //let _ = castedNonOptional as GenericClass<SampleClass?> //compiler error
    //let _ = castedNonOptional as GenericClass<Int> //compiler error
    //let _ = castedNonOptional as GenericClass<Int>? //compiler error
    //let _ = castedNonOptional as GenericClass<Int?> //compiler error
    let _ = castedNonOptional as? SampleClass
    let _ = castedNonOptional as? SampleClass?
    let _ = castedNonOptional as? GenericClass<SampleClass>
    //let _ = castedNonOptional as? GenericClass<SampleClass>? //compiler error
    let _ = castedNonOptional as? GenericClass<SampleClass?>
    let _ = castedNonOptional as? GenericClass<Int>
    //let _ = castedNonOptional as? GenericClass<Int>? //compiler error
    let _ = castedNonOptional as? GenericClass<Int?>
    let _ = castedNonOptional as! SampleClass
    let _ = castedNonOptional as! SampleClass?
    let _ = castedNonOptional as! GenericClass<SampleClass>
    //let _ = castedNonOptional as! GenericClass<SampleClass>? //compiler error
    let _ = castedNonOptional as! GenericClass<SampleClass?>
    let _ = castedNonOptional as! GenericClass<Int>
    //let _ = castedNonOptional as! GenericClass<Int>? //compiler error
    let _ = castedNonOptional as! GenericClass<Int?>

    let _ = castedOptional is SampleClass
    let _ = castedOptional is SampleClass?
    let _ = castedOptional is GenericClass<SampleClass?>
    let _ = castedOptional is GenericClass<SampleClass>?
    let _ = castedOptional is GenericClass<SampleClass?>
    let _ = castedOptional is GenericClass<Int>
    let _ = castedOptional is GenericClass<Int>?
    let _ = castedOptional is GenericClass<Int?>
    //let _ = castedOptional as SampleClass //compiler error
    let _ = castedOptional as SampleClass?
    //let _ = castedOptional as GenericClass<SampleClass> //compiler error
    //let _ = castedOptional as GenericClass<SampleClass>? //compiler error
    //let _ = castedOptional as GenericClass<SampleClass?> //compiler error
    //let _ = castedOptional as GenericClass<Int> //compiler error
    //let _ = castedOptional as GenericClass<Int>? //compiler error
    //let _ = castedOptional as GenericClass<Int?> //compiler error
    let _ = castedOptional as? SampleClass
    let _ = castedOptional as? SampleClass?
    let _ = castedOptional as? GenericClass<SampleClass>
    let _ = castedOptional as? GenericClass<SampleClass>?
    let _ = castedOptional as? GenericClass<SampleClass?>
    let _ = castedOptional as? GenericClass<Int>
    let _ = castedOptional as? GenericClass<Int>?
    let _ = castedOptional as? GenericClass<Int?>
    let _ = castedOptional as! SampleClass
    let _ = castedOptional as! SampleClass?
    let _ = castedOptional as! GenericClass<SampleClass>
    let _ = castedOptional as! GenericClass<SampleClass>?
    let _ = castedOptional as! GenericClass<SampleClass?>
    let _ = castedOptional as! GenericClass<Int>
    let _ = castedOptional as! GenericClass<Int>?
    let _ = castedOptional as! GenericClass<Int?>

    let _ = genericNonOptional is SampleClass
    //let _ = genericNonOptional is SampleClass? //compiler error
    let _ = genericNonOptional is GenericClass<SampleClass>
    let _ = genericNonOptional is GenericClass<SampleClass>?
    let _ = genericNonOptional is GenericClass<SampleClass?>
    let _ = genericNonOptional is GenericClass<Int>
    //let _ = genericNonOptional is GenericClass<Int>? //compiler error
    let _ = genericNonOptional is GenericClass<Int?>
    //let _ = genericNonOptional as SampleClass //compiler error
    //let _ = genericNonOptional as SampleClass? //compiler error
    let _ = genericNonOptional as GenericClass<SampleClass>
    let _ = genericNonOptional as GenericClass<SampleClass>?
    //let _ = genericNonOptional as GenericClass<SampleClass?> //compiler error
    //let _ = genericNonOptional as GenericClass<Int> //compiler error
    //let _ = genericNonOptional as GenericClass<Int>? //compiler error
    //let _ = genericNonOptional as GenericClass<Int?> //compiler error
    let _ = genericNonOptional as? SampleClass
    //let _ = genericNonOptional as? SampleClass? //compiler error
    let _ = genericNonOptional as? GenericClass<SampleClass>
    let _ = genericNonOptional as? GenericClass<SampleClass>?
    let _ = genericNonOptional as? GenericClass<SampleClass?>
    let _ = genericNonOptional as? GenericClass<Int>
    //let _ = genericNonOptional as? GenericClass<Int>? //compiler error
    let _ = genericNonOptional as? GenericClass<Int?>
    let _ = genericNonOptional as! SampleClass
    //let _ = genericNonOptional as! SampleClass? //compiler error
    let _ = genericNonOptional as! GenericClass<SampleClass>
    let _ = genericNonOptional as! GenericClass<SampleClass>?
    let _ = genericNonOptional as! GenericClass<SampleClass?>
    let _ = genericNonOptional as! GenericClass<Int>
    //let _ = genericNonOptional as! GenericClass<Int>? //compiler error
    let _ = genericNonOptional as! GenericClass<Int?>

    let _ = genericOptional is SampleClass
    let _ = genericOptional is SampleClass?
    let _ = genericOptional is GenericClass<SampleClass>
    let _ = genericOptional is GenericClass<SampleClass>?
    let _ = genericOptional is GenericClass<SampleClass?>
    let _ = genericOptional is GenericClass<Int>
    let _ = genericOptional is GenericClass<Int>?
    let _ = genericOptional is GenericClass<Int?>
    //let _ = genericOptional as SampleClass //compiler error
    //let _ = genericOptional as SampleClass? //compiler error
    //let _ = genericOptional as GenericClass<SampleClass> //compiler error
    let _ = genericOptional as GenericClass<SampleClass>?
    //let _ = genericOptional as GenericClass<SampleClass?> //compiler error
    //let _ = genericOptional as GenericClass<Int> //compiler error
    //let _ = genericOptional as GenericClass<Int>? //compiler error
    //let _ = genericOptional as GenericClass<Int?> //compiler error
    let _ = genericOptional as? SampleClass
    let _ = genericOptional as? SampleClass?
    let _ = genericOptional as? GenericClass<SampleClass>
    let _ = genericOptional as? GenericClass<SampleClass>?
    let _ = genericOptional as? GenericClass<SampleClass?>
    let _ = genericOptional as? GenericClass<Int>
    let _ = genericOptional as? GenericClass<Int>?
    let _ = genericOptional as? GenericClass<Int?>
    let _ = genericOptional as! SampleClass
    let _ = genericOptional as! SampleClass?
    let _ = genericOptional as! GenericClass<SampleClass>
    let _ = genericOptional as! GenericClass<SampleClass>?
    let _ = genericOptional as! GenericClass<SampleClass?>
    let _ = genericOptional as! GenericClass<Int>
    let _ = genericOptional as! GenericClass<Int>?
    let _ = genericOptional as! GenericClass<Int?>

    let _ = genericParameterOptional is SampleClass
    let _ = genericParameterOptional is SampleClass?
    let _ = genericParameterOptional is GenericClass<SampleClass>
    let _ = genericParameterOptional is GenericClass<SampleClass>?
    let _ = genericParameterOptional is GenericClass<SampleClass?>
    let _ = genericParameterOptional is GenericClass<Int>
    let _ = genericParameterOptional is GenericClass<Int>?
    let _ = genericParameterOptional is GenericClass<Int?>
    //let _ = genericParameterOptional as SampleClass //compiler error
    //let _ = genericParameterOptional as SampleClass? //compiler error
    //let _ = genericParameterOptional as GenericClass<SampleClass> //compiler error
    let _ = genericParameterOptional as GenericClass<SampleClass>?
    //let _ = genericParameterOptional as GenericClass<SampleClass?> //compiler error
    //let _ = genericParameterOptional as GenericClass<Int> //compiler error
    //let _ = genericParameterOptional as GenericClass<Int>? //compiler error
    //let _ = genericParameterOptional as GenericClass<Int?> //compiler error
    let _ = genericParameterOptional as? SampleClass
    let _ = genericParameterOptional as? SampleClass?
    let _ = genericParameterOptional as? GenericClass<SampleClass>
    let _ = genericParameterOptional as? GenericClass<SampleClass>?
    let _ = genericParameterOptional as? GenericClass<SampleClass?>
    let _ = genericParameterOptional as? GenericClass<Int>
    let _ = genericParameterOptional as? GenericClass<Int>?
    let _ = genericParameterOptional as? GenericClass<Int?>
    let _ = genericParameterOptional as! SampleClass
    let _ = genericParameterOptional as! SampleClass?
    let _ = genericParameterOptional as! GenericClass<SampleClass>
    let _ = genericParameterOptional as! GenericClass<SampleClass>?
    let _ = genericParameterOptional as! GenericClass<SampleClass?>
    let _ = genericParameterOptional as! GenericClass<Int>
    let _ = genericParameterOptional as! GenericClass<Int>?
    let _ = genericParameterOptional as! GenericClass<Int?>

    // type-casting-pattern in case-condition
    if case .case1 = enumCase, castedNonOptional is SampleClass { }
    if case .case1 = enumCase, castedNonOptional is SampleClass? { }
    if case .case1 = enumCase, castedNonOptional is GenericClass<SampleClass> { }
    //if case .case1 = enumCase, castedNonOptional is GenericClass<SampleClass>? { } //compiler error
    if case .case1 = enumCase, castedNonOptional is GenericClass<SampleClass?> { }
    if case .case1 = enumCase, castedNonOptional is GenericClass<Int> { }
    //if case .case1 = enumCase, castedNonOptional is GenericClass<Int>? { } //compiler error
    if case .case1 = enumCase, castedNonOptional is GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = castedNonOptional as SampleClass { } //compiler error
    if case .case1 = enumCase, let _ = castedNonOptional as SampleClass? { }
    //if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<SampleClass> { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<SampleClass>? { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<Int> { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<Int>? { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as GenericClass<Int?> { } //compiler error
    if case .case1 = enumCase, let _ = castedNonOptional as? SampleClass { }
    if case .case1 = enumCase, let _ = castedNonOptional as? SampleClass? { }
    if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<SampleClass> { }
    //if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<SampleClass>? { } //compiler error
    if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<SampleClass?> { }
    if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<Int> { }
    //if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<Int>? { } //compiler error
    if case .case1 = enumCase, let _ = castedNonOptional as? GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = castedNonOptional as! SampleClass { } //compiler error
    if case .case1 = enumCase, let _ = castedNonOptional as! SampleClass? { }
    //if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<SampleClass> { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<SampleClass>? { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<Int> { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<Int>? { } //compiler error
    //if case .case1 = enumCase, let _ = castedNonOptional as! GenericClass<Int?> { } //compiler error

    if case .case1 = enumCase, castedOptional is SampleClass { }
    if case .case1 = enumCase, castedOptional is SampleClass? { }
    if case .case1 = enumCase, castedOptional is GenericClass<SampleClass> { }
    if case .case1 = enumCase, castedOptional is GenericClass<SampleClass>? { }
    if case .case1 = enumCase, castedOptional is GenericClass<SampleClass?> { }
    if case .case1 = enumCase, castedOptional is GenericClass<Int> { }
    if case .case1 = enumCase, castedOptional is GenericClass<Int>? { }
    if case .case1 = enumCase, castedOptional is GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = castedOptional as SampleClass { } //compiler error
    if case .case1 = enumCase, let _ = castedOptional as SampleClass? { }
    //if case .case1 = enumCase, let _ = castedOptional as GenericClass<SampleClass> { } //compiler error
    //if case .case1 = enumCase, let _ = castedOptional as GenericClass<SampleClass>? { } //compiler error
    //if case .case1 = enumCase, let _ = castedOptional as GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = castedOptional as GenericClass<Int> { } //compiler error
    //if case .case1 = enumCase, let _ = castedOptional as GenericClass<Int>? { } //compiler error
    //if case .case1 = enumCase, let _ = castedOptional as GenericClass<Int?> { } //compiler error
    if case .case1 = enumCase, let _ = castedOptional as? SampleClass { }
    if case .case1 = enumCase, let _ = castedOptional as? SampleClass? { }
    if case .case1 = enumCase, let _ = castedOptional as? GenericClass<SampleClass> { }
    if case .case1 = enumCase, let _ = castedOptional as? GenericClass<SampleClass>? { }
    if case .case1 = enumCase, let _ = castedOptional as? GenericClass<SampleClass?> { }
    if case .case1 = enumCase, let _ = castedOptional as? GenericClass<Int> { }
    if case .case1 = enumCase, let _ = castedOptional as? GenericClass<Int>? { }
    if case .case1 = enumCase, let _ = castedOptional as? GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = castedOptional as! SampleClass { } //compiler error
    if case .case1 = enumCase, let _ = castedOptional as! SampleClass? { }
    //if case .case1 = enumCase, let _ = castedOptional as! GenericClass<SampleClass> { } //compiler error
    if case .case1 = enumCase, let _ = castedOptional as! GenericClass<SampleClass>? { }
    //if case .case1 = enumCase, let _ = castedOptional as! GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = castedOptional as! GenericClass<Int> { } //compiler error
    if case .case1 = enumCase, let _ = castedOptional as! GenericClass<Int>? { }
    //if case .case1 = enumCase, let _ = castedOptional as! GenericClass<Int?> { } //compiler error

    if case .case1 = enumCase, genericNonOptional is SampleClass { }
    //if case .case1 = enumCase, genericNonOptional is SampleClass? { } //compiler error
    if case .case1 = enumCase, genericNonOptional is GenericClass<SampleClass> { }
    if case .case1 = enumCase, genericNonOptional is GenericClass<SampleClass>? { }
    if case .case1 = enumCase, genericNonOptional is GenericClass<SampleClass?> { }
    if case .case1 = enumCase, genericNonOptional is GenericClass<Int> { }
    //if case .case1 = enumCase, genericNonOptional is GenericClass<Int>? { } //compiler error
    if case .case1 = enumCase, genericNonOptional is GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = genericNonOptional as SampleClass { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as SampleClass? { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<SampleClass> { } //compiler error
    if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<SampleClass>? { }
    //if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<Int> { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<Int>? { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as GenericClass<Int?> { } //compiler error
    if case .case1 = enumCase, let _ = genericNonOptional as? SampleClass { }
    //if case .case1 = enumCase, let _ = genericNonOptional as? SampleClass? { } //compiler error
    if case .case1 = enumCase, let _ = genericNonOptional as? GenericClass<SampleClass> { }
    if case .case1 = enumCase, let _ = genericNonOptional as? GenericClass<SampleClass>? { }
    if case .case1 = enumCase, let _ = genericNonOptional as? GenericClass<SampleClass?> { }
    if case .case1 = enumCase, let _ = genericNonOptional as? GenericClass<Int> { }
    //if case .case1 = enumCase, let _ = genericNonOptional as? GenericClass<Int>? { } //compiler error
    if case .case1 = enumCase, let _ = genericNonOptional as? GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = genericNonOptional as! SampleClass { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as! SampleClass? { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<SampleClass> { } //compiler error
    if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<SampleClass>? { }
    //if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<Int> { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<Int>? { } //compiler error
    //if case .case1 = enumCase, let _ = genericNonOptional as! GenericClass<Int?> { } //compiler error

    if case .case1 = enumCase, genericOptional is SampleClass { }
    if case .case1 = enumCase, genericOptional is SampleClass? { }
    if case .case1 = enumCase, genericOptional is GenericClass<SampleClass> { }
    if case .case1 = enumCase, genericOptional is GenericClass<SampleClass>? { }
    if case .case1 = enumCase, genericOptional is GenericClass<SampleClass?> { }
    if case .case1 = enumCase, genericOptional is GenericClass<Int> { }
    if case .case1 = enumCase, genericOptional is GenericClass<Int>? { }
    if case .case1 = enumCase, genericOptional is GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = genericOptional as SampleClass { } //compiler error
    //if case .case1 = enumCase, let _ = genericOptional as SampleClass? { } //compiler error
    //if case .case1 = enumCase, let _ = genericOptional as GenericClass<SampleClass> { } //compiler error
    if case .case1 = enumCase, let _ = genericOptional as GenericClass<SampleClass>? { }
    //if case .case1 = enumCase, let _ = genericOptional as GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = genericOptional as GenericClass<Int> { } //compiler error
    //if case .case1 = enumCase, let _ = genericOptional as GenericClass<Int>? { } //compiler error
    //if case .case1 = enumCase, let _ = genericOptional as GenericClass<Int?> { } //compiler error
    if case .case1 = enumCase, let _ = genericOptional as? SampleClass { }
    if case .case1 = enumCase, let _ = genericOptional as? SampleClass? { }
    if case .case1 = enumCase, let _ = genericOptional as? GenericClass<SampleClass> { }
    if case .case1 = enumCase, let _ = genericOptional as? GenericClass<SampleClass>? { }
    if case .case1 = enumCase, let _ = genericOptional as? GenericClass<SampleClass?> { }
    if case .case1 = enumCase, let _ = genericOptional as? GenericClass<Int> { }
    if case .case1 = enumCase, let _ = genericOptional as? GenericClass<Int>? { }
    if case .case1 = enumCase, let _ = genericOptional as? GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = genericOptional as! SampleClass { } //compiler error
    if case .case1 = enumCase, let _ = genericOptional as! SampleClass? { }
    //if case .case1 = enumCase, let _ = genericOptional as! GenericClass<SampleClass> { } //compiler error
    if case .case1 = enumCase, let _ = genericOptional as! GenericClass<SampleClass>? { }
    //if case .case1 = enumCase, let _ = genericOptional as! GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = genericOptional as! GenericClass<Int> { } //compiler error
    if case .case1 = enumCase, let _ = genericOptional as! GenericClass<Int>? { }
    //if case .case1 = enumCase, let _ = genericOptional as! GenericClass<Int?> { } //compiler error

    if case .case1 = enumCase, genericParameterOptional is SampleClass { }
    if case .case1 = enumCase, genericParameterOptional is SampleClass? { }
    if case .case1 = enumCase, genericParameterOptional is GenericClass<SampleClass> { }
    if case .case1 = enumCase, genericParameterOptional is GenericClass<SampleClass>? { }
    if case .case1 = enumCase, genericParameterOptional is GenericClass<SampleClass?> { }
    if case .case1 = enumCase, genericParameterOptional is GenericClass<Int> { }
    if case .case1 = enumCase, genericParameterOptional is GenericClass<Int>? { }
    if case .case1 = enumCase, genericParameterOptional is GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = genericParameterOptional as SampleClass { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as SampleClass? { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<SampleClass> { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<SampleClass>? { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<Int> { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<Int>? { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as GenericClass<Int?> { } //compiler error
    if case .case1 = enumCase, let _ = genericParameterOptional as? SampleClass { }
    if case .case1 = enumCase, let _ = genericParameterOptional as? SampleClass? { }
    if case .case1 = enumCase, let _ = genericParameterOptional as? GenericClass<SampleClass> { }
    if case .case1 = enumCase, let _ = genericParameterOptional as? GenericClass<SampleClass>? { }
    if case .case1 = enumCase, let _ = genericParameterOptional as? GenericClass<SampleClass?> { }
    if case .case1 = enumCase, let _ = genericParameterOptional as? GenericClass<Int> { }
    if case .case1 = enumCase, let _ = genericParameterOptional as? GenericClass<Int>? { }
    if case .case1 = enumCase, let _ = genericParameterOptional as? GenericClass<Int?> { }
    //if case .case1 = enumCase, let _ = genericParameterOptional as! SampleClass { } //compiler error
    if case .case1 = enumCase, let _ = genericParameterOptional as! SampleClass? { }
    //if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<SampleClass> { } //compiler error
    if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<SampleClass>? { }
    //if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<SampleClass?> { } //compiler error
    //if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<Int> { } //compiler error
    if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<Int>? { }
    //if case .case1 = enumCase, let _ = genericParameterOptional as! GenericClass<Int?> { } //compiler error
  }
}
