//
//  BrewDetailsRemoveCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 18.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewDetailsRemoveCell: UITableViewCell, Highlightable {
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            highlightViews([self], highlighted: isHighlighted)
        }
    }
}

extension BrewDetailsRemoveCell {
    
    func configureWithPresentable(_ presentable: TitleValuePresentable) {
        accessibilityHint = "Removes current brew from history"
        textLabel?.text = presentable.title
    }
}

extension BrewDetailsRemoveCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        textLabel?.font = theme?.defaultFontWithSize(17)
        textLabel?.textColor = UIColor.deepBlush()
        normalColor = theme?.lightColor
        highlightColor = highlightColorForTheme(theme)
    }
}
