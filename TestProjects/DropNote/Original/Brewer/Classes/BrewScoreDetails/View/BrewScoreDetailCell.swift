//
//  BrewScoreDetailCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class BrewScoreDetailCell: UITableViewCell {
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
}

extension BrewScoreDetailCell: PresentableConfigurable {
    
    func configureWithPresentable(_ presentable: ScoreCellPresentable) {
        accessibilityHint = "Slider for \(presentable.title) value, current is \(presentable.value)"
        titleLabel.text = presentable.title
        valueLabel.text = presentable.value
        slider.value = presentable.sliderValue.value
        slider.rx.value.bind(to: presentable.sliderValue).disposed(by: disposeBag)
        slider.rx.value.map { $0.format(".1") }.bind(to: valueLabel.rx.text).disposed(by: disposeBag)
    }
}

extension BrewScoreDetailCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        backgroundColor = theme?.lightColor
        slider.configureWithTheme(theme)
        [titleLabel, valueLabel].forEach {
            $0!.configureWithTheme(theme)
        }
    }
}
