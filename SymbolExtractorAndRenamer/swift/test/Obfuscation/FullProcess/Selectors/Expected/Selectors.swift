
import Foundation

class T1_SelectorTest: NSObject {
  
  @objc func NF1_foo() {}
  
  let V1_s = #selector(T1_SelectorTest.NF1_foo)
}
