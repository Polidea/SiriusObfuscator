//
//  SettingsCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 28.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCell: UITableViewCell, Highlightable {
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            highlightViews([self, textLabel!], highlighted: isHighlighted)
        }
    }
}

extension SettingsCell: PresentableConfigurable {
    
    func configureWithPresentable(_ presentable: TitlePresentable) {
        accessibilityHint = "Opens \(presentable.title)"
        textLabel?.text = presentable.title
    }
}

extension SettingsCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        [textLabel!, detailTextLabel!].forEach {
            $0.configureWithTheme(theme)
        }
        normalColor = theme?.lightColor
        highlightColor = highlightColorForTheme(theme)
    }
}
