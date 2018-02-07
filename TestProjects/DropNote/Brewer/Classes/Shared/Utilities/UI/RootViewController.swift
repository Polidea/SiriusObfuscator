//
//  RootViewController.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject
import UIKit
import RxSwift
import RxCocoa

extension RootViewController: ThemeConfigurationContainer { }
extension RootViewController: ResolvableContainer { }

final class RootViewController: UITabBarController {
    var resolver: ResolverType?
	var themeConfiguration: ThemeConfiguration?

    fileprivate(set) var contentViewControllers: [UIViewController]?

	override func viewDidLoad() {
		super.viewDidLoad()

        contentViewControllers = viewControllers?
            .elements(ofType: UINavigationController.self)
            .map { $0.topViewController }
            .flatMap { $0 }
        
        let methodPickerViewController = contentViewControllers?
            .elements(ofType: MethodPickerViewController.self)
            .first
        
        _ = methodPickerViewController?
            .didSelectBrewMethodSubject
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                brewMethod in
                Analytics.sharedInstance.trackMethodPickEvent(onScreen: AppScreen.newBrew, method: brewMethod)
                self.showNewBrewVieController(for: brewMethod)
            })
        
        contentViewControllers?
            .elements(ofType: TabBarConfigurable.self)
            .forEach { $0.setupTabBar() }

        configureWithTheme(themeConfiguration)
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resolver = resolver else { fatalError("Dependency resolver is missing.") }

        if case .StartNewBrew = segueIdentifierForSegue(segue) , sender is Box<StartBrewContext> {
            let boxedBrewContext = sender as! Box<StartBrewContext>
            let nc = segue.destination as! UINavigationController
            let newBrewViewController = nc.topViewController as! NewBrewViewController
            newBrewViewController.viewModel = resolver.resolve(NewBrewViewModelType.self, argument: boxedBrewContext.value)!
            _ = newBrewViewController
                .hideViewControllerSwitchingToHistorySubject
                .subscribe(onNext: dismissNewBrewViewController)
        }

        if let unwindSegue = segue as? NewBrewUnwindSegue , unwindSegue.shouldSwitchToHistory == true {
            if let historyViewControllerIndex = contentViewControllers?.index(where: { $0 is BrewingsViewController }) {
                DispatchQueue.main.async {
                    self.selectedIndex = historyViewControllerIndex
                }
            }
        }
    }
    
    private func dismissNewBrewViewController(_ switchToHistory: Bool) {
        if let historyViewControllerIndex = contentViewControllers?.index(where: { $0 is BrewingsViewController }) , switchToHistory == true {
            selectedIndex = historyViewControllerIndex
        }
        dismiss(animated: true, completion: nil)
    }
    
    func showNewBrewVieController(for brewMethod: BrewMethod) {
        let context = StartBrewContext(method: brewMethod)
        performSegue(.StartNewBrew, sender: Box(context))
    }
}

extension RootViewController: ThemeConfigurable {

	func configureWithTheme(_ theme: ThemeConfiguration?) {
		guard let theme = theme else { return }

		tabBar.tintColor = theme.tabBarConfiguration.tintColor
		tabBar.barTintColor = theme.tabBarConfiguration.barTintColor
		tabBar.isTranslucent = theme.tabBarConfiguration.translucent
        tabBar.items?[0].accessibilityLabel = "Select First"
        tabBar.items?[0].accessibilityHint = "Selects Starting New Brew Tab"
        tabBar.items?[1].accessibilityLabel = "Select Second"
        tabBar.items?[1].accessibilityHint = "Selects History Tab"
        tabBar.items?[2].accessibilityLabel = "Select Third"
        tabBar.items?[2].accessibilityHint = "Selects Settigns Tab"

		contentViewControllers?
            .elements(ofType: ThemeConfigurable.self)			
			.forEach { $0.configureWithTheme(themeConfiguration) }
	}
}
