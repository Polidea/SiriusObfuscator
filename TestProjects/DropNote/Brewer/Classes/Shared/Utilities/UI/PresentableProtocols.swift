//
//  TitlePresentable.swift
//  Brewer
//
//  Created by Maciej Oczko on 17.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TitlePresentable {
    var title: String { get }
}

protocol ValuePresentable {
    var value: String { get }
}

protocol SliderPresentable {
    var sliderValue: Variable<Float> { get }
}

protocol ImagePresentable {
    var image: UIImage { get }
}

protocol PresentableConfigurable {
    associatedtype Presentable
    func configureWithPresentable(_ presentable: Presentable)
}

// MARK: Title Value

typealias TitleValuePresentable = TitlePresentable & ValuePresentable

// MARK: Title Image

typealias TitleImagePresentable = TitlePresentable & ImagePresentable

// MARK: Title Value Slider

typealias ScoreCellPresentable = TitlePresentable & ValuePresentable & SliderPresentable
