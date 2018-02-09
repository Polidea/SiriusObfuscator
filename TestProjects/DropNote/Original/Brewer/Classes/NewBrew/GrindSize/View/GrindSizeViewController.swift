//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension GrindSizeViewController: Activable { }
extension GrindSizeViewController: ThemeConfigurationContainer { }

final class GrindSizeViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var informativeLabel: InformativeLabel!
    @IBOutlet weak var sliderContainerView: GrindSizeSliderContainerView!    
    @IBOutlet weak var numericValueTextField: UITextField! {
        didSet {
            numericValueTextField.delegate = self
            numericValueTextField.tintColor = UIColor.clear
        }
    }
    @IBOutlet weak var switchButton: UIButton! {
        didSet {
            setButtonTitle(switchButton)
        }
    }
    
    var active: Bool = false {
        didSet {
            guard let responder = numericValueTextField else { return }
            guard let viewModel = viewModel else { return }
            if !viewModel.isSliderVisible && active {
                responder.becomeFirstResponder()
            }
        }
    }
    
    var themeConfiguration: ThemeConfiguration?    
    var viewModel: GringSizeViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = BrewAttributeType.GrindSize.description
        informativeLabel.text = viewModel.informativeText
        
        sliderContainerView.slider.isContinuous = false
        numericValueTextField.text = viewModel.inputTransformer.initialString()
        
        sliderContainerView.isHidden = !viewModel.isSliderVisible
        numericValueTextField.isHidden = viewModel.isSliderVisible
        
        sliderContainerView.slider.rx.value.bind(to: viewModel.sliderValue).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.configureWithTheme(themeConfiguration)
        informativeLabel.configureWithTheme(themeConfiguration)
        sliderContainerView.configureWithTheme(themeConfiguration)
        numericValueTextField.configureWithTheme(themeConfiguration)
        showKeyboardIfNeeded()
    }
    
    @IBAction func switchInputRepresentation(_ sender: UIButton) {        
        numericValueTextField.isHidden = !numericValueTextField.isHidden
        sliderContainerView.isHidden = !sliderContainerView.isHidden
        viewModel.isSliderVisible = !sliderContainerView.isHidden
        setButtonTitle(sender)
        showKeyboardIfNeeded()
    }
    
    fileprivate func showKeyboardIfNeeded() {
        if viewModel.isSliderVisible {
            numericValueTextField.resignFirstResponder()
        } else {
            numericValueTextField.becomeFirstResponder()
        }
    }
    
    fileprivate func setButtonTitle(_ button: UIButton) {
        let buttonTitle = !viewModel.isSliderVisible
            ? tr(.grindSizeSliderButtonTitle)
            : tr(.grindSizeNumericButtonTitle)
        button.setTitle(buttonTitle, for: UIControlState())
    }
}

extension GrindSizeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count <= 1 else {
            return false
        }
        let textValue = viewModel.inputTransformer.transform(withRange: range, replacementString: string)
        textField.text = textValue
        viewModel.numericValue.value = textValue
        return false
    }
}
