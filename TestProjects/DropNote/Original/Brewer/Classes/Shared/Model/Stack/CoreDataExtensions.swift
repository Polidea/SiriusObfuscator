//
// Created by Maciej Oczko on 16.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

protocol Entity {
    static func entityName() -> String
}

struct CoreDataOperations<T> where T: NSManagedObject, T: Entity {
    let context: NSManagedObjectContext

    init(managedObjectContext context: NSManagedObjectContext) {
        self.context = context
    }

    func create() -> T {
        return NSEntityDescription.insertNewObject(forEntityName: T.entityName(), into: context) as! T
    }
    
    func fetch(withPredicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName())
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        return try context.fetch(fetchRequest)
    }

    func save() throws {
        try context.save()
    }
    
    func objectForID(_ objectID: NSManagedObjectID) -> T? {
        return context.registeredObject(for: objectID) as? T
    }
}
