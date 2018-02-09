//
// Created by Maciej Oczko on 10.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

final class WaterUnitsDataSource: UnitsDataSourceType {
    var items: [UnitsDataSourceItem] {
        return UnitCategory.WaterUnit.allValues.map {
            UnitsDataSourceItem(key: $0.rawValue, title: $0.description)
        }
    }

    var title: String {
        return tr(.unitCategoryWater)
    }

    var category: Int {
        return UnitCategory.water.rawValue
    }
}
