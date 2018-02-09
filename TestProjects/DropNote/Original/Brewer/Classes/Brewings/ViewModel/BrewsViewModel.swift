//
//  BrewsViewmoModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 20.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa
import XCGLogger
import CoreSpotlight
import MobileCoreServices

protocol BrewingsViewModelType: TableViewConfigurable {
    var sortingOption: BrewingSortingOption { get set }

    func brew(forIndexPath indexPath: IndexPath) -> Brew
	func brew(for activity: NSUserActivity) -> Brew?
    func setSearchText(_ searchText: String)
    func resetFilters()
}

final class BrewingsViewModel: BrewingsViewModelType {
    fileprivate(set) var brewsModelController: BrewingsModelControllerType
  // swiftlint:disable weak_delegate
	fileprivate(set) var fetchedResultsControllerDelegate: TableViewFetchedResultsControllerDynamicChangesHandler<Brew>!
  // swiftlint:enable weak_delegate

	private let spotlightSearchService: SpotlightSearchService
    
    var sortingOption: BrewingSortingOption = .dateDescending {
        didSet {
            brewsModelController.sortingOption = sortingOption
        }
    }
    
    fileprivate var brews: [Brew] {
        return brewsModelController.fetchedResultsController.fetchedObjects ?? []
    }
    
    var listItems: [[BrewCellViewModel]] {
        return [brews.map(BrewCellViewModel.init)]
    }
    
    lazy var dataSource: TableViewSourceWrapper<BrewingsViewModel> = TableViewSourceWrapper(tableDataSource: self)

	init(brewsModelController: BrewingsModelControllerType, spotlightSearchService: SpotlightSearchService) {
		self.brewsModelController = brewsModelController
		self.spotlightSearchService = spotlightSearchService
	}

	func configureWithTableView(_ tableView: UITableView) {
		fetchedResultsControllerDelegate = TableViewFetchedResultsControllerDynamicChangesHandler(
			tableView: tableView,
			fetchedResultsController: brewsModelController.fetchedResultsController
        ) { [weak self] in
            tableView.reloadData()
			guard let `self` = self else { return }
			self.spotlightSearchService.updateSearchableIndex(with: self.brews)
        }
		tableView.dataSource = dataSource
	}
    
    func brew(forIndexPath indexPath: IndexPath) -> Brew {
        return brews[(indexPath as NSIndexPath).row]
    }
    
    func setSearchText(_ text: String) {
        brewsModelController.setSearchText(text)
    }
    
    func resetFilters() {
        brewsModelController.setSearchText(nil)
    }

	func brew(for activity: NSUserActivity) -> Brew? {
		return spotlightSearchService.selectedBrew(for: activity, from: brews)
	}
}

extension BrewingsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return "BrewCell"
    }
    
    func listView(_ listView: UITableView, configureCell cell: BrewCell, withObject object: BrewCellViewModel, atIndexPath indexPath: IndexPath) {
        cell.configureWithViewModel(object)
    }
}
