//
//  UIColor+Custom.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

	static func qM_32D4VbHDlp_RmGVbAn4mCOyC0JuNv() -> UIColor {
		return UIColor(red: 0.96, green: 0.949, blue: 0.913, alpha: 1)
	}

	static func hQzMlTTRF2G3qIoihSDNByH6SLYyUZd_() -> UIColor {
		return UIColor(red: 0.45, green: 0.392, blue: 0.368, alpha: 1)
	}

	static func vkc1bEVSuuhWlXXU0fLB5n65ipFnUnFa() -> UIColor {
		return UIColor(red: 0.494, green: 0.831, blue: 1, alpha: 1)
	}

	static func Er78Udr7PWkfQQdisTq2BNeDlmOMTqHo() -> UIColor {
		return UIColor(red: 0.152, green: 0.721, blue: 1, alpha: 1)
	}

	// MARK: Drip

	static func Clh79OuM5sbnGA4NkvbY8iHtvGeOioJt() -> UIColor {
		return UIColor(red: 0.93, green: 0.44, blue: 0.61, alpha: 1.00)
	}

	static func gTbjk_0Q5hdGFrlsyihSZwZTIs0OS62p() -> UIColor {
		return UIColor(red: 0.91, green: 0.61, blue: 0.71, alpha: 1.00)
	}

	// MARK: Aeropress

	static func tGvJOl6yaRGxuasa4bXZKAqwEPiERbW1() -> UIColor {
		return UIColor(red: 0.53, green: 0.85, blue: 0.73, alpha: 1.00)
	}

	static func CGxEB2YDv42XnMMhFCc0_JGYwOYfI30Y() -> UIColor {
		return UIColor(red: 0.67, green: 0.86, blue: 0.79, alpha: 1.00)
	}

	// MARK: Aeropress Inverted

	static func ctUGpD43tBtdoE9H0AQwAT097fK9BgI9() -> UIColor {
		return UIColor(red: 0.69, green: 0.89, blue: 0.98, alpha: 1.00)
	}

	// MARK: Coffee machine

	static func U2gelaZzNddK2gQ91AYjc19W3nNUylWt() -> UIColor {
		return UIColor(red: 0.63, green: 0.56, blue: 0.87, alpha: 1.00)
	}

	static func DregrEo3oZIvBTo6Ojx7wLIqEWmL6wPp() -> UIColor {
		return UIColor(red: 0.73, green: 0.69, blue: 0.87, alpha: 1.00)
	}

	// MARK: Chemex

	static func oA37LPwrfatLLO80gvN6IfMmBn1kaUrx() -> UIColor {
		return UIColor(red: 0.97, green: 0.73, blue: 0.40, alpha: 1.00)
	}

	static func Rp_D7uyOrClKUPA_le58miX0SVqOQzpm() -> UIColor {
		return UIColor(red: 0.93, green: 0.78, blue: 0.59, alpha: 1.00)
	}

	// MARK: Kalita

	static func y3PAXJCi8Fa1xgDsB6TyIPZSkodn7vPL() -> UIColor {
		return UIColor(MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct: 0xB1DB83, nO7GGQniDgmG7skVkRrPbhuJunLKuZuA: 1.0)
	}

	static func BRXATgdYIKnFNTBKr7eiHhRRmzWKtW1q() -> UIColor {
		return UIColor(MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct: 0xB1DB83, nO7GGQniDgmG7skVkRrPbhuJunLKuZuA: 0.4)
	}

	// MARK: Kone

	static func oMiYNU3ZheFkEbTG411FBl9ExaxlFTTp() -> UIColor {
		return UIColor(MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct: 0xFF8585, nO7GGQniDgmG7skVkRrPbhuJunLKuZuA: 1.0)
	}

	static func OO2Z8oyl1h5zfKiZ5Q_K925n4yrEZBFE() -> UIColor {
		return UIColor(MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct: 0xFF8585, nO7GGQniDgmG7skVkRrPbhuJunLKuZuA: 0.4)
	}
}

extension UIColor {
	convenience init(MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct: Int, nO7GGQniDgmG7skVkRrPbhuJunLKuZuA: Double = 1.0) {
		self.init(red: CGFloat((MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct >> 16) & 0xFF) / 255.0,
				  green: CGFloat((MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct >> 8) & 0xFF) / 255.0,
				  blue: CGFloat((MVbLtAiyYJCu4Fv7NvK4iC9fb3205Rct) & 0xFF) / 255.0,
				  alpha: CGFloat(255 * nO7GGQniDgmG7skVkRrPbhuJunLKuZuA) / 255)
	}
}
