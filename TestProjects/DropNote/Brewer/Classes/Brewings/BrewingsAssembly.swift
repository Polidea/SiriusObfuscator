//
// Created by Maciej Oczko on 20.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class BrewingsAssembly: AssemblyType {
    func assemble(container: Container) {

        container.registerForStoryboard(BrewingsViewController.self) {
            r, c in
            c.viewModel = r.resolve(BrewingsViewModelType.self)!
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
            c.resolver = r
        }

        container.register(BrewingsViewModelType.self) {
            r in BrewingsViewModel(brewsModelController: r.resolve(BrewingsModelControllerType.self)!,
                                 spotlightSearchService: r.resolve(SpotlightSearchService.self)!)
        }

        container.register(BrewingsModelControllerType.self) {
            r in BrewingsModelController(stack: r.resolve(StackType.self)!)
        }
    }
}
