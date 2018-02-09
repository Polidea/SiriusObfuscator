//
// Created by Maciej Oczko on 17.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import XCGLogger

protocol BrewingsModelControllerType {
	var fetchedResultsController: NSFetchedResultsController<Brew> { get }
    var sortingOption: BrewingSortingOption { get set }
	func setSearchText(_ search: String?)
}

final class BrewingsModelController: BrewingsModelControllerType {
	let stack: StackType
    fileprivate let isFinishedPredicate = NSPredicate(format: "isFinished == %@", true as CVarArg)

    var sortingOption: BrewingSortingOption = .dateDescending {
        didSet {
            fetchedResultsController.fetchRequest.sortDescriptors = [sortingOption.sortDescriptor]
            do {
                try fetchedResultsController.performFetch()
            } catch {
                XCGLogger.error("Error when fetching brews = \(error)")
            }
        }
    }

	lazy var fetchedResultsController: NSFetchedResultsController<Brew> = {
		let fetchRequest = NSFetchRequest<Brew>(entityName: Brew.entityName())
		fetchRequest.sortDescriptors = [self.sortingOption.sortDescriptor]
		fetchRequest.predicate = self.isFinishedPredicate
		let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.stack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        do {
            try fetchedResultsController.performFetch()
        } catch {
            XCGLogger.error("Error when fetching brews = \(error)")
        }

		return fetchedResultsController
	}()

	init(stack: StackType) {
		self.stack = stack
	}

	func setSearchText(_ search: String?) {
		var searchPredicate: NSPredicate?
		if let search = search, !search.isEmpty {
			var subpredicates = [
					NSPredicate(format: "coffee.name CONTAINS[c] %@", search),
					NSPredicate(format: "coffeeMachine.name CONTAINS[c] %@", search),
					NSPredicate(format: "notes CONTAINS[c] %@", search)
			]

			if let score = Double(search) {
				let lowerScoreBoundary = floor(score)
				let isScoreNotPrecise = score == lowerScoreBoundary
				if isScoreNotPrecise {
					let upperScoreBoundary = floor(score + 1)
					subpredicates.append(NSPredicate(format: "score >= %lf AND score <= %lf", lowerScoreBoundary, upperScoreBoundary))
				} else {
					subpredicates.append(NSPredicate(format: "score == %lf", score))
				}
			}
			searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
		}

		fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			isFinishedPredicate,
			searchPredicate ?? NSPredicate.truePredicate()
		])

		do {
			try fetchedResultsController.performFetch()
            if let didChangeContent = fetchedResultsController.delegate?.controllerDidChangeContent {
                didChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
            }
		} catch {
			XCGLogger.error("Error when filtering brews = \(error)")
		}
	}
}
