//
//  Coffee.swift
//  Brewer
//
//  Created by Maciej Oczko on 16.01.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

class Coffee: NSManagedObject {

}

extension Coffee: SelectableSearchModelItem {

}

extension Coffee: Entity {
    static func entityName() -> String {
        return "Coffee"
    }
}
