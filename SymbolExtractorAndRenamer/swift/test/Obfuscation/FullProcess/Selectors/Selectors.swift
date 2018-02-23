//RUN: %target-prepare-obfuscation-for-file "Selectors" %target-run-full-obfuscation

import Foundation

class SelectorTest: NSObject {
  
  @objc func foo() {}
  
  let s = #selector(SelectorTest.foo)
}

