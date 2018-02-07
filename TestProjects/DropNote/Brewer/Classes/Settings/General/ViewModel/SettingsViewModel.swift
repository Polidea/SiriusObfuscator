//
// Created by Maciej Oczko on 21.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

struct SettingsItem: TitlePresentable {
    let title: String
}

final class SettingsViewModel {
    
    var listItems = [[
            SettingsItem(title: tr(.settingsBrewingSequenceMenuItemTitle)),
            SettingsItem(title: tr(.settingsUnitsMenuItemTitle)),
            SettingsItem(title: tr(.settingsAboutMenuItemTitle)),
            SettingsItem(title: tr(.settingsFeedbackMenuItemTitle)),
            SettingsItem(title: tr(.settingsRateMenuItemTitle)),
    ]]
    
    lazy var dataSource: TableViewSourceWrapper<SettingsViewModel> = TableViewSourceWrapper(tableDataSource: self)
}

extension SettingsViewModel: TableViewConfigurable {
    
    func configureWithTableView(_ tableView: UITableView) {
        tableView.dataSource = dataSource
    }
}

extension SettingsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return "SettingsCell"
    }
    
    func listView(_ listView: UITableView, configureCell cell: SettingsCell, withObject object: SettingsItem, atIndexPath indexPath: IndexPath) {
        cell.configureWithPresentable(object)
    }
}
