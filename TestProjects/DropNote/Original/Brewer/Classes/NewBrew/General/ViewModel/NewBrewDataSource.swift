//
// Created by Maciej Oczko on 02.08.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject

final class NewBrewDataSource {
    fileprivate(set) var progressIcons: [Asset] = []
    fileprivate(set) var stepViewControllers: [[UIViewController]] = []

    let brewContext: StartBrewContext
    let brewModelController: BrewModelControllerType
    let settingsModelController: SequenceSettingsModelControllerType
    var resolver: Resolver!

    init(brewContext: StartBrewContext, brewModelController: BrewModelControllerType, settingsModelController: SequenceSettingsModelControllerType) {
        self.brewContext = brewContext
        self.brewModelController = brewModelController
        self.settingsModelController = settingsModelController
    }

    func reloadData() {
        progressIcons.removeAll()
        stepViewControllers.removeAll()
        stepViewControllers.append(loadCoffeeSectionViewControllers(brewContext))
        stepViewControllers.append(loadAttributesViewControllers(brewContext))
        stepViewControllers.append(loadSummaryViewControllers())
    }

    fileprivate func loadCoffeeSectionViewControllers(_ brewContext: StartBrewContext) -> [UIViewController] {
        func instantiateViewController(
                withIdentifier identifier: SelectableSearchIdentifier,
                model: BrewModelControllerType
            ) -> SelectableSearchViewController {
            let viewController: SelectableSearchViewController = resolver.viewControllerForIdentifier("SelectableSearch")
            viewController.viewModel = resolver.resolve(SelectableSearchViewModelType.self, arguments: identifier, model)
            viewController.title = identifier.description
            return viewController
        }

        var viewControllers = [UIViewController]()
        if brewContext.method == .CoffeeMachine {
            viewControllers.append(instantiateViewController(withIdentifier: .CoffeeMachine, model: brewModelController))
            progressIcons.append(.Ic_machine)
        }
        viewControllers.append(instantiateViewController(withIdentifier: .Coffee, model: brewModelController))
        progressIcons.append(.Ic_coffee)
        return viewControllers
    }

    fileprivate func loadAttributesViewControllers(_ brewContext: StartBrewContext) -> [UIViewController] {
        let sequence = settingsModelController
            .sequenceSteps(for: brewContext.method, filter: .active)
            .map { $0.type! }
        print(sequence)
        return sequence.map {
            progressIcons.append($0.imageName)

            let viewController = resolver.viewControllerForIdentifier($0.storyboardIdentifier())
            viewController.title = $0.description

            if viewController is NumericalInputViewController {
                let numericalInputViewModel = resolver.resolve(NumericalInputViewModelType.self, arguments: $0, brewModelController)!
                (viewController as! NumericalInputViewController).viewModel = numericalInputViewModel
            }

            if viewController is NotesViewController {
                let notesViewModel = resolver.resolve(NotesViewModelType.self, argument: brewModelController)!
                (viewController as! NotesViewController).viewModel = notesViewModel
            }

            if viewController is GrindSizeViewController {
                let grindSizeViewModel = resolver.resolve(GringSizeViewModelType.self, argument: brewModelController)!
                (viewController as! GrindSizeViewController).viewModel = grindSizeViewModel
            }

            if viewController is TampingViewController {
                let tampingViewModel = resolver.resolve(TampingViewModelType.self, argument: brewModelController)!
                (viewController as! TampingViewController).viewModel = tampingViewModel
            }

            return viewController
        }
    }

    fileprivate func loadSummaryViewControllers() -> [UIViewController] {
        let viewController: BrewDetailsViewController = resolver.viewControllerForIdentifier("BrewDetails")
        viewController.viewModel = resolver.resolve(BrewDetailsViewModelType.self, argument: brewModelController.currentBrew()!)
        return [viewController]
    }
}
