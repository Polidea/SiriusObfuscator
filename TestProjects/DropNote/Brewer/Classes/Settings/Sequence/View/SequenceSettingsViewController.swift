//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension SequenceSettingsViewController: ThemeConfigurable { }
extension SequenceSettingsViewController: ThemeConfigurationContainer { }

final class SequenceSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!

    var themeConfiguration: ThemeConfiguration?
    var viewModel: SequenceSettingsViewModelType!

    var brewMethod: BrewMethod! {
        didSet {
            viewModel.brewMethod = brewMethod
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.sequenceItemTitle)
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        viewModel.configureWithTableView(tableView)
        
        enableSwipeToBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        editAction(editBarButtonItem)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settingsSequence)
    }
    
    @IBAction func editAction(_ barButtonItem: UIBarButtonItem) {
        if barButtonItem.title == tr(.navigationDone) {
            Dispatcher.delay(0.6) {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        barButtonItem.title = !tableView.isEditing ? tr(.navigationDone) : tr(.navigationEdit)
        viewModel.prepareEditForTableView(tableView) {
            editing in
            self.tableView.setEditing(editing, animated: true)
            self.selectRowsForTableViewIfNeeded()
        }
    }

    fileprivate func selectRowsForTableViewIfNeeded() {
        guard tableView.isEditing else { return }
        let selectRow = {
            self.tableView.selectRow(at: $0, animated: true, scrollPosition: .none)
        }
        tableView
            .indexPathsForVisibleRows?
            .filter(viewModel.shouldSelectItemAtIndexPath)
            .forEach(selectRow)
    }
}

extension SequenceSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.markIndexPath(indexPath, asSelected: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.markIndexPath(indexPath, asSelected: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        (cell as? SequenceSettingsCell)?.configureWithTheme(themeConfiguration)
    }
}
