//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol MethodPickerViewModelType: TableViewConfigurable {
    func methodForIndexPath(_ indexPath: IndexPath) -> BrewMethod
}

final class MethodPickerViewModel: MethodPickerViewModelType {
    var listItems = [
        BrewMethod.allValues.map { $0 as TitleImagePresentable }
    ]
    
    lazy var dataSource: TableViewSourceWrapper<MethodPickerViewModel> = {
        return TableViewSourceWrapper(tableDataSource: self)
    }()
   
    func methodForIndexPath(_ indexPath: IndexPath) -> BrewMethod {
        return objectAtIndexPath(indexPath) as! BrewMethod
    }
}

extension MethodPickerViewModel: TableViewConfigurable {
    
    func configureWithTableView(_ tableView: UITableView) {
        tableView.dataSource = dataSource
    }
}

extension MethodPickerViewModel: TableListDataSource {

    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return "MethodPickerCell"
    }
    
    func listView(_ listView: UITableView, configureCell cell: MethodPickerCell, withObject object: TitleImagePresentable, atIndexPath indexPath: IndexPath) {
        cell.configureWithPresentable(object)
    }
}
