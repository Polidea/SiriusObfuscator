//
//  BrewAttribute.swift
//  Brewer
//
//  Created by Maciej Oczko on 16.01.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

class BrewAttribute: NSManagedObject {

}

extension BrewAttributeType {
	var intValue: Int32 {
		switch self {
			case .Time: return 1
			case .GrindSize: return 2
			case .CoffeeWeight: return 3
			case .WaterWeight: return 4
			case .WaterTemperature: return 5
			case .TampStrength: return 6
			case .Notes: return 7
			case .PreInfusionTime: return 8
		}
	}

	static func fromIntValue(_ intValue: Int32) -> BrewAttributeType {
		switch intValue {
			case 1: return .Time
			case 2: return .GrindSize
			case 3: return .CoffeeWeight
			case 4: return .WaterWeight
			case 5: return .WaterTemperature
			case 6: return .TampStrength
			case 7: return .Notes
			case 8: return .PreInfusionTime
			default: fatalError("Wrong brew attribute int code.")
		}
	}
}

extension BrewAttribute: Entity {
	static func entityName() -> String {
		return "BrewAttribute"
	}
}
