import AppKit

// Backtick named function
func NF1_`function`() -> Int { return 1 }

// Generic class methods
class T1_GenericClass<T> {
  func NF1_method() -> T { return T() }
}

let V1_gcii = T1_GenericClass<Int>()
_ = V1_gcii.NF1_method()

let V1_gcsi = T1_GenericClass<T1_SampleClass>()
_ = V1_gcsi.NF1_method()

// override and protocol combined
class T1_A {
  func NF1_a() {}
}

protocol T1_P {
  func NF1_a()
}

class T1_B: T1_A, T1_P {
  override func NF1_a() {}
}
