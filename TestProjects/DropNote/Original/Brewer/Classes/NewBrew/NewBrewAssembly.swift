//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable function_body_length
final class NewBrewAssembly: Assembly {
	func assemble(container: Container) {

		// MARK: New Brew container

		container.storyboardInitCompleted(NewBrewViewController.self) {
			r, c in
			c.metrics = r.resolve(ScrollViewPageMetricsType.self)!
			c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(NewBrewViewModelType.self) {
			(r, context: StartBrewContext) in
			let viewModel = NewBrewViewModel(brewContext: context,
											 settingsModelController: r.resolve(SequenceSettingsModelControllerType.self)!,
											 newBrewModelController: r.resolve(BrewModelControllerType.self)!)
			viewModel.resolver = r
			return viewModel
		}

		container.register(BrewModelControllerType.self) {
			r in BrewModelController(stack: r.resolve(StackType.self)!)
		}

		container.register(BrewModelControllerType.self) {
			(r, brew: Brew) in BrewModelController(stack: r.resolve(StackType.self)!, brew: brew)
		}

		container.register(ScrollViewPageMetricsType.self) {
			_ in ScrollViewPageMetrics()
		}

		// MARK: Selectable search

		container.storyboardInitCompleted(SelectableSearchViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(SelectableSearchViewModelType.self) {
			(r, identifier: SelectableSearchIdentifier, brewModelController: BrewModelControllerType) in
			return SelectableSearchViewModel(modelController:
					r.resolve(SelectableSearchModelControllerType.self, arguments: identifier, brewModelController)!
			)
		}

		container.register(SelectableSearchModelControllerType.self) {
			(r, identifier: SelectableSearchIdentifier, brewModelController: BrewModelControllerType) in

			switch identifier {
			case .Coffee: return r.resolve(CoffeeSelectableSearchModelController.self, argument: brewModelController)!
			case .CoffeeMachine: return r.resolve(CoffeeMachineSelectableSearchModelController.self, argument: brewModelController)!
			}
		}

		// MARK: Coffee & CoffeeMachine

		container.register(CoffeeSelectableSearchModelController.self) {
			r, brewModelController in CoffeeSelectableSearchModelController(stack: r.resolve(StackType.self)!, brewModelController: brewModelController)
		}

		container.register(CoffeeMachineSelectableSearchModelController.self) {
			r, brewModelController in CoffeeMachineSelectableSearchModelController(stack: r.resolve(StackType.self)!, brewModelController: brewModelController)
		}

		// MARK: Numerical input

		container.storyboardInitCompleted(NumericalInputViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(NumericalInputViewModelType.self) {
			(r, attribute: BrewAttributeType, brewModelController: BrewModelControllerType) in
			switch attribute {
			case .PreInfusionTime: return r.resolve(PreInfusionTimeInputViewModel.self, argument: brewModelController)!
			case .Time: return r.resolve(TimeInputViewModel.self, argument: brewModelController)!
			case .CoffeeWeight: return r.resolve(WeightInputViewModel.self, argument: brewModelController)!
			case .WaterWeight: return r.resolve(WaterInputViewModel.self, argument: brewModelController)!
			case .WaterTemperature: return r.resolve(TemperatureInputViewModel.self, argument: brewModelController)!
			default: fatalError("Wrong type selected for numeric input!")
			}
		}

		// MARK: Attributes: Weight, Water, Temperature, Time

		container.register(WeightInputViewModel.self) {
			r, brewModelController in WeightInputViewModel(unitModelController: r.resolve(UnitsModelControllerType.self)!, brewModelController: brewModelController)
		}

		container.register(WaterInputViewModel.self) {
			r, brewModelController in WaterInputViewModel(unitModelController: r.resolve(UnitsModelControllerType.self)!, brewModelController: brewModelController)
		}

		container.register(TemperatureInputViewModel.self) {
			r, brewModelController in TemperatureInputViewModel(
                unitModelController: r.resolve(UnitsModelControllerType.self)!,
                brewModelController: brewModelController
            )
		}

		container.register(TimeInputViewModel.self) {
			r, brewModelController in TimeInputViewModel(unitModelController: r.resolve(UnitsModelControllerType.self)!, brewModelController: brewModelController)
		}
        
        container.register(PreInfusionTimeInputViewModel.self) {
            r, brewModelController in
          PreInfusionTimeInputViewModel(
            unitModelController: r.resolve(UnitsModelControllerType.self)!,
            brewModelController: brewModelController
          )
        }

		// MARK: Notes

		container.storyboardInitCompleted(NotesViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(NotesViewModelType.self) {
			_, brewModelController in NotesViewModel(brewModelController: brewModelController)
		}

		// MARK: Grind Size

		container.storyboardInitCompleted(GrindSizeViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(GringSizeViewModelType.self) {
			r, brewModelController in GringSizeViewModel(brewModelController: brewModelController,
														 keyValueStore: r.resolve(KeyValueStoreType.self)!)
		}

		// MARK: Tamping

		container.storyboardInitCompleted(TampingViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(TampingViewModelType.self) {
			_, brewModelController in TampingViewModel(brewModelController: brewModelController)
		}
	}
}
// swiftlint:enable function_body_length
