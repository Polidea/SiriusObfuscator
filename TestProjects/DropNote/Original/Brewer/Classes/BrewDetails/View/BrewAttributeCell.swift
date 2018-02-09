//
//  BrewAttributeCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 09.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewAttributeCell: UITableViewCell, Highlightable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            highlightViews([self, titleLabel, valueLabel], highlighted: isHighlighted)
        }
    }
}

extension BrewAttributeCell: PresentableConfigurable {
    
    func configureWithPresentable(_ presentable: TitleValuePresentable) {
        accessibilityHint = "Represents \(presentable.title) attribute with value \(presentable.value)"
        titleLabel.text = presentable.title
        valueLabel.text = presentable.value
    }
}

extension BrewAttributeCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        [titleLabel, valueLabel].forEach {
            $0!.configureWithTheme(theme)
        }
        normalColor = theme?.lightColor
        highlightColor = highlightColorForTheme(theme)
    }
}
