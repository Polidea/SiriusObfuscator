//
// Created by Maciej Oczko on 20.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

struct UnitsDataSourceItem {
    let key: Int
    let title: String
}

protocol UnitsDataSourceType: class {
    var title: String { get }
    var items: [UnitsDataSourceItem] { get }
    var category: Int { get }
}
