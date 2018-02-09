//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewingsSortingOptionCell: UITableViewCell {
    fileprivate var normalColor: UIColor?
    fileprivate var selectedColor: UIColor?
    
    override var accessoryType: UITableViewCellAccessoryType {
        didSet {
            adjustImageTintColorDependingOnSelection()
        }
    }
    
    fileprivate func adjustImageTintColorDependingOnSelection() {
        if case .checkmark = accessoryType {
            imageView?.tintColor = selectedColor
        } else {
            imageView?.tintColor = normalColor
        }
    }
}

extension BrewingsSortingOptionCell: PresentableConfigurable {

    func configureWithPresentable(_ presentable: TitleImagePresentable) {
        accessibilityHint = "Represents sorting \(presentable.title)"
        textLabel?.text = presentable.title
        imageView?.image = presentable.image.withRenderingMode(.alwaysTemplate)
    }
}

extension BrewingsSortingOptionCell {

    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        normalColor = theme?.darkColor
        selectedColor = theme?.lightTintColor
        textLabel?.configureWithTheme(theme)
        imageView?.configureWithTheme(theme)
        
        adjustImageTintColorDependingOnSelection()
    }
}
