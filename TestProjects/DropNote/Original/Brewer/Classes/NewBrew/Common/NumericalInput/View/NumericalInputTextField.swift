//
//  NumericalInputTextField.swift
//  Brewer
//
//  Created by Maciej Oczko on 02.08.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NumericalInputTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(cut)
            || action == #selector(UIResponderStandardEditActions.paste(_:))
            || action == #selector(UIResponderStandardEditActions.delete(_:))
            || action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight(_:))
            || action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft(_:))
            || action == #selector(UIResponderStandardEditActions.toggleBoldface(_:))
            || action == #selector(UIResponderStandardEditActions.toggleItalics(_:))
            || action == #selector(UIResponderStandardEditActions.toggleUnderline(_:)) { return false }
        return true
    }
}
