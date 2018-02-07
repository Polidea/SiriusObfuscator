//
//  UIViewController+ThemeConfiguration.swift
//  Brewer
//
//  Created by Maciej Oczko on 02.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension ThemeConfigurable where Self: UIViewController {

	func configureWithTheme(_ theme: ThemeConfiguration?) {
		guard let theme = theme else { return }
        configureTabBarItem(tabBarItem, theme: theme)
		configureNavigationBar(theme.navigationBarConfiguration)
		configureBarButtonItems(theme)
        if isViewLoaded {
            view.configureWithTheme(theme)
        }
	}

    func configureTabBarItem(_ tabBarItem: UITabBarItem, theme: ThemeConfiguration) {
		theme.tabBarItemConfigurations.forEach {
			state, config in
			tabBarItem.setTitleTextAttributes([
                NSAttributedStringKey.font: config.font,
				NSAttributedStringKey.foregroundColor: config.color
				], for: state)
		}
	}

	fileprivate func configureNavigationBar(_ theme: NavigationBarThemeConfiguration) {
		guard let navigationBar = navigationController?.navigationBar else {
			return
		}
		navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: theme.titleFont,
			NSAttributedStringKey.foregroundColor: theme.titleColor
		]
		navigationBar.isTranslucent = theme.translucent
		navigationBar.barTintColor = theme.barTintColor
		navigationBar.tintColor = theme.tintColor
        
        if let nc = navigationController , nc.viewControllers.first != self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_back), style: .plain, target: self, action: #selector(pop))
        }
	}

	fileprivate func configureBarButtonItems(_ theme: ThemeConfiguration) {
		[navigationItem.rightBarButtonItems, navigationItem.leftBarButtonItems]
			.flatMap { $0 }
			.joined()
			.forEach { $0.tintColor = theme.barButtonItemConfiguration.tintColor }
	}
}

extension UIView: ThemeConfigurable { }
extension ThemeConfigurable where Self: UIView {
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundColor = theme.lightColor
        tintColor = theme.lightTintColor
    }
}
