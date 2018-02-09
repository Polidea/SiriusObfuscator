//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa

@objc protocol SelectableSearchModelItem {
    var name: String? { get set }
}

protocol SelectableSearchViewModelType: TableViewConfigurable {
    var placeholder: String { get }

    func setSearchString(_ search: String?)
    func addNewSearchItemIfNeeded(_ search: String?)
    func selectItemAtIndexPath(_ indexPath: IndexPath)
}

final class SelectableSearchViewModel: NSObject, SelectableSearchViewModelType {
    
    fileprivate(set) var placeholder: String
  // swiftlint:disable weak_delegate
    fileprivate(set) var fetchedResultsControllerDelegate: TableViewFetchedResultsControllerDynamicChangesHandler<NSManagedObject>!
  // swiftlint:enable weak_delegate
    fileprivate var selectedItemIndex: Int? {
        didSet {
            modelController.setItemIndex(selectedItemIndex)
        }
    }

    let modelController: SelectableSearchModelControllerType

    init(modelController: SelectableSearchModelControllerType) {
        self.modelController = modelController
        placeholder = modelController.placeholder ?? ""
    }

    lazy var dataSource: TableViewSourceWrapper<SelectableSearchViewModel> = TableViewSourceWrapper(tableDataSource: self)

    // MARK: Table View configuration

    var listItems: [[SelectableSearchModelItem]] {
        let items = modelController.fetchedResultsController.fetchedObjects ?? []
        return [items.map { $0 as! SelectableSearchModelItem }]
    }

    func configureWithTableView(_ tableView: UITableView) {
        tableView.dataSource = dataSource
        fetchedResultsControllerDelegate =
            TableViewFetchedResultsControllerDynamicChangesHandler(
                tableView: tableView,
                fetchedResultsController: modelController.fetchedResultsController
        )
        selectedItemIndex = modelController.selectedItemIndex()
    }

    func selectItemAtIndexPath(_ indexPath: IndexPath) {
        selectedItemIndex = selectedItemIndex == (indexPath as NSIndexPath).row ? nil : (indexPath as NSIndexPath).row
        fetchedResultsControllerDelegate.refresh()
    }

    // MARK: Search

    func setSearchString(_ search: String?) {
        guard let search = search else { return }
        let trimmedSearch = search.trimmingCharacters(in: CharacterSet.whitespaces)
        modelController.setSearchString(trimmedSearch)
        selectedItemIndex = nil
        fetchedResultsControllerDelegate.refresh()
    }
    
    func addNewSearchItemIfNeeded(_ search: String?) {
        guard listItems.first!.isEmpty else { return }
        guard let search = search else { return }
        
        let trimmedSearch = search.trimmingCharacters(in: CharacterSet.whitespaces)
        modelController.setSearchString(trimmedSearch)
        modelController.addSearchItem()
    }
}

extension SelectableSearchViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return "SelectableSearchResultViewCell"
    }

    func listView(_ listView: UITableView, configureCell cell: UITableViewCell,
                  withObject object: SelectableSearchModelItem, atIndexPath indexPath: IndexPath) {
        
        cell.textLabel?.text = listItems[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].name
        
        if selectedItemIndex == (indexPath as NSIndexPath).row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}
