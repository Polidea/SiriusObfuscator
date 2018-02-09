//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger
import ObjectMapper

private func <<T: Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
		case let (l?, r?):
			return l < r
		case (nil, _?):
			return true
		default:
			return false
	}
}

enum SequenceStepFilter {
	case all
	case active
}

protocol SequenceSettingsModelControllerType {
	func sequenceSteps(for brewMethod: BrewMethod, filter: SequenceStepFilter) -> [BrewingSequenceStep]
	func saveSequenceSteps(for brewMethod: BrewMethod, sequenceSteps: [BrewingSequenceStep])
}

final class SequenceSettingsModelController: SequenceSettingsModelControllerType {
    struct Keys {
        static let brewingSequence = "BrewingSequenceSettingsKey"
    }
    
    private let store: KeyValueStoreType
    private let brewingSequenceMapper = Mapper<BrewingSequenceStep>()
    private(set) var brewingSequenceSettings: [BrewMethod: [BrewingSequenceStep]] = [:]

	init(store: KeyValueStoreType) {
		self.store = store
		presetDefaultSettings()
		loadSettings()
		loadMissingPresetDefaults(for: .Kalita)
		loadMissingPresetDefaults(for: .Kone)
		addToDefaultPreset(brewAttributeType: BrewAttributeType.PreInfusionTime)
	}

	func sequenceSteps(for brewMethod: BrewMethod, filter: SequenceStepFilter) -> [BrewingSequenceStep] {
		return brewingSequenceSettings[brewMethod]?
					   .filter {
						   filter == .all ? true : $0.enabled!
					   }
					   .sorted {
						   $0.position < $1.position
					   } ?? []
	}

	func saveSequenceSteps(for brewMethod: BrewMethod, sequenceSteps: [BrewingSequenceStep]) {
		brewingSequenceSettings[brewMethod] = sequenceSteps
		saveSettings()
	}

	// MARK: Settings saving

    private func saveSettings() {
        var rawSequenceSettings: [String: String] = [:]
        brewingSequenceSettings.forEach {
            method, steps in
            rawSequenceSettings[method.rawValue] = brewingSequenceMapper.toJSONString(steps)
        }
        store.set(rawSequenceSettings, forKey: Keys.brewingSequence)
        _ = store.synchronize()
    }

	// MARK: Settings loading

    private func loadSettings() {
        guard let rawSequenceSettings = store.object(forKey: Keys.brewingSequence) as? [String: String] else {
            XCGLogger.error("Can't load settings!")
            return
        }
        rawSequenceSettings.forEach {
            brewingSequenceSettings[BrewMethod(rawValue: $0)!] = brewingSequenceMapper.mapArray(JSONString: $1) ?? []
        }
    }

	// MARK: Default settings

    private func presetDefaultSettings() {
        if store.object(forKey: Keys.brewingSequence) == nil {

            var defaultSequenceSettings: [String: String] = [:]
            for method in BrewMethod.allValues {
                let sequenceSteps = defaultSequenceSteps(for: method)
                defaultSequenceSettings[method.rawValue] = brewingSequenceMapper.toJSONString(sequenceSteps)
            }
            store.set(defaultSequenceSettings, forKey: Keys.brewingSequence)
        }
    }

    private func defaultSequenceSteps(for method: BrewMethod) -> [BrewingSequenceStep] {
        return BrewAttributeType.allValues.map {
            BrewingSequenceStep(
                    type: $0,
                    position: $0.defaultPosition(forMethod: method),
                    enabled: $0.defaultEnabled(forMethod: method)
            )
        }
    }

    private func loadMissingPresetDefaults(for method: BrewMethod) {
        if brewingSequenceSettings[method] == nil {
            saveSequenceSteps(for: method, sequenceSteps: defaultSequenceSteps(for: method))
        }
    }

	private func addToDefaultPreset(brewAttributeType: BrewAttributeType) {
		for method in BrewMethod.allValues {
			var steps = sequenceSteps(for: method, filter: .all)
			let newSteps = steps.filter {
				$0.type == brewAttributeType
			}
			if newSteps.isEmpty {
				let newBrewingSequenceStep = BrewingSequenceStep(
						type: brewAttributeType,
						position: brewAttributeType.defaultPosition(forMethod: method),
						enabled: brewAttributeType.defaultEnabled(forMethod: method)
				)
				steps.append(newBrewingSequenceStep)
				saveSequenceSteps(for: method, sequenceSteps: steps)
			}
		}
	}
}

struct BrewingSequenceStep: Mappable {
	var type: BrewAttributeType?
	var position: Int?
	var enabled: Bool?

	init(type: BrewAttributeType?, position: Int?, enabled: Bool?) {
		self.type = type
		self.position = position
		self.enabled = enabled
	}

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
		type <- map["type"]
		position <- map["position"]
		enabled <- map["enabled"]
	}

	mutating func setEnabled(_ enabled: Bool) {
		self.enabled = enabled
	}

	mutating func setPosition(_ position: Int) {
		self.position = position
	}
}
