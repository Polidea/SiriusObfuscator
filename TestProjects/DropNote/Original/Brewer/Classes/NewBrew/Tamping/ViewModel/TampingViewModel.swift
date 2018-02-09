//
//  TampingViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 19.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum TampingUnit: Int32 {
    case continuous
}

protocol TampingViewModelType {
    var tampingValue: Variable<Float> { get }
    var informativeText: String { get }
}

final class TampingViewModel: TampingViewModelType {
    fileprivate let disposeBag = DisposeBag()
    let brewModelController: BrewModelControllerType
    
    fileprivate(set) var tampingValue = Variable<Float>(0.0)
    
    var informativeText: String {
        return tr(.tampingInformativeText)
    }
    
    init(brewModelController: BrewModelControllerType) {
        self.brewModelController = brewModelController
        
        updateAttribute(tampingValue.asObservable()) {
            value, attribute in
            attribute.type = BrewAttributeType.TampStrength.intValue
            attribute.unit = TampingUnit.continuous.rawValue
            attribute.value = Double(value)
            return attribute
        }
    }
    
    fileprivate func updateAttribute<O: ObservableType>(_ source: O, resultSelector: @escaping (O.E, BrewAttribute) throws -> (BrewAttribute)) {
        let attributeObservable: Observable<BrewAttribute> = {
            if let attribute = brewModelController.currentBrew()?.brewAttributeForType(.TampStrength) {
                return Observable.just(attribute)
            } else {
                return brewModelController.createNewBrewAttribute(forType: .TampStrength)
            }
        }()
        
        Observable
            .combineLatest(source, attributeObservable, resultSelector: resultSelector)
            .subscribe(onNext: { attribute in attribute.brew = self.brewModelController.currentBrew() })
            .disposed(by: disposeBag)
    }
}
