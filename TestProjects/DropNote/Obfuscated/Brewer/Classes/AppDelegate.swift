//
//  AppDelegate.swift
//  Brewer
//
//  Created by Maciej Oczko on 23.11.2015.
//  Copyright © 2015 Maciej Oczko. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import RxSwift
import XCGLogger

#if !DEBUG
    import Fabric
    import Crashlytics
#endif

@UIApplicationMain
final class ZkfHWuBJVNjaVLr2ns0sIB7oEW0ZFCQK: UIResponder, UIApplicationDelegate {
	fileprivate let c_OI2s3m7jBoLsvXXgVwNrSVQFSHKxqf = DisposeBag()

	var window: UIWindow?
	var HUq7FpkzSoIjENs18L24AgT7GhoIbAl0: Assembler!
	var RXX5Q_QAsdJLlQ3LK59w6tnRhTQryjNm: uxojwo8aosue9wOkkgXXYi7IMaiKR2jw?

	func application(_ Lliq_xSJlY8y8u5G6eLS7sWkYIDdmo9Z: UIApplication, didFinishLaunchingWithOptions j6OUo2t86Y1Eru2U4VEfbcpHunUTv6ku: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if !DEBUG
            Fabric.with([Crashlytics.self])
        #else
            if ProcessInfo.processInfo.arguments.contains("use_mock_data") {
                loadMockData()
            }
        #endif
		return true
	}

	func applicationDidBecomeActive(_ nLnN4V4vGny53lcd0_NwLNXQdusLl_3G: UIApplication) {
		// loadReveal()
	}

	func applicationDidEnterBackground(_ jexYCdk4tqNRiU00UEc61B0RehCHPXyJ: UIApplication) {
		let stack: FiPo5WjIle8_QlTDYzuos59EOIfdXKGG = HUq7FpkzSoIjENs18L24AgT7GhoIbAl0.resolver.resolve(FiPo5WjIle8_QlTDYzuos59EOIfdXKGG.self)!
		stack.vCoa_A_kB6HG5sbtNTRfwTHOEWKLR9Z7().subscribe().disposed(by: c_OI2s3m7jBoLsvXXgVwNrSVQFSHKxqf)
	}
    
    func application(_ GJHbVBl7P4IaMkDNkWcu6kRXpaHeL32E: UIApplication, performActionFor jMxsMZGktWSBl_V2ggwYiARTJUG99lzO: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        guard let rootViewController = GJHbVBl7P4IaMkDNkWcu6kRXpaHeL32E.keyWindow?.rootViewController as? K_aAPR1ESq6obbB4iOQKU8CWj_4E6vR_ else {
            completionHandler(false)
            return
        }
        
        let brewMethod = f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei.HKQlLt20MvOLduhD5uNOlB9QBCP_iSXU(CSizrjyGzxpehwdNxXpVG2hJwysrjfgK: jMxsMZGktWSBl_V2ggwYiARTJUG99lzO.type)
        rootViewController.MXYCBskZZ7lDMQK4FG5y1u77a5oK4jrk(YDRh2H6fImt_aW8FeqPl1PTVfHL30ju8: brewMethod)
        completionHandler(true)
    }

	func application(_ SVtPX7joYSqxG4qF6Ns16jGXq3j4H9F7: UIApplication, continue CPFu1tuRHq8VkD0OuQ0HfAP41vsEXZt2: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
		let rootViewController = window?.rootViewController as? K_aAPR1ESq6obbB4iOQKU8CWj_4E6vR_
		guard let brewingsViewController = rootViewController?.Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8?.elements(ofType: efyhSLwe4QpLjRAGdRPwwm2RGWheMQOA.self).first
				else { return false }
		brewingsViewController.restoreUserActivityState(CPFu1tuRHq8VkD0OuQ0HfAP41vsEXZt2)
		return true
	}

}

extension ZkfHWuBJVNjaVLr2ns0sIB7oEW0ZFCQK: Q3c1Yv0NMG53YSzxbfYtUko_jFRWEYtg { }

extension SwinjectStoryboard {
    @objc class func setup() {
      let assembler = Assembler([
        u9q5TvWkWlxbMgLJOaxlqiiR05aimccL(),
        WRm9YhQBQXvSVIkkXGe2BfXk7pk58Brf(),
        LAqcOLqE0gCF1IK4_IALpIlVmKWkKJMc(),
        UigLWvHO6atF5qIonbeOUK67b45UTVm6(),
        Suh6d4QyHvrArT5hTVbXzHswCRUQJ5vB(),
        ygJBRq8fLKtOvBr4v5vybH2oGMV8ZcIA(),
        sgEJr5Q8jte_5PUCDKCuWIsdETz0qgSO()
      ], container: defaultContainer)

      if let appDelegate = UIApplication.shared.delegate as? ZkfHWuBJVNjaVLr2ns0sIB7oEW0ZFCQK {
          appDelegate.HUq7FpkzSoIjENs18L24AgT7GhoIbAl0 = assembler
          appDelegate.RXX5Q_QAsdJLlQ3LK59w6tnRhTQryjNm = assembler.resolver.resolve(uxojwo8aosue9wOkkgXXYi7IMaiKR2jw.self)
      }
    }
}
