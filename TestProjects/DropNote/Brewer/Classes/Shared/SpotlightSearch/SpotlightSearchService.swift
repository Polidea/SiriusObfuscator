//
// Created by Maciej Oczko on 20.01.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger
import CoreSpotlight
import MobileCoreServices

final class SpotlightSearchService {

	let searchableIndex: CSSearchableIndex

	init(searchableIndex: CSSearchableIndex) {
		self.searchableIndex = searchableIndex
	}

	func updateSearchableIndex(with brews: [Brew]) {
		let searchableItems: [CSSearchableItem] = brews.map {
			return CSSearchableItem(uniqueIdentifier: uniqueSearchableIndexIdentifier(for: $0),
									domainIdentifier: nil, attributeSet:
									searchableItemAttributeSet(for: $0))
		}
        DispatchQueue.global().async {
            [weak self] in
            self?.searchableIndex.indexSearchableItems(searchableItems) {
                error in
                if let error = error {
                    XCGLogger.error("Error indexing coffee brews = \(error)")
                } else {
                    XCGLogger.info("Coffee brews indexed in spotlight search.")
                }
            }
        }
		
	}

	func deleteFromSearchableIndex(using identifier: String) {
        DispatchQueue.global().async {
            [weak self] in
            self?.searchableIndex.deleteSearchableItems(withIdentifiers: [identifier]) {
                error in
                if let error = error {
                    XCGLogger.error("Error deleting coffee brews = \(error)")
                } else {
                    XCGLogger.info("Coffee brews deleted for spotlight search.")
                }
            }
            
        }
    }

	func selectedBrew(for activity: NSUserActivity, from brews: [Brew]) -> Brew? {
		guard activity.activityType == CSSearchableItemActionType,
			  let identifier = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
			return nil
		}
		return brews.filter { uniqueSearchableIndexIdentifier(for: $0) == identifier }.first
	}

	func uniqueSearchableIndexIdentifier(for brew: Brew) -> String {
		return brew.objectID.uriRepresentation().absoluteString
	}

	private func searchableItemAttributeSet(for brew: Brew) -> CSSearchableItemAttributeSet {
		let value = BrewMethod.fromIntValue(brew.method)
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeCalendarEvent as String)
		attributeSet.title = brew.coffee?.name
		attributeSet.contentDescription = "\(value.categoryDescription), \(tr(.brewDetailScore)): \(brew.score)"
		attributeSet.startDate = Date(timeIntervalSinceReferenceDate: brew.created)
		attributeSet.thumbnailData = UIImagePNGRepresentation(value.image)
		attributeSet.keywords = [tr(.unitCategoryCoffee)]
		return attributeSet
	}
}
