//
// Created by Maciej Oczko on 17.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger

final class CoffeeSelectableSearchModelController: SelectableSearchModelController {
    
    override init(stack: StackType, brewModelController: BrewModelControllerType) {
        super.init(stack: stack, brewModelController: brewModelController)
        placeholder = tr(.newBrewCoffeeInputPlaceholder)
    }
    
    override func entityName() -> String {
        return Coffee.entityName()
    }

    override func setItemIndex(_ index: Int?) {
        guard let objects = fetchedResultsController.fetchedObjects else { return }
        guard let brew = brewModelController.currentBrew() else { return }
        if let index = index {
            brew.coffee = objects[index] as? Coffee
        } else {
            brew.coffee = nil
        }
    }

    override func addSearchItem() {
        guard let currentSearch = currentSearch , !currentSearch.isEmpty else { return }
        guard let brew = brewModelController.currentBrew() else { return }
        let inserter = SelectableSearchItemInserter<Coffee>(context: stack.mainContext)
        do {
            let coffee = try inserter.insertEntityWithName(currentSearch)
            coffee.name = currentSearch
            coffee.updatedAt = Date.timeIntervalSinceReferenceDate
            brew.coffee = coffee
            try inserter.save()
        } catch {
            XCGLogger.error("Error when inserting coffee entity = \(error)")
        }
    }
    
    override func selectedItemIndex() -> Int? {
        guard let coffee = brewModelController.currentBrew()?.coffee else { return nil }
        guard let coffees = fetchedResultsController.fetchedObjects as? [Coffee] else { return nil }
        return coffees.index(of: coffee)
    }
}
