//  Cupping.swift
//  Brewer
//
//  Created by Maciej Oczko on 16.01.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

class Cupping: NSManagedObject {

}

extension Cupping: Entity {
    static func entityName() -> String {
        return "CuppingAttribute"
    }
}
