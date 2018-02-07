//
// Created by Maciej Oczko on 18.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

protocol NumericalInputViewModelType {
    var unit: String { get }
    var informativeText: String { get }
    var inputTransformer: NumericalInputTransformerType { get }
    var currentValue: String? { get }

    func setInputValue(_ value: String)
}
