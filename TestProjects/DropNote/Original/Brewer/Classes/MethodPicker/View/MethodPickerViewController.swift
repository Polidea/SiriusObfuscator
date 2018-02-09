//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension MethodPickerViewController: ThemeConfigurationContainer { }

final class MethodPickerViewController: UIViewController, ThemeConfigurable {
    
	@IBOutlet weak var tableView: UITableView!

	var themeConfiguration: ThemeConfiguration?
	var viewModel: MethodPickerViewModelType!
	let didSelectBrewMethodSubject = PublishSubject<BrewMethod>()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = tr(.methodPickItemTitle)
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        		
		tableView.tableFooterView = UIView()
		tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
		viewModel.configureWithTableView(tableView)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
		tableView.configureWithTheme(themeConfiguration)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if case .SequenceSettings = segueIdentifierForSegue(segue) {
			if let viewController = segue.destination as? SequenceSettingsViewController {
				viewController.brewMethod = BrewMethod(rawValue: sender as! String)!
			}
		}
	}
}

extension MethodPickerViewController: TabBarConfigurable {
    
    func setupTabBar() {
        guard let navigationController = navigationController else { return }
        navigationController.tabBarItem = UITabBarItem(title: tr(.methodPickItemTitle),
                                                       image: UIImage(asset: .Ic_tab_start)?.alwaysOriginal(),
                                                       selectedImage: UIImage(asset: .Ic_tab_start_pressed)?.alwaysOriginal())
        guard let themeConfiguration = themeConfiguration else { return }
        configureTabBarItem(navigationController.tabBarItem, theme: themeConfiguration)
    }
}

extension MethodPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }
    
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MethodPickerCell)?.configureWithTheme(themeConfiguration)
	}
    
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		didSelectBrewMethodSubject.onNext(viewModel.methodForIndexPath(indexPath))
	}
}
