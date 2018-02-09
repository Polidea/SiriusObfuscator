//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension SelectableSearchViewController: Activable { }
extension SelectableSearchViewController: ThemeConfigurationContainer { }

final class SelectableSearchViewController: UIViewController {
	fileprivate let disposeBag = DisposeBag()

	var themeConfiguration: ThemeConfiguration?

    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            inputTextField.accessibilityLabel = "Type"
        }
    }
	@IBOutlet weak var tableView: UITableView!
	var viewModel: SelectableSearchViewModelType!

	var active: Bool = false {
		didSet {
			if var responder = inputTextField {
				responder.active = active
			}
            if let inputTextField = inputTextField , !active {
                viewModel.addNewSearchItemIfNeeded(inputTextField.text)
            }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		inputTextField.placeholder = viewModel.placeholder
		tableView.delegate = self
		tableView.tableFooterView = UIView()
		viewModel.configureWithTableView(tableView)
		inputTextField
            .rx.text
            .asDriver()
            .distinctUntilChanged(==)
            .skip(1)
            .drive(onNext: viewModel.setSearchString)
            .disposed(by: disposeBag)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.configureWithTheme(themeConfiguration)
		tableView.configureWithTheme(themeConfiguration)
		inputTextField.configureWithTheme(themeConfiguration)
	}
}

extension SelectableSearchViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
		cell.configureWithTheme(themeConfiguration)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.selectItemAtIndexPath(indexPath)
		inputTextField.text = nil
	}
}
