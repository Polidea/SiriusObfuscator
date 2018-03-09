//RUN: %target-prepare-obfuscation-for-file "Types" %target-run-full-obfuscation

import Foundation
import AppKit

class SampleClass {}

extension SampleClass {}

fileprivate class FilePrivateSampleClass {}

protocol SampleProtocol {}

struct SampleStruct {}

class Outer {
  class Inner {
    struct InnerStruct: SampleProtocol{
      func foo() {
        class InsideFunc: Array<SampleClass?> {}
      }
    }
  }
}

class DerivedClass: SampleClass, SampleProtocol {}

extension SampleClass: SampleProtocol {}

class CustomNSString : NSString {}

extension NSBoolean {}

struct CustomCFLocaleKey: CFLocaleKey {
  class CustomGenericNSString: Array<NSString> {}
}

class Generic<GenericParam> {
  class InsideGeneric: Generic<String> {}
}

class RenameGenericTypeConcretization: Generic<SampleProtocol> {}

class Generic2<T: SampleProtocol> {}
class RenameGenericTypeConcretization2: Generic2<DerivedClass> {}

class Generic3<T: SampleProtocol, R: NSString, U: DerivedClass> {}
class RenameGenericTypeConcretization3: Generic3<DerivedClass, NSString, DerivedClass> {}

class Generic4<T: SampleProtocol where T: DerivedClass> {}
class RenameGenericTypeConcretization4: Generic4<DerivedClass> {}

class A {
  struct B {}
}

class C {
  struct B {}
}

extension SampleProtocol where Self: SampleClass {}

extension SampleProtocol where Self == SampleClass {}

//protocol stuff
protocol Proto {
  func hello()
}
extension NSString: Proto {}
extension Proto where Self: NSString {
  func hello() {}
}

// enum
enum SampleEnum: Int {
  case case1, case2
}

let _ = SampleEnum.case1
let _ = SampleEnum(rawValue: 1)

enum EnumWithUnnamedAssoc {
  case case1(Int, String)
}

let test: EnumWithUnnamedAssoc = .case1(0, "")

switch test {
  // variables created with value binding doesn't have to be renamed
  case .case1(let bound1, let bound2):
    print(bound1)
    print(bound2)
}

// mocking trick

protocol KeyValueStoreType {
  func object(forKey defaultName: String) -> Any?
  func set(_ value: Any?, forKey defaultName: String)
  func removeObject(forKey defaultName: String)
  func synchronize() -> Bool
}

extension UserDefaults: KeyValueStoreType {
  
}
