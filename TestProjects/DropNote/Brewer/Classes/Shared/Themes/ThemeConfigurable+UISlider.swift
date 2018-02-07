//
//  ThemeConfigurable+UISlider.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension ThemeConfigurable where Self: UISlider {
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundColor = theme.lightColor
        tintColor = theme.lightTintColor
        minimumTrackTintColor = theme.darkTintColor
        maximumTrackTintColor = theme.darkColor
        thumbTintColor = theme.lightTintColor
    }
}
