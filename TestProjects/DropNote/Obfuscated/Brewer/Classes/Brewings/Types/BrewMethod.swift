//
// Created by Maciej Oczko on 24.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

enum f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei: String {
	case CoffeeMachine
	case PourOverV60
	case PourOverChemex
	case AeropressTraditional
	case AeropressInverted
	case Kone
	case Kalita

	static let BCQa6GBI9riueUhRomQvw9J87CxgJ1U7 = [CoffeeMachine, PourOverV60, PourOverChemex, AeropressTraditional, AeropressInverted, Kone, Kalita]
}

extension f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei: CustomStringConvertible {
	var description: String {
		switch self {
			case .CoffeeMachine, .Kone, .Kalita: return ""
			case .PourOverV60: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodDetailV60)
			case .PourOverChemex: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodDetailChemex)
			case .AeropressTraditional: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodDetailTraditional)
			case .AeropressInverted: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodDetailInverted)
		}
	}
}

extension f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei {
	var categoryDescription: String {
		switch self {
			case .CoffeeMachine: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodEsspressoMachine)
			case .PourOverV60: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodPourOver)
			case .PourOverChemex: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodPourOver)
			case .AeropressTraditional: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodAeropress)
			case .AeropressInverted: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodAeropress)
			case .Kone: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodKone)
			case .Kalita: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.methodKalita)
		}
	}
}

extension f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei {
	var imageName: OGOzFMuArW5wB3CRvXLnAhL8W25uEJb8 {
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

extension f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei {
	var color: UIColor {
		switch self {
			case .CoffeeMachine: return .U2gelaZzNddK2gQ91AYjc19W3nNUylWt()
			case .PourOverV60: return .Clh79OuM5sbnGA4NkvbY8iHtvGeOioJt()
			case .PourOverChemex: return .oA37LPwrfatLLO80gvN6IfMmBn1kaUrx()
			case .AeropressTraditional: return .tGvJOl6yaRGxuasa4bXZKAqwEPiERbW1()
			case .AeropressInverted: return .vkc1bEVSuuhWlXXU0fLB5n65ipFnUnFa()
			case .Kone: return .oMiYNU3ZheFkEbTG411FBl9ExaxlFTTp()
			case .Kalita: return .y3PAXJCi8Fa1xgDsB6TyIPZSkodn7vPL()
		}
	}

	var lightColor: UIColor {
		switch self {
			case .CoffeeMachine: return .DregrEo3oZIvBTo6Ojx7wLIqEWmL6wPp()
			case .PourOverV60: return .gTbjk_0Q5hdGFrlsyihSZwZTIs0OS62p()
			case .PourOverChemex: return .Rp_D7uyOrClKUPA_le58miX0SVqOQzpm()
			case .AeropressTraditional: return .CGxEB2YDv42XnMMhFCc0_JGYwOYfI30Y()
			case .AeropressInverted: return .ctUGpD43tBtdoE9H0AQwAT097fK9BgI9()
			case .Kone: return .OO2Z8oyl1h5zfKiZ5Q_K925n4yrEZBFE()
			case .Kalita: return .BRXATgdYIKnFNTBKr7eiHhRRmzWKtW1q()
		}
	}
}

extension f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei {
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

	static func KhEJlVo1FtyIwpn7T6Q7LU8I8n58vlU1(_ KgLPie27c5kYdftbdzQjhKcjahOFkzgS: Int32) -> f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei {
		switch KgLPie27c5kYdftbdzQjhKcjahOFkzgS {
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

extension f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei {

	static func HKQlLt20MvOLduhD5uNOlB9QBCP_iSXU(CSizrjyGzxpehwdNxXpVG2hJwysrjfgK: String) -> f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei {
		switch CSizrjyGzxpehwdNxXpVG2hJwysrjfgK {
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

extension f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei: TitleImagePresentable {
	var Y63ZuCG3WSaNj7iJlDXbFxT7w1d9NF6Y: String {
		let ending = description.isEmpty ? "" : " " + description
		return categoryDescription + ending
	}

	var DiLICwQpRlxkW0RYaBrOoK3OiApF0nt2: UIImage {
		return UIImage(s1ZNd5QU2H_UUnNcHh0fKsU72v0RAfQH: imageName)!
	}
}
