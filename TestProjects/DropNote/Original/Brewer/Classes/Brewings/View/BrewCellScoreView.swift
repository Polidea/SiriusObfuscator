//
//  BrewCellScoreView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewCellScoreView: UIView {
    @IBOutlet weak var scoreLabel: UILabel!
    
    fileprivate let fillingView = UIView()
    var fillingFactor: Double = 0
    var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var fillingColor: UIColor = .white {
        didSet {
            fillingView.backgroundColor = fillingColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        layer.borderWidth = 3
        insertSubview(fillingView, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width * 0.5
        fillingView.frame = CGRect(
            x: 0,
            y: frame.height * CGFloat(1 - fillingFactor),
            width: frame.width,
            height: frame.height * CGFloat(fillingFactor)
        )
    }
}

extension BrewCellScoreView {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        scoreLabel.configureWithTheme(theme)
        scoreLabel.backgroundColor = UIColor.clear
    }
}
