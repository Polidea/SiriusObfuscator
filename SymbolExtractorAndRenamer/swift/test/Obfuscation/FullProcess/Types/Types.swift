//RUN: %target-prepare-obfuscation-for-file "Types" %target-run-full-obfuscation

import Foundation

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
