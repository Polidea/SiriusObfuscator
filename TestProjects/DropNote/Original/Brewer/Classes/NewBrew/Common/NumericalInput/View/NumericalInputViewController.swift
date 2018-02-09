//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension NumericalInputViewController: ThemeConfigurationContainer { }
extension NumericalInputViewController: Activable { }

final class NumericalInputViewController: UIViewController {
    @IBOutlet weak var inputTextField: NumericalInputTextField! {
        didSet {
            inputTextField.accessibilityLabel = "Type"
            inputTextField.delegate = self
            inputTextField.tintColor = UIColor.clear
        }
    }
    @IBOutlet weak var informativeLabel: InformativeLabel!

    var viewModel: NumericalInputViewModelType!

    var active: Bool = false {
        didSet {
            if var responder = inputTextField {
                responder.active = active
            }
        }
    }
    
    var themeConfiguration: ThemeConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()
        informativeLabel.text = viewModel.informativeText
        inputTextField.text = viewModel.inputTransformer.initialString() + viewModel.unit
        if let currentValue = viewModel.currentValue {
            inputTextField.text = currentValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.configureWithTheme(themeConfiguration)
        inputTextField.configureWithTheme(themeConfiguration)
        informativeLabel.configureWithTheme(themeConfiguration)
    }
}

extension NumericalInputViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count <= 1 else {
            return false
        }
        let textValue = viewModel.inputTransformer.transform(withRange: range, replacementString: string)
        textField.text = textValue + viewModel.unit
        viewModel.setInputValue(textValue)
        return false
    }
}
