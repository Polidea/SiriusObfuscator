//
// Created by Maciej Oczko on 07.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol Activable {
    var active: Bool { get set }
    
    func deactivate()
}

extension Activable {
    
    func deactivate() {
        var mutableSelf = self
        mutableSelf.active = false
    }
}

extension Activable {
    
    func handleActiveValue(_ active: Bool) {
        if let responder = self as? UIResponder {
            if active {
                responder.becomeFirstResponder()
            } else {
                responder.resignFirstResponder()
            }
        }
    }
}

extension UITextField: Activable { }
extension Activable where Self: UITextField {
    var active: Bool {
        get {
            return isFirstResponder
        }
        set(activeValue) {
            handleActiveValue(activeValue)
        }
    }
}

extension UISearchBar: Activable { }
extension Activable where Self: UISearchBar {
    var active: Bool {
        get {
            return isFirstResponder
        }
        set(activeValue) {
            handleActiveValue(activeValue)
        }
    }
}

extension UITextView: Activable { }
extension Activable where Self: UITextView {
    var active: Bool {
        get {
            return isFirstResponder
        }
        set(activeValue) {
            handleActiveValue(activeValue)
        }
    }
}
