//
// Created by Maciej Oczko on 17.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger

final class CoffeeMachineSelectableSearchModelController: SelectableSearchModelController {
    
    override init(stack: StackType, brewModelController: BrewModelControllerType) {
        super.init(stack: stack, brewModelController: brewModelController)
        placeholder = tr(.newBrewCoffeeMachinePlaceholder)
    }
    
    override func entityName() -> String {
        return CoffeeMachine.entityName()
    }

    override func setItemIndex(_ index: Int?) {
        guard let objects = fetchedResultsController.fetchedObjects else { return }
        guard let brew = brewModelController.currentBrew() else { return }
        if let index = index {            
            brew.coffeeMachine = objects[index] as? CoffeeMachine
        } else {
            brew.coffeeMachine = nil
        }
    }

    override func addSearchItem() {
        guard let currentSearch = currentSearch , !currentSearch.isEmpty else { return }
        guard let brew = brewModelController.currentBrew() else { return }
        let inserter = SelectableSearchItemInserter<CoffeeMachine>(context: stack.mainContext)
        do {
            let coffeeMachine = try inserter.insertEntityWithName(currentSearch)
            coffeeMachine.name = currentSearch
            coffeeMachine.updatedAt = Date.timeIntervalSinceReferenceDate
            brew.coffeeMachine = coffeeMachine
            try inserter.save()
        } catch {
            XCGLogger.error("Error when inserting coffee machine = \(error)")
        }
    }
    
    override func selectedItemIndex() -> Int? {
        guard let coffeeMachine = brewModelController.currentBrew()?.coffeeMachine else { return nil }
        guard let machines = fetchedResultsController.fetchedObjects as? [CoffeeMachine] else { return nil }
        return machines.index(of: coffeeMachine)
    }
}
