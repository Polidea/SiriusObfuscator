//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NewBrewCollectionViewCell: UICollectionViewCell {
    var topInset: CGFloat = 0

    weak var stepView: UIView? {
        didSet {
            if let stepView = stepView {
                contentView.addSubview(stepView)
            }
        }
    }

    override func layoutSubviews() {
        contentView.frame = bounds
        stepView?.frame = CGRect(x: 0, y: 0 + topInset, width: bounds.width, height: bounds.height - topInset)
    }

}
