//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum BrewingSortingOption {
    case dateAscending
    case dateDescending
    case scoreAscending
    case scoreDescending

    static let allValues: [BrewingSortingOption] = [.dateAscending, .dateDescending, .scoreAscending, .scoreDescending]
}
