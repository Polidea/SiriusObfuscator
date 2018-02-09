//
// Created by Maciej Oczko on 18.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCGLogger

final class TemperatureInputViewModel: NumericalInputViewModelType {
    fileprivate let disposeBag = DisposeBag()

    var unit: String {
        return UnitCategory.TemperatureUnit(rawValue:unitModelController.rawUnit(forCategory: UnitCategory.temperature.rawValue))!.description
    }

    var informativeText: String {
        return tr(.temperatureInformativeText)
    }
    
    var currentValue: String? {
        guard let brew = brewModelController.currentBrew() else { return nil }
        guard let attribute = brew.brewAttributeForType(BrewAttributeType.WaterTemperature) else { return nil }
        let value = BrewAttributeType.WaterTemperature.format(attribute.value, withUnitType: attribute.unit)
        return value.replacingOccurrences(of: " ", with: "")
    }

    lazy var inputTransformer: NumericalInputTransformerType = {
        return InputTransformer.temperatureTransformer()
    }()

    let unitModelController: UnitsModelControllerType
    let brewModelController: BrewModelControllerType

    init(unitModelController: UnitsModelControllerType, brewModelController: BrewModelControllerType) {
        self.unitModelController = unitModelController
        self.brewModelController = brewModelController
    }

    func setInputValue(_ value: String) {
        guard let brew = brewModelController.currentBrew() else { return }
        guard let waterTemperature = Double(value) else {
            XCGLogger.error("Couldn't convert \"\(value)\" to double!")
            return
        }

        let unit = Int32(unitModelController.rawUnit(forCategory: UnitCategory.temperature.rawValue))
        brewModelController
            .createNewBrewAttribute(forType: .WaterTemperature)
            .subscribe(onNext: configureAttibute(withBrew: brew, unit: unit, waterTemperature: waterTemperature))
            .disposed(by: disposeBag)
    }
    
    fileprivate func configureAttibute(withBrew brew: Brew, unit: Int32, waterTemperature: Double) -> (BrewAttribute) -> Void {
        return {
            attribute in
            attribute.type = BrewAttributeType.WaterTemperature.intValue
            attribute.value = waterTemperature
            attribute.unit = unit
            attribute.brew = brew
        }
    }
}
