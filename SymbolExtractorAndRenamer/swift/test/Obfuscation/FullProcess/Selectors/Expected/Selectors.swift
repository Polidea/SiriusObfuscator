
import Foundation

class T1_SelectorTest: NSObject {
  
  @objc func NF1_foo() {}
  @objc func NF1_bar(_ IP1_baz: String) {}
  
  let V1_s = #selector(T1_SelectorTest.NF1_foo)
}
