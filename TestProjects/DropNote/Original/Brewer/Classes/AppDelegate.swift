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
final class AppDelegate: UIResponder, UIApplicationDelegate {
	fileprivate let disposeBag = DisposeBag()

	var window: UIWindow?
	var assembler: Assembler!
	var themeConfiguration: ThemeConfiguration?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if !DEBUG
            Fabric.with([Crashlytics.self])
        #else
            if ProcessInfo.processInfo.arguments.contains("use_mock_data") {
                loadMockData()
            }
        #endif
		return true
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// loadReveal()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		let stack: StackType = assembler.resolver.resolve(StackType.self)!
		stack.save().subscribe().disposed(by: disposeBag)
	}
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        guard let rootViewController = application.keyWindow?.rootViewController as? RootViewController else {
            completionHandler(false)
            return
        }
        
        let brewMethod = BrewMethod.fromQuickType(string: shortcutItem.type)
        rootViewController.showNewBrewVieController(for: brewMethod)
        completionHandler(true)
    }

	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
		let rootViewController = window?.rootViewController as? RootViewController
		guard let brewingsViewController = rootViewController?.contentViewControllers?.elements(ofType: BrewingsViewController.self).first
				else { return false }
		brewingsViewController.restoreUserActivityState(userActivity)
		return true
	}

}

extension AppDelegate: ThemeConfigurationContainer { }

extension SwinjectStoryboard {
    @objc class func setup() {
      let assembler = Assembler([
        CoreComponentsAssembly(),
        SettingsAssembly(),
        NewBrewAssembly(),
        BrewingsAssembly(),
        BrewingsSortingAssembly(),
        BrewDetailsAssembly(),
        BrewScoreDetailsAssembly()
      ], container: defaultContainer)

      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.assembler = assembler
          appDelegate.themeConfiguration = assembler.resolver.resolve(ThemeConfiguration.self)
      }
    }
}
