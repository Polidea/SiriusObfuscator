import Foundation
import UIKit

protocol ListDataSource {
    associatedtype ListView
    associatedtype Cell
    associatedtype Object
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String
    func listView(_ listView: ListView, configureCell cell: Cell, withObject object: Object, atIndexPath indexPath: IndexPath)
}

// --

protocol NonFetchedListDataSource: ListDataSource {
    var listItems: [[Object]] { get }
}

extension NonFetchedListDataSource {
    var numberOfSections: Int {
        return listItems.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return listItems[section].count
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object? {
        guard isValidIndexPath(indexPath) else {
            return nil
        }
        return listItems[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
    }
    
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        guard (indexPath as NSIndexPath).section >= 0 && (indexPath as NSIndexPath).section < listItems.count else {
            return false
        }
        return (indexPath as NSIndexPath).row >= 0 && (indexPath as NSIndexPath).row < listItems[(indexPath as NSIndexPath).section].count
    }
}

// --

protocol TableListDataSource: NonFetchedListDataSource { }

extension TableListDataSource where ListView == UITableView {
    
    func tableCellAtIndexPath(_ tableView: UITableView, indexPath: IndexPath) -> Cell {
        let identifier = cellIdentifierForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        
        if let object = objectAtIndexPath(indexPath) {
            listView(tableView, configureCell: cell, withObject: object, atIndexPath: indexPath)
        }
        
        return cell
    }
}

// --

final class TableViewSourceWrapper<T>: NSObject, UITableViewDataSource where T: AnyObject, T: TableListDataSource, T.ListView == UITableView {
    unowned let tableDataSource: T
    
    init(tableDataSource: T) {
        self.tableDataSource = tableDataSource
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataSource.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableDataSource.tableCellAtIndexPath(tableView, indexPath: indexPath) as! UITableViewCell
    }
}

protocol TableViewConfigurable {
    func configureWithTableView(_ tableView: UITableView)
}
