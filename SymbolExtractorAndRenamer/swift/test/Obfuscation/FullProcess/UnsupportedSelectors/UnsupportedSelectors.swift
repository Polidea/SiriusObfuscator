//XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedSelectors" %target-run-full-obfuscation

import Foundation

class SelectorTest: NSObject {  
  let s = Selector(("bar:"))
}

