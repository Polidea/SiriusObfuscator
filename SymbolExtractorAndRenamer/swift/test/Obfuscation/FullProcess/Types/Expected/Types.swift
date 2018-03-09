
import Foundation
import AppKit

class T1_SampleClass {}

extension T1_SampleClass {}

fileprivate class T1_FilePrivateSampleClass {}

protocol T1_SampleProtocol {}

struct T1_SampleStruct {}

class T1_Outer {
  class T1_Inner {
    struct T1_InnerStruct: T1_SampleProtocol{
      func NF1_foo() {
        class T1_InsideFunc: Array<T1_SampleClass?> {}
      }
    }
  }
}

class T1_DerivedClass: T1_SampleClass, T1_SampleProtocol {}

extension T1_SampleClass: T1_SampleProtocol {}

class T1_CustomNSString : NSString {}

extension NSBoolean {}

struct T1_CustomCFLocaleKey: CFLocaleKey {
  class T1_CustomGenericNSString: Array<NSString> {}
}

class T1_Generic<GenericParam> {
  class T1_InsideGeneric: T1_Generic<String> {}
}

class T1_RenameGenericTypeConcretization: T1_Generic<T1_SampleProtocol> {}

class T1_Generic2<T: T1_SampleProtocol> {}
class T1_RenameGenericTypeConcretization2: T1_Generic2<T1_DerivedClass> {}

class T1_Generic3<T: T1_SampleProtocol, R: NSString, U: T1_DerivedClass> {}
class T1_RenameGenericTypeConcretization3: T1_Generic3<T1_DerivedClass, NSString, T1_DerivedClass> {}

class T1_Generic4<T: T1_SampleProtocol where T: T1_DerivedClass> {}
class T1_RenameGenericTypeConcretization4: T1_Generic4<T1_DerivedClass> {}

class T1_A {
  struct T1_B {}
}

class T1_C {
  struct T2_B {}
}

extension T1_SampleProtocol where Self: T1_SampleClass {}

extension T1_SampleProtocol where Self == T1_SampleClass {}

//protocol stuff
protocol T1_Proto {
  func NF1_hello()
}
extension NSString: T1_Proto {}
extension T1_Proto where Self: NSString {
  func NF1_hello() {}
}

// enum
enum T1_SampleEnum: Int {
  case case1, case2
}

let _ = T1_SampleEnum.case1
let _ = T1_SampleEnum(rawValue: 1)

enum T1_EnumWithUnnamedAssoc {
  case case1(Int, String)
}

let V1_test: T1_EnumWithUnnamedAssoc = .case1(0, "")

switch V1_test {
  // variables created with value binding doesn't have to be renamed
  case .case1(let bound1, let bound2):
    print(bound1)
    print(bound2)
}

// mocking trick

protocol T1_KeyValueStoreType {
  func object(forKey defaultName: String) -> Any?
  func set(_ value: Any?, forKey defaultName: String)
  func removeObject(forKey defaultName: String)
  func synchronize() -> Bool
}

extension UserDefaults: T1_KeyValueStoreType {
  
}
