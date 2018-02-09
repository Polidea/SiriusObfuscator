//
// Created by Maciej Oczko on 24.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

enum BrewMethod: String {
	case CoffeeMachine
	case PourOverV60
	case PourOverChemex
	case AeropressTraditional
	case AeropressInverted
	case Kone
	case Kalita

	static let allValues = [CoffeeMachine, PourOverV60, PourOverChemex, AeropressTraditional, AeropressInverted, Kone, Kalita]
}

extension BrewMethod: CustomStringConvertible {
	var description: String {
		switch self {
			case .CoffeeMachine, .Kone, .Kalita: return ""
			case .PourOverV60: return tr(.methodDetailV60)
			case .PourOverChemex: return tr(.methodDetailChemex)
			case .AeropressTraditional: return tr(.methodDetailTraditional)
			case .AeropressInverted: return tr(.methodDetailInverted)
		}
	}
}

extension BrewMethod {
	var categoryDescription: String {
		switch self {
			case .CoffeeMachine: return tr(.methodEsspressoMachine)
			case .PourOverV60: return tr(.methodPourOver)
			case .PourOverChemex: return tr(.methodPourOver)
			case .AeropressTraditional: return tr(.methodAeropress)
			case .AeropressInverted: return tr(.methodAeropress)
			case .Kone: return tr(.methodKone)
			case .Kalita: return tr(.methodKalita)
		}
	}
}

extension BrewMethod {
	var imageName: Asset {
		switch self {
			case .CoffeeMachine: return .Ic_coffee_machine
			case .PourOverV60: return .Ic_drip
			case .PourOverChemex: return .Ic_chemex
			case .AeropressTraditional: return .Ic_aeropress
			case .AeropressInverted: return .Ic_inverted
			case .Kone: return .Ic_kone
			case .Kalita: return .Ic_kalita
		}
	}
}

extension BrewMethod {
	var color: UIColor {
		switch self {
			case .CoffeeMachine: return .dullLavender()
			case .PourOverV60: return .deepBlush()
			case .PourOverChemex: return .rajah()
			case .AeropressTraditional: return .pearlAqua()
			case .AeropressInverted: return .lightSkyBlue()
			case .Kone: return .geraldine()
			case .Kalita: return .feijoa()
		}
	}

	var lightColor: UIColor {
		switch self {
			case .CoffeeMachine: return .moonRaker()
			case .PourOverV60: return .shocking()
			case .PourOverChemex: return .gold()
			case .AeropressTraditional: return .scandal()
			case .AeropressInverted: return .sail()
			case .Kone: return .sundown()
			case .Kalita: return .sprout()
		}
	}
}

extension BrewMethod {
	var intValue: Int32 {
		switch self {
			case .CoffeeMachine: return 0
			case .PourOverV60: return 1
			case .PourOverChemex: return 2
			case .AeropressTraditional: return 3
			case .AeropressInverted: return 4
			case .Kone: return 5
			case .Kalita: return 6
		}
	}

	static func fromIntValue(_ intValue: Int32) -> BrewMethod {
		switch intValue {
			case 0: return CoffeeMachine
			case 1: return PourOverV60
			case 2: return PourOverChemex
			case 3: return AeropressTraditional
			case 4: return AeropressInverted
			case 5: return Kone
			case 6: return Kalita
			default: fatalError("Wrong brew method int value!")
		}
	}
}

extension BrewMethod {

	static func fromQuickType(string: String) -> BrewMethod {
		switch string {
			case "pl.maciejoczko.Dropnote.traditional": return .AeropressTraditional
			case "pl.maciejoczko.Dropnote.inverted": return .AeropressInverted
			case "pl.maciejoczko.Dropnote.v60": return .PourOverV60
			case "pl.maciejoczko.Dropnote.chemex": return .PourOverChemex
			case "pl.maciejoczko.Dropnote.coffeemachine": return .CoffeeMachine
			case "pl.maciejoczko.Dropnote.kone": return .Kone
			case "pl.maciejoczko.Dropnote.kalita": return .Kalita
			default: fatalError("Wrong brew method quick type value!")
		}
	}
}

extension BrewMethod: TitleImagePresentable {
	var title: String {
		let ending = description.isEmpty ? "" : " " + description
		return categoryDescription + ending
	}

	var image: UIImage {
		return UIImage(asset: imageName)!
	}
}
