//RUN: %target-prepare-obfuscation-for-file "Selectors" %target-run-full-obfuscation

import Foundation

class SelectorTest: NSObject {
  
  @objc func foo() {}
  @objc func bar(_ baz: String) {}
  
  let s = #selector(SelectorTest.foo)
}

