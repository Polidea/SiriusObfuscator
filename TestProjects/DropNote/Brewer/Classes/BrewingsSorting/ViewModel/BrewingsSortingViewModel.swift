//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol BrewingsSortingViewModelType: TableViewConfigurable {
    var sortingOption: BrewingSortingOption { get set }
    func selectSortingOptionAtIndexPath(_ indexPath: IndexPath)
}

extension BrewingSortingOption: TitleImagePresentable {
    var title: String {
        switch self {
            case .dateAscending: return tr(.brewingsSortingDateAscending)
            case .dateDescending: return tr(.brewingsSortingDateDescending)
            case .scoreAscending: return tr(.brewingsSortingScoreAscending)
            case .scoreDescending: return tr(.brewingsSortingScoreDescending)
        }
    }

    var image: UIImage {
        switch self {
            case .dateAscending: return UIImage(asset: .Ic_oldest)
            case .dateDescending: return UIImage(asset: .Ic_newest)
            case .scoreAscending: return UIImage(asset: .Ic_worst)
            case .scoreDescending: return UIImage(asset: .Ic_best)
        }
    }
}

final class BrewingsSortingViewModel: BrewingsSortingViewModelType {
    var sortingOption: BrewingSortingOption = .dateDescending
    lazy var dataSource: TableViewSourceWrapper<BrewingsSortingViewModel> = TableViewSourceWrapper(tableDataSource: self)
    
    var listItems: [[BrewingSortingOption]] {
        return [BrewingSortingOption.allValues]
    }

    func configureWithTableView(_ tableView: UITableView) {
        tableView.dataSource = dataSource
    }
    
    func selectSortingOptionAtIndexPath(_ indexPath: IndexPath) {
        sortingOption = listItems[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
    }
}

extension BrewingsSortingViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return "BrewingsSortingOptionCell"
    }
    
    func listView(_ listView: UITableView, configureCell cell: BrewingsSortingOptionCell,
                  withObject object: BrewingSortingOption, atIndexPath indexPath: IndexPath) {
        cell.configureWithPresentable(object)
        if object == self.sortingOption {
            cell.accessoryType = .checkmark
        }
    }
}
