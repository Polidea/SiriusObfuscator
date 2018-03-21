//
//  NumericalInputTextField.swift
//  Brewer
//
//  Created by Maciej Oczko on 02.08.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class wxHukm_t7WumvSAVdwumaGLpCyQJHYIq: UITextField {

    override func canPerformAction(_ CYw5QceZpl33gMQzGMW_uViqhuzQdrt7: Selector, withSender Slt988KuygoQCfC3R9k3XpJ1juQDA0PU: Any?) -> Bool {
        if CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(cut)
            || CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(UIResponderStandardEditActions.paste(_:))
            || CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(UIResponderStandardEditActions.delete(_:))
            || CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight(_:))
            || CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft(_:))
            || CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(UIResponderStandardEditActions.toggleBoldface(_:))
            || CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(UIResponderStandardEditActions.toggleItalics(_:))
            || CYw5QceZpl33gMQzGMW_uViqhuzQdrt7 == #selector(UIResponderStandardEditActions.toggleUnderline(_:)) { return false }
        return true
    }
}
