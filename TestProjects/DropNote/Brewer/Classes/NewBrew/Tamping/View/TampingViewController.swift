//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension TampingViewController: Activable { }
extension TampingViewController: ThemeConfigurationContainer { }

final class TampingViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet var tampingView: TampingView!

    var active: Bool = false
    var themeConfiguration: ThemeConfiguration?
    var viewModel: TampingViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = BrewAttributeType.TampStrength.description
        tampingView.slider.rx.value.bindTo(viewModel.tampingValue).addDisposableTo(disposeBag)
        tampingView.informativeLabel.text = viewModel.informativeText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.configureWithTheme(themeConfiguration)
        tampingView.configureWithTheme(themeConfiguration)
    }
}
