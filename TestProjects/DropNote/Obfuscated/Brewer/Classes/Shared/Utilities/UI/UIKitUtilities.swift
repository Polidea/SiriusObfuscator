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
	static func sVUIRkaOqlZp5iw4WMoPa5ZL0EdavRqI(_ tKRfPeoViVZ1rQJ9C2alcOzn8MwFWNL_: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Book", size: tKRfPeoViVZ1rQJ9C2alcOzn8MwFWNL_)
	}

	static func nAKSPv5oPv0WgoS4wI6qMXEMhXwleAzo(_ XXLom_ufXGHLXm96M6OPf1EM4guzxVTI: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Medium", size: XXLom_ufXGHLXm96M6OPf1EM4guzxVTI)
	}
}

// MARK: Image

extension UIImage {

	func YFDX0emTPRUFA1PMfpdFLtlEg4NDHuAP() -> UIImage {
		return withRenderingMode(.alwaysOriginal)
	}
    
    func Fd6ountEV5HQmWFTsVYctbusRXYJFHKf(uz6oyRAx04_VpRl_Cnt04h_rUNk9xhZc KhsJFmqnfLut28S1vxeW8haAKMitIJjc: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: self.scale * KhsJFmqnfLut28S1vxeW8haAKMitIJjc, orientation: self.imageOrientation)
    }
}

// MARK: UITableView

extension UITableView {
    func pkMqfhs14ZykvoaSAmFqozI2WkSrDmJe(KAH9Mlld7G5agOfHakNQDOZE6xn5irso: Bool = false) {
		if let bar = self.tableHeaderView as? UISearchBar {
			let height = bar.frame.height
			let offset = contentOffset.y
			if offset < height {
                setContentOffset(CGPoint(x: 0, y: height), animated: KAH9Mlld7G5agOfHakNQDOZE6xn5irso)
			}
		}
	}
    
    func nHknR1aYTrFEYNaOs5TorCYQtgqdrKdL(qKpzevJcyJg1jX5I9kE66_wYhzMZYJM3: Bool = false) {
        if self.tableHeaderView as? UISearchBar != nil {
            if contentOffset.y != 0 {
                setContentOffset(CGPoint.zero, animated: qKpzevJcyJg1jX5I9kE66_wYhzMZYJM3)
            }
        }
    }
}

// MARK: UIScrollView

extension UIScrollView {
    
    func AAzr5VxsVYiClYxMmWCWn1KSoi1xgcKH(_ ETKevwrsf7lUHzYyrxZtfHMwM4vg_YOP: Int) {
        setContentOffset(CGPoint(x: CGFloat(ETKevwrsf7lUHzYyrxZtfHMwM4vg_YOP) * frame.width, y: 0), animated: true)
    }
}

// MARK: UIView

extension UIView {

	static func Xc696gLBRw2cNBlQxqn2uqvxLu22GZHc(_ iZOcCtOTAIOwB2pIfxqMd8h0SOnshNPA: UIColor?) -> UIView {
		let view = UIView()
		view.backgroundColor = iZOcCtOTAIOwB2pIfxqMd8h0SOnshNPA
		return view
	}
}
