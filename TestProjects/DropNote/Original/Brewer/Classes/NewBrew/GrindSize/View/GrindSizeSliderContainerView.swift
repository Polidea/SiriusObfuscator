//
//  GrindSizeSliderContainerView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class GrindSizeSliderContainerView: UIView {
    @IBOutlet weak var extraFineImageView: UIImageView!
    @IBOutlet weak var extraFineLabel: UILabel! {
        didSet {
            extraFineLabel.text = tr(.grindSizeLevelExtraFine)
        }
    }
    @IBOutlet weak var coarseImageView: UIImageView!
    @IBOutlet weak var coarseLabel: UILabel! {
        didSet {
            coarseLabel.text = tr(.grindSizeLevelCoarse)
        }
    }
    @IBOutlet weak var slider: UISlider!
}

extension GrindSizeSliderContainerView {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        backgroundColor = theme?.lightColor
        slider.configureWithTheme(theme)
        [extraFineLabel, coarseLabel].forEach {
            $0!.configureWithTheme(theme)
        }
    }
}
