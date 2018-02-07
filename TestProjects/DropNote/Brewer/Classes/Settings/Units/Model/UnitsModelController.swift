//
// Created by Maciej Oczko on 18.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger

protocol UnitsModelControllerType {
    func rawUnit(forCategory rawCategory: Int) -> Int
    func setRawUnit(_ rawUnit: Int, forCategory rawCategory: Int)
}

final class UnitsModelController: UnitsModelControllerType {
    struct Keys {
        static let units = "UnitsSettingsKey"
    }
    
    fileprivate let store: KeyValueStoreType
    fileprivate(set) var unitsSettings = [String: Int]()

    init(store: KeyValueStoreType) {
        self.store = store
        presetDefaultSettings()
        loadSettings()
    }

    func rawUnit(forCategory rawCategory: Int) -> Int {
        return unitsSettings[String(rawCategory)]!
    }

    func setRawUnit(_ rawUnit: Int, forCategory rawCategory: Int) {
        unitsSettings[String(rawCategory)] = rawUnit
        store.set(unitsSettings, forKey: Keys.units)
        _ = store.synchronize()
    }

    // MARK: Settings loading

    fileprivate func loadSettings() {
        guard let rawUnitsSettings = store.object(forKey: Keys.units) as? [String: Int] else {
            XCGLogger.error("Can't load settings!")
            return
        }
        unitsSettings = rawUnitsSettings
    }

    // MARK: Default settings

    fileprivate func presetDefaultSettings() {
        if store.object(forKey: Keys.units) == nil {
            let defaultSettings = [
                String(UnitCategory.water.rawValue): UnitCategory.water.defaultSetting(),
                String(UnitCategory.weight.rawValue): UnitCategory.weight.defaultSetting(),
                String(UnitCategory.temperature.rawValue): UnitCategory.temperature.defaultSetting()
            ]
            store.set(defaultSettings, forKey: Keys.units)
            _ = store.synchronize()
        }
    }
}
