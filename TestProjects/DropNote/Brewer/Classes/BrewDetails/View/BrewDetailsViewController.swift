//
//  BrewDetailsViewController.swift
//  Brewer
//
//  Created by Maciej Oczko on 09.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject

extension BrewDetailsViewController: ThemeConfigurable { }
extension BrewDetailsViewController: ThemeConfigurationContainer { }
extension BrewDetailsViewController: ResolvableContainer { }

final class BrewDetailsViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

	var resolver: ResolverType?
	var themeConfiguration: ThemeConfiguration?
	var viewModel: BrewDetailsViewModelType!

    fileprivate weak var pushedViewController: UIViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.brewDetailsItemTitle)
		
		tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
		tableView.delegate = self
		viewModel.configureWithTableView(tableView)

        enableSwipeToBack()
        navigationController?.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        deactivatePushedViewController()
        
        configureWithTheme(themeConfiguration)
		tableView.configureWithTheme(themeConfiguration)
		viewModel.refreshData()

        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.brewDetails)
	}
    
	override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveBrewIfNeeded()
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let resolver = resolver else { return }

		switch segueIdentifierForSegue(segue) {
		case .BrewScoreDetails:
			let viewController = segue.destination as! BrewScoreDetailsViewController
			viewController.viewModel = resolver.resolve(BrewScoreDetailsViewModelType.self,
														argument: viewModel.currentBrew())!
			break
		case .GrindSize:
			let viewController = segue.destination as! GrindSizeViewController
			viewController.viewModel = resolver.resolve(GringSizeViewModelType.self,
														argument: viewModel.brewModelController)!
			break
		case .NumericalInput:
			guard let box = sender as? Box<BrewAttributeType> else {
				fatalError("Couldn't unbox necessary context.")
			}
			let viewController = segue.destination as! NumericalInputViewController
			viewController.title = box.value.description
			viewController.viewModel = resolver.resolve(NumericalInputViewModelType.self,
														arguments: box.value, viewModel.brewModelController)!
			break
		case .Tamping:
			let viewController = segue.destination as! TampingViewController
			viewController.viewModel = resolver.resolve(TampingViewModelType.self,
														argument: viewModel.brewModelController)!
			break
		case .Notes:
			let viewController = segue.destination as! NotesViewController
			viewController.viewModel = resolver.resolve(NotesViewModelType.self,
														argument: viewModel.brewModelController)!
			break
		case .SelectableSearch:
			guard let box = sender as? Box<SelectableSearchIdentifier> else {
				fatalError("Couldn't unbox necessary context.")
			}
			let viewController = segue.destination as! SelectableSearchViewController
			viewController.viewModel = resolver.resolve(SelectableSearchViewModelType.self,
														arguments: box.value, viewModel.brewModelController)!
			viewController.title = box.value.description
			break
		default:
			fatalError("Unknown segue performed.")
		}

        segue.destination.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(asset: .Ic_back),
            style: .plain,
            target: self,
            action: #selector(pop)
        )
        segue.destination.enableSwipeToBack()
        pushedViewController = segue.destination
	}

    fileprivate func deactivatePushedViewController() {
        if let pushedViewController = pushedViewController {
            if var activable = pushedViewController as? Activable {
                activable.active = false
            }
            self.pushedViewController = nil
        }
    }

    fileprivate func removeCurrentBrewIfNeeded() {
        let alertController = UIAlertController(title: tr(.brewDetailsConfirmationTitle), message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: tr(.brewDetailsConfirmationYes), style: .destructive) {
            _ in
            self.viewModel.removeCurrentBrew {
                [weak self] didRemove in
                if didRemove {
                    _ = self?.navigationController?.popViewController(animated: true)
                }
            }
        })
        alertController.addAction(UIAlertAction(title: tr(.brewDetailsConfirmationNo), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension BrewDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
		(cell as? FinalScoreCell)?.configureWithTheme(themeConfiguration)
		(cell as? BrewAttributeCell)?.configureWithTheme(themeConfiguration)
		(cell as? BrewNotesCell)?.configureWithTheme(themeConfiguration)
		(cell as? BrewDetailsRemoveCell)?.configureWithTheme(themeConfiguration)
        if case .disclosureIndicator = cell.accessoryType {
            cell.accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
        } else {
            cell.accessoryView = nil
        }
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sectionType(forIndexPath: indexPath) {
		case .score:
			performSegue(.BrewScoreDetails)
			break
		case .coffeeInfo:
			guard viewModel.editable else { return }
            let selectableSearchIdentifier = viewModel.coffeeAttribute(forIndexPath: indexPath)
            performSegue(.SelectableSearch, sender: Box(selectableSearchIdentifier))
			break
		case .attributes:
			guard viewModel.editable else { return }
			let brewAttributeType = viewModel.brewAttributeType(forIndexPath: indexPath)
			performSegue(brewAttributeType.segueIdentifier, sender: Box(brewAttributeType))
			break
		case .notes:
			performSegue(.Notes, sender: Box<BrewAttributeType>(.Notes))
			break
        case .remove:
            removeCurrentBrewIfNeeded()
            break
		}
	}
}

extension BrewDetailsViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if var activable = viewController as? Activable {
            activable.active = true
        }
    }
}
