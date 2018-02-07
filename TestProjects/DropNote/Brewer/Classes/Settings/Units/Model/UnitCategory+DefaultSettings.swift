//
// Created by Maciej Oczko on 18.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

extension UnitCategory {
    func defaultSetting() -> Int {
        switch self {
        case .weight: return UnitCategory.WeightUnit.g.rawValue
        case .water: return UnitCategory.WaterUnit.g.rawValue
        case .temperature: return UnitCategory.TemperatureUnit.celsius.rawValue
        }
    }
}
