//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import XCGLogger

// swiftlint:disable type_name
final class TableViewFetchedResultsControllerDynamicChangesHandler<ResultType: NSManagedObject>
// swiftlint:enable type_name    
    : NSObject
    , NSFetchedResultsControllerDelegate {
    
    fileprivate(set) unowned var tableView: UITableView
    unowned fileprivate let fetchedResultsController: NSFetchedResultsController<ResultType>
    var animationType: UITableViewRowAnimation = .none

    var results: [AnyObject] {
        return fetchedResultsController.fetchedObjects ?? []
    }

    var updateCompletion: (() -> Void)?

    init(tableView: UITableView, fetchedResultsController: NSFetchedResultsController<ResultType>, updateCompletion: (() -> Void)? = nil) {
        self.fetchedResultsController = fetchedResultsController
        self.tableView = tableView
        self.updateCompletion = updateCompletion
        super.init()
        setup()
    }

    fileprivate func setup() {
        fetchedResultsController.delegate = self
        refresh()
        if let updateCompletion = updateCompletion {
            updateCompletion()
        }
    }

    func refresh() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            switch error {
            case let error as NSError:
                XCGLogger.error("Error performing fetch = \((error as NSError).localizedDescription)")
                break
            default:
                break
            }
        }
    }

    // MARK: NSFetchedResultsControllerDelegate

    @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updateCompletion = updateCompletion {
            updateCompletion()
        }
    }
}
