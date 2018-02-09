//
// Created by Maciej Oczko on 24.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

enum BrewAttributeType: String {
	case PreInfusionTime
	case Time
	case GrindSize
	case CoffeeWeight
	case WaterWeight
	case WaterTemperature
	case TampStrength
	case Notes

	static let allValues = [PreInfusionTime, Time, GrindSize, CoffeeWeight, WaterWeight, WaterTemperature, TampStrength, Notes]
}

extension BrewAttributeType {
	var segueIdentifier: SegueIdentifier {
		switch self {
			case .PreInfusionTime: return .NumericalInput
			case .Time: return .NumericalInput
			case .GrindSize: return .GrindSize
			case .CoffeeWeight: return .NumericalInput
			case .WaterWeight: return .NumericalInput
			case .WaterTemperature: return .NumericalInput
			case .TampStrength: return .Tamping
			case .Notes: return .Notes
		}
	}
}

extension BrewAttributeType {
	func format(_ value: Double, withUnitType unit: Int32) -> String {
		switch self {
			case .Time, .PreInfusionTime:
				let formatter = DateComponentsFormatter()
				formatter.unitsStyle = .abbreviated
				var components = DateComponents()
				components.second = Int(value) % 60
				components.minute = Int(value / 60)
				return formatter.string(from: components) ?? ""
			case .CoffeeWeight, .WaterWeight:
				return "\(value) \(UnitCategory.unitDescriptionFromIntValue(unit))"
			case .WaterTemperature:
				return value.format(".0") + " " + UnitCategory.unitDescriptionFromIntValue(unit)
			case .GrindSize:
				switch GrindSizeUnit(rawValue: unit)! {
					case .slider:
						return GrindSizeSliderValue(rawValue: value)?.description ?? ""
					case .numeric:
						return Double(value).format(".1")
				}
			case .TampStrength: return value.format(".1")
			default: fatalError("Unsupported format for brew attribute!")
		}
	}
}

extension BrewAttributeType: CustomStringConvertible {
	var description: String {
		switch self {
			case .PreInfusionTime: return tr(.attributePreInfusionTime)
			case .Time: return tr(.attributeTime)
			case .GrindSize: return tr(.attributeGrindSize)
			case .CoffeeWeight: return tr(.attributeCoffeeWeight)
			case .WaterWeight: return tr(.attributeWaterWeight)
			case .WaterTemperature: return tr(.attributeTemperature)
			case .TampStrength: return tr(.attributeTampStrength)
			case .Notes: return tr(.attributeNotes)
		}
	}
}

extension BrewAttributeType {
	var imageName: Asset {
		switch self {
			case .Time: return .Ic_time
			case .PreInfusionTime: return .Ic_time
			case .GrindSize: return .Ic_grind
			case .CoffeeWeight: return .Ic_weight
			case .WaterWeight: return .Ic_water
			case .WaterTemperature: return .Ic_temp
			case .TampStrength: return .Ic_tamp
			case .Notes: return .Ic_notes
		}
	}
}

extension BrewAttributeType {
	func storyboardIdentifier() -> String {
		switch self {
			case .Time: return "NumericalInput"
			case .PreInfusionTime: return "NumericalInput"
			case .GrindSize: return "GrindSize"
			case .CoffeeWeight: return "NumericalInput"
			case .WaterWeight: return "NumericalInput"
			case .WaterTemperature: return "NumericalInput"
			case .TampStrength: return "Tamping"
			case .Notes: return "Notes"
		}
	}
}
