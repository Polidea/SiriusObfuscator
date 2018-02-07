//
// Created by Maciej Oczko on 20.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

protocol UnitsDataSourcesFactoryType {
    var dataSources: [UnitsDataSourceType] { get }
}

final class UnitsDataSourcesFactory: UnitsDataSourcesFactoryType {
    var dataSources: [UnitsDataSourceType] {
        return [
                WaterUnitsDataSource(),
                WeightUnitsDataSource(),
                TemperatureUnitsDataSource()
        ]
    }
}
