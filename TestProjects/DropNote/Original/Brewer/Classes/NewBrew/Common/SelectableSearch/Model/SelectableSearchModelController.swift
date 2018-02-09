//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import XCGLogger

protocol SelectableSearchItemInserterType {
    associatedtype Entity
    func insertEntityWithName(_ name: String) throws -> Entity
}

protocol SelectableSearchModelControllerType {
    var placeholder: String? { get }
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject>! { get }
    func setSearchString(_ search: String?)
    func setItemIndex(_ index: Int?)
    func addSearchItem()
    func selectedItemIndex() -> Int?
}

struct SelectableSearchItemInserter<T>: SelectableSearchItemInserterType where T: NSManagedObject, T: Entity, T: SelectableSearchModelItem {
    fileprivate let operations: CoreDataOperations<T>

    init(context: NSManagedObjectContext) {
        self.operations = CoreDataOperations(managedObjectContext: context)
    }

    func insertEntityWithName(_ name: String) throws -> T {
        let items = try operations.fetch(withPredicate: NSPredicate(format: "name == %@", name))
        if let item = items.last {
            return item
        }

        let item = operations.create()
        item.name = name
        try operations.save()
        return item
    }

    func save() throws {
        try operations.save()
    }
}

class SelectableSearchModelController: SelectableSearchModelControllerType {

    let stack: StackType
    let brewModelController: BrewModelControllerType
    
    final var placeholder: String?
    final fileprivate(set) var currentSearch: String?

    init(stack: StackType, brewModelController: BrewModelControllerType) {
        self.stack = stack
        self.brewModelController = brewModelController
    }

    final lazy var fetchedResultsController: NSFetchedResultsController<NSManagedObject>! = {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entityName())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.stack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            XCGLogger.error("Error when fetching \(self.entityName()) = \(error)")
        }
        return fetchedResultsController
    }()

    final func setSearchString(_ search: String?) {
        currentSearch = search
        if let search = search , !search.isEmpty {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "name", search)
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate.truePredicate()
        }
    }
    
    func selectedItemIndex() -> Int? { abstractMethod() }
    
    func entityName() -> String { abstractMethod() }

    func setItemIndex(_ index: Int?) { abstractMethod() }

    func addSearchItem() { abstractMethod() }
}
