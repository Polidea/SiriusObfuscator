//
//  AppDelegate.swift
//  XIBandConstructorParameters
//
//  Created by Krzysztof Siejkowski on 09/02/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import UIKit



class SampleClass {}
protocol SampleProtocol {}
class DerivedClass: SampleProtocol {}

class Generic<GenericParam> {
  class InsideGeneric: Generic<String> {}
}

class RenameGenericTypeConcretization: Generic<SampleProtocol> {}

class Generic2<T: SampleProtocol> {}
class RenameGenericTypeConcretization2: Generic2<DerivedClass> {}

class Generic3<T: SampleProtocol, R: NSString, U: DerivedClass> {}



struct MemberwiseConstructorParam {
  let fieldA: Int
  let fieldB: String
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


  let test = MemberwiseConstructorParam(fieldA: 1, fieldB: "")


  var window: UIWindow?
  let prop = 42
  let prop2 = SampleClass()



  var closureParam: (Int) -> Int = { param in
    return param
  }

  var closureShorthandParams: (Int, Int) -> String = {
    return "\($0) \($1)"
  }

  lazy var closureUnownedSelfWeakProp: () -> SampleClass = { [unowned self, weak p = self.prop2] in
    return p!
  }

  lazy var closureWeakSelfAndParam: (Int) -> Int = { [weak self] param in
    return self!.prop + param
  }

  

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }

}

