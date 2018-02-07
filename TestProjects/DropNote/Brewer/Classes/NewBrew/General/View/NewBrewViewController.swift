//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import XCGLogger

extension NewBrewViewController: ThemeConfigurable { }
extension NewBrewViewController: ThemeConfigurationContainer { }

final class NewBrewViewController: UIViewController {
	fileprivate let disposeBag = DisposeBag()
	fileprivate let keyboardManager = KeyboardManager()
	@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem! {
        didSet {
            doneBarButtonItem.accessibilityLabel = "Done"
            doneBarButtonItem.accessibilityHint = "Finishes brew session"
        }
    }
	@IBOutlet weak var navigationBar: NewBrewNavigationBar!
	@IBOutlet weak var progressView: NewBrewProgressView!

	var themeConfiguration: ThemeConfiguration?

    fileprivate(set) var currentPageIndex = 0 {
        didSet {
            guard let progressView = progressView else { return }
            progressView.selectIconAtIndex(currentPageIndex)
        }
    }
    
	var metrics: ScrollViewPageMetricsType!
	var viewModel: NewBrewViewModelType! {
		didSet {
            _ = viewModel.failedToCreateNewBrewSubject.subscribe(onNext: {
                XCGLogger.error("Failed to create new brew = \($0)")
            })
            _ = viewModel.reloadDataAnimatedSubject.subscribe(onNext: reloadData)
		}
	}

	let hideViewControllerSwitchingToHistorySubject = PublishSubject<Bool>()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.newBrewItemTitle)
		configureWithTheme(themeConfiguration)
        collectionView.configureWithTheme(themeConfiguration)
		collectionView.delegate = self
		collectionView.isScrollEnabled = true
        collectionView.delaysContentTouches = false
		viewModel.configureWithCollectionView(collectionView)

        configureProgressView()
		configureNavigationBar()

		keyboardManager
			.keyboardInfoChange
			.debounce(0.01, scheduler: MainScheduler.instance)
			.subscribe(onNext: handleKeyboardStateChange)
			.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.newBrew)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDoneBarButtonItemIfNeeded(collectionView)
        setCurrentViewController(collectionView)
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		childViewControllers
			.filter { $0 is Activable }
			.map { $0 as! Activable }
			.filter { $0.active }
			.first?
			.deactivate()
	}

	@IBAction func close(_ sender: AnyObject) {
        perform(viewModel.cleanUp(), isSuccessfullyFinished: false)		
	}

    @objc func done() {
        perform(viewModel.finishBrew(), isSuccessfullyFinished: true)
    }
    
    private func perform(_ observable: Observable<Void>, isSuccessfullyFinished: Bool) {
        observable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onCompleted: {
                [weak self] in
                self?.hideViewControllerSwitchingToHistorySubject.onNext(isSuccessfullyFinished)
            })
            .addDisposableTo(disposeBag)
    }

	private func configureNavigationBar() {
		navigationBar.configureWithTheme(themeConfiguration)
		navigationBar.alpha = 0
        navigationBar.previousButton.accessibilityLabel = "Previous Step"
        navigationBar.nextButton.accessibilityLabel = "Next Step"
		navigationBar.previousButton.addTarget(self, action: #selector(NewBrewViewController.previousStep), for: .touchUpInside)
		navigationBar.nextButton.addTarget(self, action: #selector(NewBrewViewController.nextStep), for: .touchUpInside)
	}
    
    private func configureProgressView() {
        progressView.configureWithTheme(themeConfiguration)        
        progressView.axis = .horizontal
        progressView.distribution = .equalSpacing
        progressView.alignment = .center
    }
    
    private func reloadData(_ animated: Bool) {
        collectionView.reloadData()
        progressView.configureWithIcons(viewModel.progressIcons)
        progressView.selectIconAtIndex(0)
        progressView.show(animated: animated)
        navigationBar.show(animated: animated)
        navigationBar.hidePreviousArrow(animated: animated)
    }
}

extension NewBrewViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let childViewController = viewModel.stepViewController(forIndexPath: indexPath)
		addChildViewController(childViewController)
		childViewController.didMove(toParentViewController: self)
        
        cell.configureWithTheme(themeConfiguration)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let childViewController = viewModel.stepViewController(forIndexPath: indexPath)
        childViewController.removeFromParentViewController()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentPageIndex = metrics.currentPageIndexForScrollView(scrollView)
        setCurrentViewController(scrollView)
        setDoneBarButtonItemIfNeeded(scrollView)
        disableProgressViewIfNeeded(scrollView)
        updateNavigationArrows()
	}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageIndex = metrics.currentPageIndexForScrollView(scrollView)
        setCurrentViewController(scrollView)
        setDoneBarButtonItemIfNeeded(scrollView)
        disableProgressViewIfNeeded(scrollView)
        updateNavigationArrows()
    }

	// MARK: Helpers

	fileprivate func setDoneBarButtonItemIfNeeded(_ scrollView: UIScrollView) {
		if metrics.isLastPageOfScrollView(scrollView) {
			let barButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_done), style: .plain, target: self, action: #selector(NewBrewViewController.done))
			navigationItem.setRightBarButton(barButtonItem, animated: true)
		} else {
            let barButtonItem = UIBarButtonItem(image: viewModel.methodImage, style: .plain, target: nil, action: nil)
            barButtonItem.isEnabled = false

			navigationItem.setRightBarButton(barButtonItem, animated: false)
		}
	}
    
    private func disableProgressViewIfNeeded(_ scrollView: UIScrollView) {
        if metrics.isLastPageOfScrollView(scrollView) {
            progressView.disable()
        }
    }

	fileprivate func setCurrentViewController(_ scrollView: UIScrollView) {
		let currentIndex = metrics.currentPageIndexForScrollView(scrollView)
		if let activeViewController = viewModel.setActiveViewControllerAtIndex(currentIndex) {
			title = activeViewController.title ?? viewModel.methodTitle
		} else {
			title = viewModel.methodTitle
		}
	}

	fileprivate func handleKeyboardStateChange(_ info: KeyboardInfo) {
		if info.state == .willShow || info.state == .visible {
			navigationBar.bottomConstraint.constant = info.endFrame.size.height + 10
		} else {
			navigationBar.bottomConstraint.constant = 10.0
		}

		UIView.animate(withDuration: info.animationDuration, delay: 0.0, options: info.animationOptions, animations: {
			self.view.layoutIfNeeded()
        }, completion: nil)
	}
}

// MARK: Navigation

extension NewBrewViewController {
    
    func updateNavigationArrows() {
        if metrics.isFirstPageOfScrollView(collectionView) {
            navigationBar.showNextArrow()
            navigationBar.hidePreviousArrow()
        } else if metrics.isLastPageOfScrollView(collectionView) {
            navigationBar.showPreviousArrow()
            navigationBar.hideNextArrow()
        } else {
            navigationBar.showPreviousArrow()
            navigationBar.showNextArrow()
        }
    }

    @objc func previousStep() {
        collectionView.scrollVerticallyToPageAtIndex(currentPageIndex - 1)
	}

    @objc func nextStep() {
        collectionView.scrollVerticallyToPageAtIndex(currentPageIndex + 1)
	}
}
