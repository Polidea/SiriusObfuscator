//
// Created by Maciej Oczko on 10.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

final class TemperatureUnitsDataSource: UnitsDataSourceType {
    var items: [UnitsDataSourceItem] {
        return UnitCategory.TemperatureUnit.allValues.map {
            UnitsDataSourceItem(key: $0.rawValue, title: $0.description)
        }
    }

    var title: String {
        return tr(.unitCategoryTemperature)
    }
    
    var category: Int {
        return UnitCategory.temperature.rawValue
    }
}
