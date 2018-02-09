//
// Created by Maciej Oczko on 21.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class SettingsAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: Main

        container.storyboardInitCompleted(SettingsViewController.self) {
            r, c in
            c.viewModel = r.resolve(SettingsViewModel.self)!
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
        }

        container.register(SettingsViewModel.self) {
            _ in SettingsViewModel()
        }

        // MARK: Method picker

        container.storyboardInitCompleted(MethodPickerViewController.self) {
            r, c in
            c.viewModel = r.resolve(MethodPickerViewModelType.self)!
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
        }

        container.register(MethodPickerViewModelType.self) {
            _ in MethodPickerViewModel()
        }

        // MARK: Sequence

        container.storyboardInitCompleted(SequenceSettingsViewController.self) {
            r, c in
            c.viewModel = r.resolve(SequenceSettingsViewModelType.self)!
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
        }

        container.register(SequenceSettingsViewModelType.self) {
            r in SequenceSettingsViewModel(modelController: r.resolve(SequenceSettingsModelControllerType.self)!)
        }

        container.register(SequenceSettingsModelControllerType.self) {
            r in SequenceSettingsModelController(store: r.resolve(KeyValueStoreType.self)!)
        }

        // MARK: Units

        container.storyboardInitCompleted(UnitsViewController.self) {
            r, c in
            c.viewModel = r.resolve(UnitsViewModelType.self)!
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
        }

        container.register(UnitsViewModelType.self) {
            r in UnitsViewModel(modelController: r.resolve(UnitsModelControllerType.self)!, dataSourcesFactory: r.resolve(UnitsDataSourcesFactoryType.self)!)
        }

        container.register(UnitsDataSourcesFactoryType.self) {
            _ in UnitsDataSourcesFactory()
        }

        container.register(UnitsModelControllerType.self) {
            r in UnitsModelController(store: r.resolve(KeyValueStoreType.self)!)
        }
        
        // MARK: About
        
        container.storyboardInitCompleted(AboutViewController.self) {
            r, c in
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
        }
    }
}

extension UserDefaults: KeyValueStoreType {

}
