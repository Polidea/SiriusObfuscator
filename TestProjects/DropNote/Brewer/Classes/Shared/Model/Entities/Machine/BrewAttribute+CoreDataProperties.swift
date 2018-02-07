//
//  BrewAttribute+CoreDataProperties.swift
//  Brewer
//
//  Created by Maciej Oczko on 18.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BrewAttribute {

    @NSManaged var type: Int32
    @NSManaged var value: Double
    @NSManaged var unit: Int32
    @NSManaged var brew: Brew?

}
