//
// Created by Maciej Oczko on 01.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension BrewScoreDetailsViewController: ThemeConfigurationContainer { }

final class BrewScoreDetailsViewController: UIViewController {
	fileprivate let disposeBag = DisposeBag()
	@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: BrewScoreDetailsHeaderView!
    
    fileprivate lazy var doneBarButtonItem: UIBarButtonItem = UIBarButtonItem(
        image: UIImage(named: "ic_done")!,
        style: .plain,
        target: self,
        action: #selector(done)
    )
	
    var themeConfiguration: ThemeConfiguration?
    var viewModel: BrewScoreDetailsViewModelType!
    fileprivate var shouldSaveScore = false

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.brewScoreDetailsItemTitle)
        headerView.titleLabel.text = tr(.brewDetailScore)
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
		viewModel.scoreValue
			.asObservable()
            .bind(to: headerView.valueLabel.rx.text)
			.disposed(by: disposeBag)
        
        tableView.delegate = self
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableViewAutomaticDimension
		viewModel.configureWithTableView(tableView)
        
        enableSwipeToBack()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.configureWithTheme(themeConfiguration)
        headerView.configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.scoreDetails)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldSaveScore {
            viewModel.saveScore()
        } else {
            viewModel.dropScoreChanges()
        }
    }
    
    @objc fileprivate func done() {
        shouldSaveScore = true
        _ = navigationController?.popViewController(animated: true)
    }
}

extension BrewScoreDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        (cell as? BrewScoreDetailCell)?.configureWithTheme(themeConfiguration)
    }
}
