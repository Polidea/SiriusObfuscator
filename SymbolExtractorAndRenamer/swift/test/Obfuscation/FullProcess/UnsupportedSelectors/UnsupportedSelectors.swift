//XFAIL: *

//RUN: %target-prepare-obfuscation-for-file "UnsupportedSelectors" %target-run-full-obfuscation

import Foundation

class SelectorTest: NSObject {
  
  @objc func bar(_ baz: String) {}
  
  let s = Selector(("bar:"))
}

