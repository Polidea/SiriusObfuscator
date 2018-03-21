//
// Created by Maciej Oczko on 23.11.2015.
// Copyright (c) 2015 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

protocol FiPo5WjIle8_QlTDYzuos59EOIfdXKGG {
    var XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH: NSManagedObjectContext { get }

    func vnXrh1KOujaoqNNQgX92kZ5HEsa7AG9_() -> NSManagedObjectContext
    
    func ih9sIR2YfBvFqhgKqn1LJL7aRGWJ8kE5(_ faGBQTPUgtnBu0Rd3tunVKRYYHP52mT_: @escaping (NSManagedObjectContext) -> Void)

    func RGzaQUi7BqqoZmeCKucDKJ8V8rxyGmZB(_ zt_pmED4CGndsTEKnHTBz858zMxGGUyy: @escaping (NSManagedObjectContext) -> Void)
    func uMg_ZFHkG7pQd5uYVmu9ddFn5FSaMafQ(_ VHVVk12ZIAoD3WqMRhX_wBMsLOVYFyEg: @escaping (NSManagedObjectContext) -> Void) -> Observable<Bool>

    func vCoa_A_kB6HG5sbtNTRfwTHOEWKLR9Z7() -> Observable<Bool>
}

final class nvPVxSQkBR4Eo7HaLIacjqJoKysFJx2J: FiPo5WjIle8_QlTDYzuos59EOIfdXKGG {
    fileprivate(set) var XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    fileprivate var HL20Q47LeoOq23sH7DU9738VEB385bLA: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

    init(tJJsXlc1fwbeNjaM8TTJ9s0J1XZTMtB5: String = NSSQLiteStoreType) {
        HL20Q47LeoOq23sH7DU9738VEB385bLA.persistentStoreCoordinator = self.lxCTZVfMwRxvZz6DtMpWVrjeEl915T2O
        XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH.parent = HL20Q47LeoOq23sH7DU9738VEB385bLA

        hRwNNpnuFszHtGPsjD9RqiwEp1PV2aw9(tJJsXlc1fwbeNjaM8TTJ9s0J1XZTMtB5)
    }
    
    // MARK: Public methods

    func vCoa_A_kB6HG5sbtNTRfwTHOEWKLR9Z7() -> Observable<Bool> {
        if (!HL20Q47LeoOq23sH7DU9738VEB385bLA.hasChanges && !XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH.hasChanges) {
            return Observable.just(true)
        }

        return DRH0KpHF7NQiDttsNcYN_4NyXiIlnouO(self.XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH).flatMap {
            _ in
            return self.DRH0KpHF7NQiDttsNcYN_4NyXiIlnouO(self.HL20Q47LeoOq23sH7DU9738VEB385bLA)
        }
    }

    func vnXrh1KOujaoqNNQgX92kZ5HEsa7AG9_() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH
        return context
    }

    func RGzaQUi7BqqoZmeCKucDKJ8V8rxyGmZB(_ zt_pmED4CGndsTEKnHTBz858zMxGGUyy: @escaping (NSManagedObjectContext) -> Void) {
        let context = vnXrh1KOujaoqNNQgX92kZ5HEsa7AG9_()
        context.perform {
            zt_pmED4CGndsTEKnHTBz858zMxGGUyy(context)
        }
    }

    func uMg_ZFHkG7pQd5uYVmu9ddFn5FSaMafQ(_ VHVVk12ZIAoD3WqMRhX_wBMsLOVYFyEg: @escaping (NSManagedObjectContext) -> Void) -> Observable<Bool> {
        return Observable.create {
            observer in
            let context = self.vnXrh1KOujaoqNNQgX92kZ5HEsa7AG9_()
            context.perform {
                VHVVk12ZIAoD3WqMRhX_wBMsLOVYFyEg(context)
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func ih9sIR2YfBvFqhgKqn1LJL7aRGWJ8kE5(_ faGBQTPUgtnBu0Rd3tunVKRYYHP52mT_: @escaping (NSManagedObjectContext) -> Void) {
        let context = XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH
        context.perform {
            faGBQTPUgtnBu0Rd3tunVKRYYHP52mT_(context)
        }
    }

    // MARK: Private methods

    fileprivate func DRH0KpHF7NQiDttsNcYN_4NyXiIlnouO(_ idTq6r3klmrXpwFaP8Ybas92elgsmkyw: NSManagedObjectContext) -> Observable<Bool> {
        return Observable.create {
            observer in

            idTq6r3klmrXpwFaP8Ybas92elgsmkyw.perform {
                do {
                    try idTq6r3klmrXpwFaP8Ybas92elgsmkyw.save()
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

    fileprivate func hRwNNpnuFszHtGPsjD9RqiwEp1PV2aw9(_ Itx3Bf2gN6h4lsm5aAKK_BeqySXyBiGp: String) {
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        queue.async {
            let url = self.aDlk34C9pyIgzrzDdmM0LywwO72vYcMZ.appendingPathComponent("Brewer.sqlite")
            let failureReason = "There was an error creating or loading the application's saved data."
            do {
                let options = [
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                ]
                try self.lxCTZVfMwRxvZz6DtMpWVrjeEl915T2O.addPersistentStore(ofType: Itx3Bf2gN6h4lsm5aAKK_BeqySXyBiGp, configurationName: nil, at: url, options: options)
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

    fileprivate lazy var WnpmX_YuSRxibKGNbHkSq71wTbjyCHSX: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Brewer", withExtension: "mom")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    fileprivate lazy var lxCTZVfMwRxvZz6DtMpWVrjeEl915T2O: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.WnpmX_YuSRxibKGNbHkSq71wTbjyCHSX)
    }()

    fileprivate lazy var aDlk34C9pyIgzrzDdmM0LywwO72vYcMZ: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
}
