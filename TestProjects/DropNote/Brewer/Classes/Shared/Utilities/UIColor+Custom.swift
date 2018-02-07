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

	static func romance() -> UIColor {
		return UIColor(red: 0.96, green: 0.949, blue: 0.913, alpha: 1)
	}

	static func flint() -> UIColor {
		return UIColor(red: 0.45, green: 0.392, blue: 0.368, alpha: 1)
	}

	static func lightSkyBlue() -> UIColor {
		return UIColor(red: 0.494, green: 0.831, blue: 1, alpha: 1)
	}

	static func spiroDiscoBall() -> UIColor {
		return UIColor(red: 0.152, green: 0.721, blue: 1, alpha: 1)
	}

	// MARK: Drip

	static func deepBlush() -> UIColor {
		return UIColor(red: 0.93, green: 0.44, blue: 0.61, alpha: 1.00)
	}

	static func shocking() -> UIColor {
		return UIColor(red: 0.91, green: 0.61, blue: 0.71, alpha: 1.00)
	}

	// MARK: Aeropress

	static func pearlAqua() -> UIColor {
		return UIColor(red: 0.53, green: 0.85, blue: 0.73, alpha: 1.00)
	}

	static func scandal() -> UIColor {
		return UIColor(red: 0.67, green: 0.86, blue: 0.79, alpha: 1.00)
	}

	// MARK: Aeropress Inverted

	static func sail() -> UIColor {
		return UIColor(red: 0.69, green: 0.89, blue: 0.98, alpha: 1.00)
	}

	// MARK: Coffee machine

	static func dullLavender() -> UIColor {
		return UIColor(red: 0.63, green: 0.56, blue: 0.87, alpha: 1.00)
	}

	static func moonRaker() -> UIColor {
		return UIColor(red: 0.73, green: 0.69, blue: 0.87, alpha: 1.00)
	}

	// MARK: Chemex

	static func rajah() -> UIColor {
		return UIColor(red: 0.97, green: 0.73, blue: 0.40, alpha: 1.00)
	}

	static func gold() -> UIColor {
		return UIColor(red: 0.93, green: 0.78, blue: 0.59, alpha: 1.00)
	}

	// MARK: Kalita

	static func feijoa() -> UIColor {
		return UIColor(hex: 0xB1DB83, alpha: 1.0)
	}

	static func sprout() -> UIColor {
		return UIColor(hex: 0xB1DB83, alpha: 0.4)
	}

	// MARK: Kone

	static func geraldine() -> UIColor {
		return UIColor(hex: 0xFF8585, alpha: 1.0)
	}

	static func sundown() -> UIColor {
		return UIColor(hex: 0xFF8585, alpha: 0.4)
	}
}

extension UIColor {
	convenience init(hex: Int, alpha: Double = 1.0) {
		self.init(red: CGFloat((hex >> 16) & 0xFF) / 255.0,
				  green: CGFloat((hex >> 8) & 0xFF) / 255.0,
				  blue: CGFloat((hex) & 0xFF) / 255.0,
				  alpha: CGFloat(255 * alpha) / 255)
	}
}
