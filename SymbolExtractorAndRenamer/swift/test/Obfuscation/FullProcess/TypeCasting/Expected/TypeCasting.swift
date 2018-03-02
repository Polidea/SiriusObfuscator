import AppKit

class T1_SampleClass { }

let V1_castedNonOptional = T1_SampleClass()
let V1_castedOptional: T1_SampleClass? = nil

let V1_castedNonOptionalSdk = 1
let V1_castedOptionalSdk: Int? = nil

enum T1_SampleEnum {
  case case1
}
let V1_enumCase = T1_SampleEnum.case1

// binary-expression with type-casting-operator
V1_castedNonOptional is T1_SampleClass
V1_castedNonOptional is T1_SampleClass?
V1_castedNonOptional as T1_SampleClass
V1_castedNonOptional as T1_SampleClass?
V1_castedNonOptional as? T1_SampleClass
V1_castedNonOptional as? T1_SampleClass?
V1_castedNonOptional as! T1_SampleClass
V1_castedNonOptional as! T1_SampleClass?

V1_castedOptional is T1_SampleClass
V1_castedOptional is T1_SampleClass?
V1_castedOptional as T1_SampleClass?
V1_castedOptional as? T1_SampleClass
V1_castedOptional as? T1_SampleClass?
V1_castedOptional as! T1_SampleClass
V1_castedOptional as! T1_SampleClass?

V1_castedNonOptionalSdk is Int
V1_castedNonOptionalSdk is Int?
V1_castedNonOptionalSdk as Int
V1_castedNonOptionalSdk as Int?
V1_castedNonOptionalSdk as? Int
V1_castedNonOptionalSdk as? Int?
V1_castedNonOptionalSdk as! Int
V1_castedNonOptionalSdk as! Int?

V1_castedOptionalSdk is Int
V1_castedOptionalSdk is Int?
V1_castedOptionalSdk as Int?
V1_castedOptionalSdk as? Int
V1_castedOptionalSdk as? Int?
V1_castedOptionalSdk as! Int
V1_castedOptionalSdk as! Int?

// type-casting-pattern in case-condition
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_SampleClass { }
if case .case1 = V1_enumCase, V1_castedNonOptional is T1_SampleClass? { }
if case .case1 = V1_enumCase, let _ = V1_castedNonOptional as T1_SampleClass? { }

if case .case1 = V1_enumCase, V1_castedOptional is T1_SampleClass { }
if case .case1 = V1_enumCase, V1_castedOptional is T1_SampleClass? { }
if case .case1 = V1_enumCase, let _ = V1_castedOptional as T1_SampleClass? { }

if case .case1 = V1_enumCase, V1_castedNonOptionalSdk is Int { }
if case .case1 = V1_enumCase, V1_castedNonOptionalSdk is Int? { }
if case .case1 = V1_enumCase, let _ = V1_castedNonOptionalSdk as Int? { }

if case .case1 = V1_enumCase, V1_castedOptionalSdk is Int { }
if case .case1 = V1_enumCase, V1_castedOptionalSdk is Int? { }
if case .case1 = V1_enumCase, let _ = V1_castedOptionalSdk as Int? { }

