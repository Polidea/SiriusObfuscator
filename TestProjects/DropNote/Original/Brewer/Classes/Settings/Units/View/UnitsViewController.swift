//
//  UnitsViewController.swift
//  Brewer
//
//  Created by Maciej Oczko on 10.02.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UnitsViewController: ThemeConfigurable { }
extension UnitsViewController: ThemeConfigurationContainer { }

final class UnitsViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var themeConfiguration: ThemeConfiguration?
    var viewModel: UnitsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.unitsItemTitle)
        
        setUpSegementedControlTitles()
        setDataSourceAtIndex(0)
        setUpSwitchingDataSources()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        viewModel.configureWithTableView(tableView)
        
        enableSwipeToBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        unitsSegmentedControl.configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settingsUnits)
    }

    // MARK: Configuration

    fileprivate func setUpSegementedControlTitles() {
        viewModel.titles.enumerated().map {
            index, title in (title, index)
        }.forEach(unitsSegmentedControl.setTitle(_:forSegmentAt:))
        
        unitsSegmentedControl.accessibilityHint = "Chooses between units categories " + viewModel.titles.joined(separator: ",")
    }

    // MARK: Data source switching

    fileprivate func setUpSwitchingDataSources() {
        unitsSegmentedControl
            .rx.value
            .asDriver()
            .drive(onNext: setDataSourceAtIndex)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setDataSourceAtIndex(_ index: Int) {
        viewModel.setDataSourceAtIndex(index)
        tableView.reloadData()
    }
}

extension UnitsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectUnitAtIndex((indexPath as NSIndexPath).row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        cell.configureWithTheme(themeConfiguration)
        cell.textLabel?.configureWithTheme(themeConfiguration)
        cell.detailTextLabel?.configureWithTheme(themeConfiguration)        
    }
}
