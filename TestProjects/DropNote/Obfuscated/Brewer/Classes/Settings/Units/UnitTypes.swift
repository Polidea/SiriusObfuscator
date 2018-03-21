//
// Created by Maciej Oczko on 10.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX: Int {
    case water = 1
    case weight = 2
    case temperature = 3

    enum zYit8Aso57ULYF2Pk4GPtqet2rccL3KA: Int {
        case oz = 11, ml = 12, g = 13

        static let faTtWU6WzhrsUK00wyG9WIGcOqJA4S2E = [oz, ml, g]
    }

    enum LN04_WfLGHkyQsamVfhR4PMphsjcp8PW: Int {
        case oz = 21, g = 22

        static let mo_Q5_UjvUxliGEmYvc1KncdjzmslZX0 = [oz, g]
    }

    enum NbKjkU5iIykRNt5TGiadkDeVJ26KpG86: Int {
        case celsius = 31, fahrenheit = 32

        static let BC9VY7O0kGfVD8XhWTUFJnpbzfptV7qm = [celsius, fahrenheit]
    }
    
    static func C0T3yR8cGRKKW6M5J6dLQQIscrAdpfzy(_ qn0iZT9RbxswR02crQXb7yu7h9k2rh5Y: Int32) -> String {
        switch qn0iZT9RbxswR02crQXb7yu7h9k2rh5Y {
        case 11: return zYit8Aso57ULYF2Pk4GPtqet2rccL3KA.oz.description
        case 12: return zYit8Aso57ULYF2Pk4GPtqet2rccL3KA.ml.description
        case 13: return zYit8Aso57ULYF2Pk4GPtqet2rccL3KA.g.description
            
        case 21: return LN04_WfLGHkyQsamVfhR4PMphsjcp8PW.oz.description
        case 22: return LN04_WfLGHkyQsamVfhR4PMphsjcp8PW.g.description
            
        case 31: return NbKjkU5iIykRNt5TGiadkDeVJ26KpG86.celsius.description
        case 32: return NbKjkU5iIykRNt5TGiadkDeVJ26KpG86.fahrenheit.description
            
        default: return ""
        }
    }
}

// MARK: CustomStringConvertible

extension LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX: CustomStringConvertible {
    var description: String {
        switch self {
            case .weight: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.unitCategoryCoffee)
            case .water: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.unitCategoryWater)
            case .temperature: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.unitCategoryTemperature)
        }
    }
}

// MARK: Water

extension LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.zYit8Aso57ULYF2Pk4GPtqet2rccL3KA: CustomStringConvertible {
    var description: String {
        switch self {
            case .oz: return "oz"
            case .ml: return "ml"
            case .g: return "g"
        }
    }
}

// MARK: Weight

extension LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.LN04_WfLGHkyQsamVfhR4PMphsjcp8PW: CustomStringConvertible {
    var description: String {
        switch self {
            case .oz: return "oz"
            case .g: return "g"
        }
    }
}

// MARK: Temperature

extension LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.NbKjkU5iIykRNt5TGiadkDeVJ26KpG86: CustomStringConvertible {
    var description: String {
        switch self {
            case .celsius: return "°C"
            case .fahrenheit: return "°F"
        }
    }
}
