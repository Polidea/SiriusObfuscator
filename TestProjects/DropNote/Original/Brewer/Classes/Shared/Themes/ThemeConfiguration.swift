//
//  ThemeConfigurator.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeConfiguration {
    var darkColor: UIColor { get }
    var lightColor: UIColor { get }
    
    var lightTintColor: UIColor { get }
    var darkTintColor: UIColor { get }
    
    func defaultFontWithSize(_ size: CGFloat) -> UIFont
    func mediumFontWithSize(_ size: CGFloat) -> UIFont
 
    var navigationBarConfiguration: NavigationBarThemeConfiguration { get }
    var tabBarItemConfigurations: [UIControlState: TabBarItemThemeConfiguration] { get }
    var tabBarConfiguration: TabBarThemeConfiguration { get }
    var barButtonItemConfiguration: BarButtonItemThemeConfiguration { get }
}

protocol TabBarItemThemeConfiguration {
    var font: UIFont { get }
    var color: UIColor { get }
}

protocol TabBarThemeConfiguration {
    var tintColor: UIColor { get }
    var barTintColor: UIColor { get }
    var translucent: Bool { get }
}

protocol NavigationBarThemeConfiguration {
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    var tintColor: UIColor { get }
    var barTintColor: UIColor { get }
    var translucent: Bool { get }
}

protocol BarButtonItemThemeConfiguration {
    var tintColor: UIColor { get }
}

// MARK: Configurable

protocol ThemeConfigurable {
    func configureWithTheme(_ theme: ThemeConfiguration?)
}

protocol ThemeConfigurationContainer {
    var themeConfiguration: ThemeConfiguration? { get set }
}

// MARK: Helpers

// Require to keep it in hash map
extension UIControlState: Hashable {
    public var hashValue: Int {
        return Int(rawValue)
    }
}
