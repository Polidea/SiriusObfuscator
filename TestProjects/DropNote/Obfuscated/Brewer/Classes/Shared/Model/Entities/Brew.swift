//
//  Brew.swift
//  Brewer
//
//  Created by Maciej Oczko on 16.01.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

class Brew: NSManagedObject {

	func gdJSFWqE7l492PuH5sr2jTWDZyMBO572() -> [BrewAttribute] {
		guard let attributes = brewAttributes else {
			return []
		}
		return attributes.allObjects as! [BrewAttribute]
	}

	func CIT4NIIpB4gskA2aF8IT74ou_B7fMd_A(_ noAVqhLBmDHheJtNFA3HeUKgQrPtnSRo: Dvzdce97fie2QBNN2QeyAMRncrQUlOcu) -> BrewAttribute? {
		guard let attributes = brewAttributes , !attributes.isEmpty else {
			return nil
		}
		return attributes
			.filter { ($0 as! BrewAttribute).type == noAVqhLBmDHheJtNFA3HeUKgQrPtnSRo.intValue }
			.last as? BrewAttribute
	}

	func Ze7L2kdZGvizaRUhNX5WjF50uhn9r36Q(_ q6LzZOSjhb8AU4EB5DmV4tkEUHdUhvrO: vrYgz8ae2jdaPI26N_gsmzoxFTBAI3Ze) -> Cupping? {
		guard let attributes = cuppingAttributes , !attributes.isEmpty else {
			return nil
		}
		return attributes
			.filter { ($0 as! Cupping).type == q6LzZOSjhb8AU4EB5DmV4tkEUHdUhvrO.rawValue }
			.last as? Cupping
	}
}

extension Brew: JIYMScaUYtWOwxrqigfwVzlyftw3yezf {
	static func kiP0LT8ZEQiRcS3ZjoViSQTJwbjg0NkS() -> String {
		return "Brew"
	}
}
