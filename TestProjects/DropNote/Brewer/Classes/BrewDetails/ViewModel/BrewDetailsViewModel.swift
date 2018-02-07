//
//  BrewDetailsViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 17.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum BrewDetailsTableViewSection: Int {
	case score = 0
	case coffeeInfo = 1
	case attributes = 2
	case notes = 3
    case remove = 4

	var cellIdentifier: String {
		switch self {
		case .score:
			return "FinalScoreCell"
		case .coffeeInfo, .attributes:
			return "BrewAttributeCell"
		case .notes:
			return "BrewNotesCell"
        case .remove:
            return "BrewDetailsRemoveCell"
		}
	}
}

protocol BrewDetailsViewModelType: TableViewConfigurable {
	var editable: Bool { get set }
	var brewModelController: BrewModelControllerType { get }

	func refreshData()
	
    func sectionType(forIndexPath indexPath: IndexPath) -> BrewDetailsTableViewSection
    func brewAttributeType(forIndexPath indexPath: IndexPath) -> BrewAttributeType
    func coffeeAttribute(forIndexPath indexPath: IndexPath) -> SelectableSearchIdentifier
    
	func currentBrew() -> Brew
    func removeCurrentBrew(_ completion: @escaping ((Bool) -> Void))
	func saveBrewIfNeeded()
}

struct BrewDetailsPresentable: TitleValuePresentable {
	var title: String
	var value: String
	var attribute: BrewAttributeType?
	var selectableSearchIdentifier: SelectableSearchIdentifier?

	init(attribute: BrewAttribute) {
		let attributeType = BrewAttributeType.fromIntValue(attribute.type)
		self.attribute = attributeType
		title = attributeType.description
		value = attributeType.format(attribute.value, withUnitType: attribute.unit)
	}

	init(title: String, value: String) {
		self.title = title
		self.value = value
	}

	init(title: String, value: String, identifier: BrewAttributeType?) {
		self.title = title
		self.value = value
		self.attribute = identifier
	}

	init(title: String, value: String, identifier: SelectableSearchIdentifier?) {
		self.title = title
		self.value = value
		self.selectableSearchIdentifier = identifier
	}
}

final class BrewDetailsViewModel: BrewDetailsViewModelType {
	private let disposeBag = DisposeBag()
	let brewModelController: BrewModelControllerType
	var editable: Bool = false

	private let spotlightSearchService: SpotlightSearchService
    private lazy var dataSource: TableViewSourceWrapper<BrewDetailsViewModel> = TableViewSourceWrapper(tableDataSource: self)

	init(brewModelController: BrewModelControllerType, spotlightSearchService: SpotlightSearchService) {
		self.brewModelController = brewModelController
		self.spotlightSearchService = spotlightSearchService
	}

	func configureWithTableView(_ tableView: UITableView) {
		refreshData()
		tableView.dataSource = dataSource
	}

	func currentBrew() -> Brew {
		return brewModelController.currentBrew()!
	}

	func saveBrewIfNeeded() {
		if editable {
            brewModelController.saveBrew().subscribe(onError: {
				print(($0 as NSError).localizedDescription)
			}).addDisposableTo(disposeBag)
		}
	}

	var listItems: [[TitleValuePresentable]] = []

	func refreshData() {
		let presentables: [TitleValuePresentable] = currentBrew().brewAttributesArray().map(BrewDetailsPresentable.init)
		listItems.removeAll()
        
        var scoreValue = "?"
        if currentBrew().score > 0 {
            scoreValue = currentBrew().score.format(".1")
        }
        
		listItems.append([
			BrewDetailsPresentable(title: tr(.brewDetailScore), value: scoreValue)
		])

		var coffeePresentables: [TitleValuePresentable] = [
			BrewDetailsPresentable(
				title: SelectableSearchIdentifier.Coffee.description,
				value: currentBrew().coffee?.name ?? "",
				identifier: .Coffee)
		]
		if let coffeeMachine = currentBrew().coffeeMachine {
			coffeePresentables.append(
				BrewDetailsPresentable(
					title: SelectableSearchIdentifier.CoffeeMachine.description,
					value: coffeeMachine.name ?? "",
					identifier: .CoffeeMachine
                )
			)
		}
		listItems.append(coffeePresentables)
		listItems.append(presentables)
		listItems.append([
			BrewDetailsPresentable(
				title: tr(.attributeNotes),
				value: currentBrew().notes ?? "",
				identifier: .Notes)
		])
        if editable {
            listItems.append([BrewDetailsPresentable(title: tr(.brewDetailsRemoveTitle), value: "")])
        }
	}

	func sectionType(forIndexPath indexPath: IndexPath) -> BrewDetailsTableViewSection {
		if let sectionType = BrewDetailsTableViewSection(rawValue: (indexPath as NSIndexPath).section) {
			return sectionType
		}
		fatalError("No section type for \((indexPath as NSIndexPath).section)")
	}
    
    func brewAttributeType(forIndexPath indexPath: IndexPath) -> BrewAttributeType {
        let item = listItems[(indexPath as NSIndexPath).section].elements(ofType: BrewDetailsPresentable.self)[(indexPath as NSIndexPath).row]
        return item.attribute!
    }
    
    func coffeeAttribute(forIndexPath indexPath: IndexPath) -> SelectableSearchIdentifier {
        let item = listItems[(indexPath as NSIndexPath).section].elements(ofType: BrewDetailsPresentable.self)[(indexPath as NSIndexPath).row]
        return item.selectableSearchIdentifier!
    }
    
    func removeCurrentBrew(_ completion: @escaping ((Bool) -> Void)) {
		let uniqueSearchableBrewIdentifier = spotlightSearchService.uniqueSearchableIndexIdentifier(for: currentBrew())
        brewModelController
				.removeCurrentBrew()
				.do(onNext: {
					[weak self] deleted in
					if deleted {
						self?.spotlightSearchService.deleteFromSearchableIndex(using: uniqueSearchableBrewIdentifier)
					}
				})
				.subscribe(onNext: completion)
				.addDisposableTo(disposeBag)
    }
}

extension BrewDetailsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return sectionType(forIndexPath: indexPath).cellIdentifier
    }
    
    func listView(_ listView: UITableView, configureCell cell: UITableViewCell, withObject object: TitleValuePresentable, atIndexPath indexPath: IndexPath) {
        let sectionType = self.sectionType(forIndexPath: indexPath)
        if sectionType != .score && sectionType != .remove {
            cell.accessoryType = editable ? .disclosureIndicator : .none
        }
        let presentable = listItems[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        (cell as? FinalScoreCell)?.configureWithPresentable(presentable)
        (cell as? BrewAttributeCell)?.configureWithPresentable(presentable)
        (cell as? BrewNotesCell)?.configureWithPresentable(presentable)
        (cell as? BrewDetailsRemoveCell)?.configureWithPresentable(presentable)
    }
}
