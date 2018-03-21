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

extension Dvzdce97fie2QBNN2QeyAMRncrQUlOcu {
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

	static func T_lO68jyKirZXAtJfKu0yFCnsaIB8xED(_ dzO19ybOg3zVG3y43dbm1va3PwqmhUK7: Int32) -> Dvzdce97fie2QBNN2QeyAMRncrQUlOcu {
		switch dzO19ybOg3zVG3y43dbm1va3PwqmhUK7 {
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

extension BrewAttribute: JIYMScaUYtWOwxrqigfwVzlyftw3yezf {
	static func kiP0LT8ZEQiRcS3ZjoViSQTJwbjg0NkS() -> String {
		return "BrewAttribute"
	}
}
