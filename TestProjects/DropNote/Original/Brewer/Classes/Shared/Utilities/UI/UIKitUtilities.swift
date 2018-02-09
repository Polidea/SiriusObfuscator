//
//  UIKitUtilities.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

// MARK: Font

extension UIFont {
	static func avenirBook(_ size: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Book", size: size)
	}

	static func avenirMedium(_ size: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Medium", size: size)
	}
}

// MARK: Image

extension UIImage {

	func alwaysOriginal() -> UIImage {
		return withRenderingMode(.alwaysOriginal)
	}
    
    func scaled(by scale: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: self.scale * scale, orientation: self.imageOrientation)
    }
}

// MARK: UITableView

extension UITableView {
    func hideSearchBar(animated: Bool = false) {
		if let bar = self.tableHeaderView as? UISearchBar {
			let height = bar.frame.height
			let offset = contentOffset.y
			if offset < height {
                setContentOffset(CGPoint(x: 0, y: height), animated: animated)
			}
		}
	}
    
    func showSearchBar(animated: Bool = false) {
        if self.tableHeaderView as? UISearchBar != nil {
            if contentOffset.y != 0 {
                setContentOffset(CGPoint.zero, animated: animated)
            }
        }
    }
}

// MARK: UIScrollView

extension UIScrollView {
    
    func scrollVerticallyToPageAtIndex(_ index: Int) {
        setContentOffset(CGPoint(x: CGFloat(index) * frame.width, y: 0), animated: true)
    }
}

// MARK: UIView

extension UIView {

	static func viewWithBackgroundColor(_ color: UIColor?) -> UIView {
		let view = UIView()
		view.backgroundColor = color
		return view
	}
}
