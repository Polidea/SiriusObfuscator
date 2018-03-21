//
//  Brew+CoreDataProperties.swift
//  Brewer
//
//  Created by Maciej Oczko on 05.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Brew {

    @NSManaged var created: TimeInterval
    @NSManaged var method: Int32
    @NSManaged var notes: String?
    @NSManaged var score: Double
    @NSManaged var isFinished: Bool
    @NSManaged var brewAttributes: NSSet?
    @NSManaged var coffee: Coffee?
    @NSManaged var coffeeMachine: CoffeeMachine?
    @NSManaged var cuppingAttributes: NSSet?

}
