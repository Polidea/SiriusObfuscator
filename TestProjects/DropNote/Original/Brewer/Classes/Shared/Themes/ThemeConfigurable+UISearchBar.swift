//
//  ThemeConfigurable+UISearchBar.swift
//  Brewer
//
//  Created by Maciej Oczko on 07.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension ThemeConfigurable where Self: UISearchBar {
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundColor = theme.lightColor
        barTintColor = theme.darkColor
        (self as UISearchBar).tintColor = theme.darkColor
        isTranslucent = theme.tabBarConfiguration.translucent
        searchBarStyle = .minimal
    }
}
