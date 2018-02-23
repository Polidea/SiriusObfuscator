//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedFunctions" %target-run-full-obfuscation

import AppKit

// Backtick named functions
func `function`() -> Int { return 1 }

// Generic class methods
class GenericClass<T> {
  func method() -> T { return T() }
}

let gcii = GenericClass<Int>()
_ = gcii.method()

let gcsi = GenericClass<SampleClass>()
_ = gcsi.method()

// override and protocol combined
class A {
  func a() {}
}

protocol P {
  func a()
}

class B: A, P {
  override func a() {}
}
