//
//  BrewingSortingOption+SortDescriptor.swift
//  Brewer
//
//  Created by Maciej Oczko on 20.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

extension XEJCtBTfxl7_Pw4vji8sf36Xg3aX5znV {
    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .dateDescending: return NSSortDescriptor(key: "created", ascending: false)
        case .dateAscending: return NSSortDescriptor(key: "created", ascending: true)
        case .scoreDescending: return NSSortDescriptor(key: "score", ascending: false)
        case .scoreAscending: return NSSortDescriptor(key: "score", ascending: true)
        }
    }
}
