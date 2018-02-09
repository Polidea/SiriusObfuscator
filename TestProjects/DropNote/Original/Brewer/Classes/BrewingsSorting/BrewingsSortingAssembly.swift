//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class BrewingsSortingAssembly: Assembly {
    func assemble(container: Container) {
        container.storyboardInitCompleted(BrewingsSortingViewController.self) {
            r, c in
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
            c.viewModel = r.resolve(BrewingsSortingViewModelType.self)!
        }

        container.register(BrewingsSortingViewModelType.self) {
            _ in return BrewingsSortingViewModel()
        }
    }
}
