//
//  UIViewControllerExtensions.swift
//  Brewer
//
//  Created by Maciej Oczko on 20.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {    
    @objc func mEuVr75hmI6GzzrmZHCAphTgG0thynQF() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    
    func WllwXJ6vzzp4gK1Z7FlRyWqrv3rfaQTm() {
        if let navigationController = navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    public func gestureRecognizerShouldBegin(_ EiRCJeuEcyUDLYjikXcpYsIQEp8tSGlv: UIGestureRecognizer) -> Bool {
        return true
    }
}
