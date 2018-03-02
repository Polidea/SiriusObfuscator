//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedFunctions" %target-run-full-obfuscation

import AppKit

// Backtick named functions
func `function`() -> Int { return 1 }

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
