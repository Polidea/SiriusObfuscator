//
// Created by Maciej Oczko on 20.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import FormatterKit

protocol BrewCellViewModelType {
    var createdAt: String { get }
    var coffee: String { get }
    var score: String { get }
    var methodImageName: Asset { get }
    var methodColor: UIColor { get }
    var methodLightColor: UIColor { get }
    var fillingFactor: Double { get }
}

final class BrewCellViewModel: BrewCellViewModelType {
    var createdAt: String
    var coffee: String
    var score: String
    var methodImageName: Asset
    var methodColor: UIColor
    var methodLightColor: UIColor
    var fillingFactor: Double

    init(brew: Brew) {
        
        let createdDate = Date(timeIntervalSinceReferenceDate: brew.created)
        let components = (Calendar.current as NSCalendar).components(.day, from: createdDate, to: Date(), options: .wrapComponents)
        if components.day! > 2 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            createdAt = dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: brew.created))
        } else {
            let intervalFormatter = TTTTimeIntervalFormatter()
            intervalFormatter.usesIdiomaticDeicticExpressions = true
            createdAt = intervalFormatter.stringForTimeInterval(from: Date(), to: createdDate)
        }
        
        let brewMethod = BrewMethod.fromIntValue(brew.method)
        methodImageName = brewMethod.imageName
        methodColor = brewMethod.color
        methodLightColor = brewMethod.lightColor
        coffee = brew.coffee?.name ?? "?"
        score = brew.score == 0 ? "?" : brew.score.format(".1")
        fillingFactor = brew.score / 10
    }
}
