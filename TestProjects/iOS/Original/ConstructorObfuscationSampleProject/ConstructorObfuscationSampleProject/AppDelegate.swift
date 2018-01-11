import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let ss = SampleStruct()
    let swi = StructWithInit()
    let swmi = StructWithMemberwiseInit(property: 5)
    
    let sc = SampleClass()
    let cwi = ClassWithInit()
    
    let vc1 = ViewController()
    let vc2 = CustomInitViewController()
    
    return true
  }
}

