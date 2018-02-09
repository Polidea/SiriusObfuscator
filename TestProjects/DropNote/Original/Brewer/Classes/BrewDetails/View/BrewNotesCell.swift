//
//  BrewNotesCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 28.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewNotesCell: UITableViewCell, Highlightable {
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

extension BrewNotesCell: PresentableConfigurable {
    
    func configureWithPresentable(_ presentable: TitleValuePresentable) {
        accessibilityHint = "Represents notes taken during brew session"
        titleLabel.text = presentable.title
        valueLabel.text = presentable.value
    }
}

extension BrewNotesCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        [titleLabel, valueLabel].forEach {
            $0!.configureWithTheme(theme)
        }
        normalColor = theme?.lightColor
        highlightColor = highlightColorForTheme(theme)
    }
}
