//
// Created by Maciej Oczko on 10.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum UnitCategory: Int {
    case water = 1
    case weight = 2
    case temperature = 3

    enum WaterUnit: Int {
        case oz = 11, ml = 12, g = 13

        static let allValues = [oz, ml, g]
    }

    enum WeightUnit: Int {
        case oz = 21, g = 22

        static let allValues = [oz, g]
    }

    enum TemperatureUnit: Int {
        case celsius = 31, fahrenheit = 32

        static let allValues = [celsius, fahrenheit]
    }
    
    static func unitDescriptionFromIntValue(_ intValue: Int32) -> String {
        switch intValue {
        case 11: return WaterUnit.oz.description
        case 12: return WaterUnit.ml.description
        case 13: return WaterUnit.g.description
            
        case 21: return WeightUnit.oz.description
        case 22: return WeightUnit.g.description
            
        case 31: return TemperatureUnit.celsius.description
        case 32: return TemperatureUnit.fahrenheit.description
            
        default: return ""
        }
    }
}

// MARK: CustomStringConvertible

extension UnitCategory: CustomStringConvertible {
    var description: String {
        switch self {
            case .weight: return tr(.unitCategoryCoffee)
            case .water: return tr(.unitCategoryWater)
            case .temperature: return tr(.unitCategoryTemperature)
        }
    }
}

// MARK: Water

extension UnitCategory.WaterUnit: CustomStringConvertible {
    var description: String {
        switch self {
            case .oz: return "oz"
            case .ml: return "ml"
            case .g: return "g"
        }
    }
}

// MARK: Weight

extension UnitCategory.WeightUnit: CustomStringConvertible {
    var description: String {
        switch self {
            case .oz: return "oz"
            case .g: return "g"
        }
    }
}

// MARK: Temperature

extension UnitCategory.TemperatureUnit: CustomStringConvertible {
    var description: String {
        switch self {
            case .celsius: return "°C"
            case .fahrenheit: return "°F"
        }
    }
}
