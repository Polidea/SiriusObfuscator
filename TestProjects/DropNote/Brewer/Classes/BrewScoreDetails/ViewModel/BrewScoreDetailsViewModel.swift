//
// Created by Maciej Oczko on 01.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCGLogger

protocol BrewScoreDetailsViewModelType: TableViewConfigurable {
	var scoreValue: Variable<String> { get }
    func saveScore()
    func dropScoreChanges()
}

final class BrewScoreDetailViewModel: ScoreCellPresentable {
	fileprivate let disposeBag = DisposeBag()
	var title: String
	var value: String
	var sliderValue: Variable<Float>

	init(brew: Brew, cuppingAttriubute: CuppingAttribute) {
		title = cuppingAttriubute.description
        
		let cuppingValue = brew.cuppingAttributeForType(cuppingAttriubute)?.value ?? 0
		value = String(cuppingValue)
		sliderValue = Variable(Float(cuppingValue))
        
        sliderValue
            .asDriver()
            .drive(onNext: {
                value in
                if let cupping = brew.cuppingAttributeForType(cuppingAttriubute) {
                    cupping.brew = brew
                    cupping.type = cuppingAttriubute.rawValue
                    cupping.value = Double(value)
                }
            })
            .addDisposableTo(disposeBag)
	}
}

final class BrewScoreDetailsViewModel: BrewScoreDetailsViewModelType {
	fileprivate let disposeBag = DisposeBag()
    
    lazy var dataSource: TableViewSourceWrapper<BrewScoreDetailsViewModel> = TableViewSourceWrapper(tableDataSource: self)
    lazy var listItems: [[BrewScoreDetailViewModel]] = [
        CuppingAttribute.allValues.map { BrewScoreDetailViewModel(brew: self.brew, cuppingAttriubute: $0) }
    ]
    
	let scoreValue = Variable<String>("0")
    unowned let brew: Brew

	init(brew: Brew) {
        self.brew = brew
		scoreValue.value = String(brew.score)
		configureScoreCalculation()
	}
    
    func dropScoreChanges() {
        brew.managedObjectContext?.rollback()
    }
    
    func saveScore() {
        brew.score = Double(scoreValue.value) ?? 0
        do { try brew.managedObjectContext?.save() }
        catch { XCGLogger.error("Error when saving new brew score = \(error)") }
    }

	func configureWithTableView(_ tableView: UITableView) {
		tableView.dataSource = dataSource
	}

	fileprivate func configureScoreCalculation() {
        guard let items = listItems.first else { return }
		let sliderValues = items.map { $0.sliderValue }

        Observable
            .from(sliderValues.map { $0.asDriver() })
			.merge()
			.map { _ in self.totalScore(sliderValues.map { $0.value }) }
			.map { $0.format(".1") }
			.bindTo(scoreValue)
			.addDisposableTo(disposeBag)
	}

	fileprivate func totalScore(_ values: [Float]) -> Float {
        guard !values.isEmpty else {
            return 0
        }
		return values.reduce(0) { $0 + $1 / Float(values.count) }
	}
}

extension BrewScoreDetailsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return "BrewScoreDetailCell"
    }
    
    func listView(_ listView: UITableView, configureCell cell: BrewScoreDetailCell,
                  withObject object: BrewScoreDetailViewModel, atIndexPath indexPath: IndexPath) {
        cell.configureWithPresentable(listItems[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])
    }
}
