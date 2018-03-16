import UIKit
import FrameworkTarget

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension Conforming {
  func optFunc() { }
  static func optClassFunc() { }
  func optFunc(param: Int) { }
  static func optClassFunc(param: Int) { }
  var optProp: Int { return 1 }
  static var optClassProp: Int { return 1 }
}

