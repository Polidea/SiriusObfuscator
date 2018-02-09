//
// Created by Maciej Oczko on 14.01.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCGLogger

final class PreInfusionTimeInputViewModel: NumericalInputViewModelType {
    fileprivate let disposeBag = DisposeBag()

    var unit: String {
        return "m"
    }

  // swiftlint:disable todo
    var informativeText: String {
        return tr(.timeInformativeText) // TODO check if needed to change
    }
  // swiftlint:enable todo

    var currentValue: String?
    lazy var inputTransformer: NumericalInputTransformerType = InputTransformer.timeTransformer()

    let unitModelController: UnitsModelControllerType
    let brewModelController: BrewModelControllerType

    init(unitModelController: UnitsModelControllerType, brewModelController: BrewModelControllerType) {
        self.unitModelController = unitModelController
        self.brewModelController = brewModelController
    }

    func setInputValue(_ value: String) {
        guard let brew = brewModelController.currentBrew() else { return }

        let components = value.components(separatedBy: ":")
        let minutes = Int(components.first!)!
        let seconds = Int(components.last!)!
        let duration = TimeInterval(60 * minutes + seconds)

        brewModelController
            .createNewBrewAttribute(forType: .PreInfusionTime)
            .subscribe(onNext: {
                attribute in

                attribute.type = BrewAttributeType.PreInfusionTime.intValue
                attribute.value = duration
                attribute.unit = Int32(TimeUnit.seconds.rawValue)
                attribute.brew = brew

            })
            .disposed(by: disposeBag)
    }
}
