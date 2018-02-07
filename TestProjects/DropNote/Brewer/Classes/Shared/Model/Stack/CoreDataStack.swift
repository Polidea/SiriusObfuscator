//
// Created by Maciej Oczko on 23.11.2015.
// Copyright (c) 2015 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

protocol StackType {
    var mainContext: NSManagedObjectContext { get }

    func createPrivateContext() -> NSManagedObjectContext
    
    func asyncOperation(_ operation: @escaping (NSManagedObjectContext) -> Void)

    func asyncBackgroundOperation(_ operation: @escaping (NSManagedObjectContext) -> Void)
    func backgroundOperation(_ operation: @escaping (NSManagedObjectContext) -> Void) -> Observable<Bool>

    func save() -> Observable<Bool>
}

final class CoreDataStack: StackType {
    fileprivate(set) var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    fileprivate var writingContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

    init(storeType: String = NSSQLiteStoreType) {
        writingContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        mainContext.parent = writingContext

        initializeSQLite(storeType)
    }
    
    // MARK: Public methods

    func save() -> Observable<Bool> {
        if (!writingContext.hasChanges && !mainContext.hasChanges) {
            return Observable.just(true)
        }

        return saveContext(self.mainContext).flatMap {
            _ in
            return self.saveContext(self.writingContext)
        }
    }

    func createPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        return context
    }

    func asyncBackgroundOperation(_ operation: @escaping (NSManagedObjectContext) -> Void) {
        let context = createPrivateContext()
        context.perform {
            operation(context)
        }
    }

    func backgroundOperation(_ operation: @escaping (NSManagedObjectContext) -> Void) -> Observable<Bool> {
        return Observable.create {
            observer in
            let context = self.createPrivateContext()
            context.perform {
                operation(context)
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func asyncOperation(_ operation: @escaping (NSManagedObjectContext) -> Void) {
        let context = mainContext
        context.perform {
            operation(context)
        }
    }

    // MARK: Private methods

    fileprivate func saveContext(_ context: NSManagedObjectContext) -> Observable<Bool> {
        return Observable.create {
            observer in

            context.perform {
                do {
                    try context.save()
                    observer.onNext(true)
                    observer.onCompleted()
                } catch {
                    observer.on(.error(error))
                }
            }

            return Disposables.create()
        }
    }

    // MARK: Stack setup

    fileprivate func initializeSQLite(_ storeType: String) {
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        queue.async {
            let url = self.applicationDocumentsDirectory.appendingPathComponent("Brewer.sqlite")
            let failureReason = "There was an error creating or loading the application's saved data."
            do {
                let options = [
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                ]
                try self.persistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: url, options: options)
            } catch {
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                dict[NSUnderlyingErrorKey] = error as NSError
                let wrappedError = NSError(domain: "pl.maciejoczko.brewer", code: 9999, userInfo: dict)
                NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                abort()
            }
        }
    }

    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Brewer", withExtension: "mom")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()

    fileprivate lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
}
