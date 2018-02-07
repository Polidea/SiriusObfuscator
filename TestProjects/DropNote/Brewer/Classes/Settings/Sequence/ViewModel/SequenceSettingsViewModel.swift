//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SequenceSettingsViewModelType: UITableViewDataSource, TableViewConfigurable {
    var brewMethod: BrewMethod! { get set }

    func prepareEditForTableView(_ tableView: UITableView, completion: @escaping (_ editing: Bool) -> Void)

    func shouldSelectItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    func markIndexPath(_ indexPath: IndexPath, asSelected selected: Bool)
}

final class SequenceSettingsViewModel: NSObject, SequenceSettingsViewModelType {
    fileprivate let disposeBag = DisposeBag()
    private var dispatchHandler = Dispatcher.delay

    let modelController: SequenceSettingsModelControllerType
    var brewMethod: BrewMethod! {
        didSet {
            populateSections()
        }
    }

    fileprivate(set) var items: [BrewingSequenceStep] = []
    fileprivate(set) var editing = false

    fileprivate var activeItems: [BrewingSequenceStep] {
        return editing ? items : items.filter {
            $0.enabled!
        }
    }

    init(modelController: SequenceSettingsModelControllerType) {
        self.modelController = modelController
        super.init()
    }

    fileprivate func populateSections() {
        self.items = modelController.sequenceSteps(for: brewMethod, filter: .all)
    }

    func configureWithTableView(_ tableView: UITableView) {
        tableView.dataSource = self
    }

    func prepareEditForTableView(_ tableView: UITableView, completion: @escaping (_ editing: Bool) -> Void) {
        editing = !editing
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        dispatchHandler(0.25) {
            completion(self.editing)
        }
        if !editing {
            modelController.saveSequenceSteps(for: brewMethod, sequenceSteps: items)
        }
    }

    // MARK: Selection

    func shouldSelectItemAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return items[(indexPath as NSIndexPath).row].enabled!
    }

    func markIndexPath(_ indexPath: IndexPath, asSelected selected: Bool) {
        items[(indexPath as NSIndexPath).row].setEnabled(selected)
    }
}

extension SequenceSettingsViewModel: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = activeItems[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SequenceSettingsCell", for: indexPath) as UITableViewCell
        cell.accessibilityHint = "Represents \(item.type!.description)"
        cell.textLabel?.text = item.type!.description
        cell.isSelected = item.enabled!
        return cell
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var item = items[(sourceIndexPath as NSIndexPath).row]
        item.setPosition((destinationIndexPath as NSIndexPath).row)
        items.remove(at: (sourceIndexPath as NSIndexPath).row)
        items.insert(item, at: (destinationIndexPath as NSIndexPath).row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
