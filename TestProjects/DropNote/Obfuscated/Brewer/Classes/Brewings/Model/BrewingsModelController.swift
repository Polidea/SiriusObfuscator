//
// Created by Maciej Oczko on 17.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import XCGLogger

protocol dtDl9Wh2QnIAaOlrxAvQQVShSDeL6Ep2 {
	var r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k: NSFetchedResultsController<Brew> { get }
    var i_Zbb1GSEKuDq4MfovYOnLpgbumJrT7i: XEJCtBTfxl7_Pw4vji8sf36Xg3aX5znV { get set }
	func ITgZpxXqz9lxF6tM6OsW893KIXusFwAO(_ AFLYp8idcCdggKCD8H520UFTB_CAL29c: String?)
}

final class R07FnupQ7aWPZbz2XOCy_VmoLqMuY8xZ: dtDl9Wh2QnIAaOlrxAvQQVShSDeL6Ep2 {
	let Z0qEY9k8hvtbYC2B3L00XQnFgpsI4ySy: FiPo5WjIle8_QlTDYzuos59EOIfdXKGG
    fileprivate let zdWzlOxIhd7Rci1K5XSX8oPSVdwXVmUZ = NSPredicate(format: "isFinished == %@", true as CVarArg)

    var i_Zbb1GSEKuDq4MfovYOnLpgbumJrT7i: XEJCtBTfxl7_Pw4vji8sf36Xg3aX5znV = .dateDescending {
        didSet {
            r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k.fetchRequest.sortDescriptors = [i_Zbb1GSEKuDq4MfovYOnLpgbumJrT7i.sortDescriptor]
            do {
                try r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k.performFetch()
            } catch {
                XCGLogger.error("Error when fetching brews = \(error)")
            }
        }
    }

	lazy var r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k: NSFetchedResultsController<Brew> = {
		let fetchRequest = NSFetchRequest<Brew>(entityName: Brew.kiP0LT8ZEQiRcS3ZjoViSQTJwbjg0NkS())
		fetchRequest.sortDescriptors = [self.i_Zbb1GSEKuDq4MfovYOnLpgbumJrT7i.sortDescriptor]
		fetchRequest.predicate = self.zdWzlOxIhd7Rci1K5XSX8oPSVdwXVmUZ
		let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.Z0qEY9k8hvtbYC2B3L00XQnFgpsI4ySy.XsjtJPlSNARHiLHHQIpgHrXek2hGBTbH,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        do {
            try fetchedResultsController.performFetch()
        } catch {
            XCGLogger.error("Error when fetching brews = \(error)")
        }

		return fetchedResultsController
	}()

	init(zIZpg9EtW8B9N6LxCKVJPQdXnVobBjFu: FiPo5WjIle8_QlTDYzuos59EOIfdXKGG) {
		self.Z0qEY9k8hvtbYC2B3L00XQnFgpsI4ySy = zIZpg9EtW8B9N6LxCKVJPQdXnVobBjFu
	}

	func ITgZpxXqz9lxF6tM6OsW893KIXusFwAO(_ AFLYp8idcCdggKCD8H520UFTB_CAL29c: String?) {
		var searchPredicate: NSPredicate?
		if let search = AFLYp8idcCdggKCD8H520UFTB_CAL29c, !search.isEmpty {
			var subpredicates = [
					NSPredicate(format: "coffee.name CONTAINS[c] %@", search),
					NSPredicate(format: "coffeeMachine.name CONTAINS[c] %@", search),
					NSPredicate(format: "notes CONTAINS[c] %@", search)
			]

			if let score = Double(search) {
				let lowerScoreBoundary = floor(score)
				let isScoreNotPrecise = score == lowerScoreBoundary
				if isScoreNotPrecise {
					let upperScoreBoundary = floor(score + 1)
					subpredicates.append(NSPredicate(format: "score >= %lf AND score <= %lf", lowerScoreBoundary, upperScoreBoundary))
				} else {
					subpredicates.append(NSPredicate(format: "score == %lf", score))
				}
			}
			searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
		}

		r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			zdWzlOxIhd7Rci1K5XSX8oPSVdwXVmUZ,
			searchPredicate ?? NSPredicate.SJuLI2foJ21JIoX_FbtpcpJldhrtH4ij()
		])

		do {
			try r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k.performFetch()
            if let didChangeContent = r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k.delegate?.controllerDidChangeContent {
                didChangeContent(r3V9MnnJgyolNv9q841ZQ_HIbmNX2K0k as! NSFetchedResultsController<NSFetchRequestResult>)
            }
		} catch {
			XCGLogger.error("Error when filtering brews = \(error)")
		}
	}
}
