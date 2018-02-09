//
// Created by Maciej Oczko on 18.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCGLogger

final class WeightInputViewModel: NumericalInputViewModelType {
    fileprivate let disposeBag = DisposeBag()

    var unit: String {
        return UnitCategory.WeightUnit(rawValue:unitModelController.rawUnit(forCategory: UnitCategory.weight.rawValue))!.description
    }

    var informativeText: String {
        return tr(.weightInformativeText)
    }
    
    var currentValue: String? {
        guard let brew = brewModelController.currentBrew() else { return nil }
        guard let attribute = brew.brewAttributeForType(BrewAttributeType.CoffeeWeight) else { return nil }
        let value = BrewAttributeType.CoffeeWeight.format(attribute.value, withUnitType: attribute.unit)
        return value.replacingOccurrences(of: " ", with: "")
    }

    lazy var inputTransformer: NumericalInputTransformerType = InputTransformer.numberTransformer()

    let unitModelController: UnitsModelControllerType
    let brewModelController: BrewModelControllerType

    init(unitModelController: UnitsModelControllerType, brewModelController: BrewModelControllerType) {
        self.unitModelController = unitModelController
        self.brewModelController = brewModelController
    }

    func setInputValue(_ value: String) {
        guard let brew = brewModelController.currentBrew() else { return}
        guard let coffeeWeight = Double(value) else {
            XCGLogger.error("Couldn't convert \"\(value)\" to double!")
            return
        }

        let unit = Int32(unitModelController.rawUnit(forCategory: UnitCategory.weight.rawValue))
        brewModelController
            .createNewBrewAttribute(forType: .CoffeeWeight)
            .subscribe(onNext: configureAttibute(withBrew: brew, unit: unit, coffeeWeight: coffeeWeight))
            .disposed(by: disposeBag)
    }
    
    fileprivate func configureAttibute(withBrew brew: Brew, unit: Int32, coffeeWeight: Double) -> (BrewAttribute) -> Void {
        return {
            attribute in
            attribute.type = BrewAttributeType.CoffeeWeight.intValue
            attribute.value = coffeeWeight
            attribute.unit = unit
            attribute.brew = brew
        }
    }
}
