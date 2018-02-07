//
// Created by Maciej Oczko on 18.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger
import RxSwift
import RxCocoa

final class WaterInputViewModel: NumericalInputViewModelType {
    fileprivate let disposeBag = DisposeBag()

    var unit: String {
        return UnitCategory.WaterUnit(rawValue: unitModelController.rawUnit(forCategory: UnitCategory.water.rawValue))!.description
    }

    var informativeText: String {
        return tr(.waterInformativeText)
    }
    
    var currentValue: String? {
        guard let brew = brewModelController.currentBrew() else { return nil }
        guard let attribute = brew.brewAttributeForType(BrewAttributeType.WaterWeight) else { return nil }
        let value = BrewAttributeType.WaterWeight.format(attribute.value, withUnitType: attribute.unit)
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
        guard let brew = brewModelController.currentBrew() else { return }
        guard let waterWeight = Double(value) else {
            XCGLogger.error("Couldn't convert \"\(value)\" to double!")
            return
        }

        let unit = Int32(unitModelController.rawUnit(forCategory: UnitCategory.water.rawValue))
        brewModelController
            .createNewBrewAttribute(forType: .WaterWeight)
            .subscribe(onNext: configureAttibute(withBrew: brew, unit: unit, waterWeight: waterWeight))
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func configureAttibute(withBrew brew: Brew, unit: Int32, waterWeight: Double) -> (BrewAttribute) -> Void {
        return {
            attribute in
            attribute.type = BrewAttributeType.WaterWeight.intValue
            attribute.value = waterWeight
            attribute.unit = unit
            attribute.brew = brew
        }
    }
}
