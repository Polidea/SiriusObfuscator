//
// Created by Maciej Oczko on 20.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewCell: UITableViewCell, Highlightable {
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var coffeeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var scoreView: BrewCellScoreView!
    
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
    }

    func configureWithViewModel(_ viewModel: BrewCellViewModelType) {
        accessibilityHint = "Shows brew details for \(viewModel.coffee)"
        createdAtLabel.text = viewModel.createdAt
        coffeeLabel.text = viewModel.coffee
        scoreView.scoreLabel.text = viewModel.score
        scoreView.borderColor = viewModel.methodColor
        scoreView.fillingColor = viewModel.methodLightColor
        scoreView.fillingFactor = viewModel.fillingFactor
        iconImageView.image = UIImage(asset: viewModel.methodImageName)
        scoreView.setNeedsLayout()
        scoreView.layoutIfNeeded()
    }
    
    override var isHighlighted: Bool {
        didSet {
            highlightViews([self, self.createdAtLabel, self.coffeeLabel], highlighted: isHighlighted)            
        }
    }
}

extension BrewCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        backgroundColor = theme?.lightColor
        scoreView.configureWithTheme(theme)
        [createdAtLabel, coffeeLabel].forEach {
            $0!.configureWithTheme(theme)
        }
        coffeeLabel.font = theme?.mediumFontWithSize(coffeeLabel.font.pointSize)
        normalColor = theme?.lightColor
        highlightColor = highlightColorForTheme(theme)
    }
}
