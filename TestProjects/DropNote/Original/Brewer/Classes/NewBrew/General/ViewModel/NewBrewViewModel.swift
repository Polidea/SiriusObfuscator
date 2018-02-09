//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift
import RxCocoa
import XCGLogger

protocol NewBrewViewModelType {
    var reloadDataAnimatedSubject: PublishSubject<Bool> { get }
    var failedToCreateNewBrewSubject: PublishSubject<Error> { get }

	var brewContext: StartBrewContext { get }
    var progressIcons: [Asset] { get }
    
    var methodTitle: String { get }
    var methodImage: UIImage? { get }

	func configureWithCollectionView(_ collectionView: UICollectionView)
	func setActiveViewControllerAtIndex(_ index: Int) -> UIViewController?
	func stepViewController(forIndexPath indexPath: IndexPath) -> UIViewController
	func cleanUp() -> Observable<Void>
	func finishBrew() -> Observable<Void>
}

struct StartBrewContext {
    var method: BrewMethod
    
    func title() -> String {
        return method.categoryDescription + " " + method.description
    }
    
    func image() -> UIImage {
        return method.image.alwaysOriginal()
    }
}

extension NewBrewViewModel: ResolvableContainer { }

final class NewBrewViewModel: NSObject, NewBrewViewModelType {
	fileprivate let disposeBag = DisposeBag()

    var resolver: Resolver?
	let brewContext: StartBrewContext
	let settingsModelController: SequenceSettingsModelControllerType
	let brewModelController: BrewModelControllerType

	let reloadDataAnimatedSubject = PublishSubject<Bool>()
	let failedToCreateNewBrewSubject = PublishSubject<Error>()
    
    var progressIcons: [Asset] {
        return dataSource.progressIcons
    }
    
    lazy var methodTitle: String = {
        return self.brewContext.title()
    }()
    
    lazy var methodImage: UIImage? = {
       return self.brewContext.image().scaled(by: 1.6)?.alwaysOriginal()
    }()

	fileprivate lazy var dataSource: NewBrewDataSource = {
		guard let resolver = self.resolver else { fatalError("Resolver is missing!") }
		let dataSource = NewBrewDataSource(
				brewContext: self.brewContext,
				brewModelController: self.brewModelController,
				settingsModelController: self.settingsModelController
				)
		dataSource.resolver = resolver
		return dataSource
	}()

	init(brewContext: StartBrewContext,
		 settingsModelController: SequenceSettingsModelControllerType,
		 newBrewModelController: BrewModelControllerType) {
		self.brewContext = brewContext
		self.settingsModelController = settingsModelController
		self.brewModelController = newBrewModelController
		super.init()
	}

	func configureWithCollectionView(_ collectionView: UICollectionView) {
		collectionView.dataSource = self
		reloadStepViewControllersWithBrewContext(brewContext, animated: false)
	}

	func setActiveViewControllerAtIndex(_ currentIndex: Int) -> UIViewController? {
		precondition(dataSource.stepViewControllers.count > 1)
		let activables = [dataSource.stepViewControllers[0], dataSource.stepViewControllers[1]]
			.flatMap { $0 }
			.filter { $0 is Activable }
			.map { $0 as! Activable }

		var activeViewController: UIViewController?
		for (i, var activable) in activables.enumerated() {
			activable.active = currentIndex == i
			if activable.active {
				activeViewController = activable as? UIViewController
			}
		}
		return activeViewController
	}

	func stepViewController(forIndexPath indexPath: IndexPath) -> UIViewController {
		return dataSource.stepViewControllers[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).item]
	}

	func cleanUp() -> Observable<Void> {
		XCGLogger.info("Removing unfinished brew")
        return brewModelController.removeUnfinishedBrew().do(onError: {
			XCGLogger.error("Error when removing unfinished brew = \($0)")
		}).map { _ in return () }
	}

	func finishBrew() -> Observable<Void> {
		brewModelController.currentBrew()?.isFinished = true
        return brewModelController.saveBrew().do(onError: {
			XCGLogger.error("Error when finishing brew = \($0)")
		})
	}

    fileprivate func reloadStepViewControllersWithBrewContext(_ brewContext: StartBrewContext, animated: Bool) {
		brewModelController
			.createNewBrew(
                withMethod: brewContext.method,
                coffee: nil,
                coffeeMachine: nil)
            .observeOn(MainScheduler.instance)
            .do(onNext: { _ in self.dataSource.reloadData() })
            .map { _ in false }
			.subscribe(
				onNext: reloadDataAnimatedSubject.onNext,
				onError: failedToCreateNewBrewSubject.onNext
            )
        .disposed(by: disposeBag)
	}
}

extension NewBrewViewModel: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return dataSource.stepViewControllers.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource.stepViewControllers[section].count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewBrewCollectionViewCell", for: indexPath) as! NewBrewCollectionViewCell
		let viewController = stepViewController(forIndexPath: indexPath)
		cell.stepView = viewController.view
		return cell
	}
}
