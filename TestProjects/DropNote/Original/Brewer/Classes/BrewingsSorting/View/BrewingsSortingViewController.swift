//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension BrewingsSortingViewController: ThemeConfigurable { }
extension BrewingsSortingViewController: ThemeConfigurationContainer { }

final class BrewingsSortingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var themeConfiguration: ThemeConfiguration?
    var viewModel: BrewingsSortingViewModelType!

    let dismissViewControllerAnimatedSubject = PublishSubject<Bool>()
    let switchSortingOptionSubject = PublishSubject<BrewingSortingOption>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.brewingsSortingSortTitle)
        
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        viewModel.configureWithTableView(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.brewingSort)
    }

    @IBAction func close(_ sender: AnyObject) {
        dismissViewControllerAnimatedSubject.onNext(true)
    }
}

extension BrewingsSortingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        (cell as? BrewingsSortingOptionCell)?.configureWithTheme(themeConfiguration)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        viewModel.selectSortingOptionAtIndexPath(indexPath)
        for cell in tableView.visibleCells {
            if cell == currentCell {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }

        _ = MainScheduler
            .asyncInstance
            .scheduleRelative(viewModel.sortingOption, dueTime: 0.2) {
                [weak self] sortingOption in
                guard let `self` = self else { return Disposables.create() }
                self.switchSortingOptionSubject.onNext(sortingOption)
                self.dismissViewControllerAnimatedSubject.onNext(true)
                return BooleanDisposable(isDisposed: true)
        }
    }
}
