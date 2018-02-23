
import Foundation

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
