import Foundation

class SampleClass { }

enum SampleEnum {
  case case1
}

class TestClass {
  let castedNonOptional = SampleClass()
  let castedOptional: SampleClass? = nil
  
  let castedNonOptionalSdk = 1
  let castedOptionalSdk: Int? = nil
  
  let enumCase = SampleEnum.case1
  
  func testFunc() {

    // binary-expression with type-casting-operator
    castedNonOptional is SampleClass
    castedNonOptional is SampleClass?
    castedNonOptional as SampleClass
    castedNonOptional as SampleClass?
    castedNonOptional as? SampleClass
    castedNonOptional as? SampleClass?
    castedNonOptional as! SampleClass
    castedNonOptional as! SampleClass?
    
    castedOptional is SampleClass
    castedOptional is SampleClass?
    castedOptional as SampleClass?
    castedOptional as? SampleClass
    castedOptional as? SampleClass?
    castedOptional as! SampleClass
    castedOptional as! SampleClass?

    castedNonOptionalSdk is Int
    castedNonOptionalSdk is Int?
    castedNonOptionalSdk as Int
    castedNonOptionalSdk as Int?
    castedNonOptionalSdk as? Int
    castedNonOptionalSdk as? Int?
    castedNonOptionalSdk as! Int
    castedNonOptionalSdk as! Int?

    castedOptionalSdk is Int
    castedOptionalSdk is Int?
    castedOptionalSdk as Int?
    castedOptionalSdk as? Int
    castedOptionalSdk as? Int?
    castedOptionalSdk as! Int
    castedOptionalSdk as! Int?

    // type-casting-pattern in case-condition
    if case .case1 = enumCase, castedNonOptional is SampleClass { }
    if case .case1 = enumCase, castedNonOptional is SampleClass? { }
    if case .case1 = enumCase, let _ = castedNonOptional as SampleClass? { }
    
    if case .case1 = enumCase, castedOptional is SampleClass { }
    if case .case1 = enumCase, castedOptional is SampleClass? { }
    if case .case1 = enumCase, let _ = castedOptional as SampleClass? { }

    if case .case1 = enumCase, castedNonOptionalSdk is Int { }
    if case .case1 = enumCase, castedNonOptionalSdk is Int? { }
    if case .case1 = enumCase, let _ = castedNonOptionalSdk as Int? { }

    if case .case1 = enumCase, castedOptionalSdk is Int { }
    if case .case1 = enumCase, castedOptionalSdk is Int? { }
    if case .case1 = enumCase, let _ = castedOptionalSdk as Int? { }
  }
}
