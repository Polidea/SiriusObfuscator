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

enum CUMdt2Zl1O9ae4pHZnAg9cT76XMRxksK: Int32 {
    case continuous
}

protocol jZwXnUvT0cmAr8uOecd7x2ZUivDb0WUa {
    var l7BxpTmmsmmtBPDaDO3zdXLhXuLqnz48: Variable<Float> { get }
    var bM4YoUvy4dgTYePbx9WvIgbtN1aSjFql: String { get }
}

final class WtJHDwHSH2842mV0QTJ3tIiQ67zlTRuK: jZwXnUvT0cmAr8uOecd7x2ZUivDb0WUa {
    fileprivate let Krr6YKqobdfcITGehIn2BRsEn9Q8oJT1 = DisposeBag()
    let pFMXUsg54hMBXqod70yXNz6k9zHW7DRj: Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4
    
    fileprivate(set) var l7BxpTmmsmmtBPDaDO3zdXLhXuLqnz48 = Variable<Float>(0.0)
    
    var bM4YoUvy4dgTYePbx9WvIgbtN1aSjFql: String {
        return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.tampingInformativeText)
    }
    
    init(l3MGaQbfQa8mnUvvaR138dTyC3BDQPSQ: Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4) {
        self.pFMXUsg54hMBXqod70yXNz6k9zHW7DRj = l3MGaQbfQa8mnUvvaR138dTyC3BDQPSQ
        
        ZB207QKvhHtU80JryVQTn7CfbFK4lLTo(l7BxpTmmsmmtBPDaDO3zdXLhXuLqnz48.asObservable()) {
            value, attribute in
            attribute.type = Dvzdce97fie2QBNN2QeyAMRncrQUlOcu.TampStrength.intValue
            attribute.unit = CUMdt2Zl1O9ae4pHZnAg9cT76XMRxksK.continuous.rawValue
            attribute.value = Double(value)
            return attribute
        }
    }
    
    fileprivate func ZB207QKvhHtU80JryVQTn7CfbFK4lLTo<O: ObservableType>(_ yhsRPC1PygRmhRLEwpHT5ZL6yfBAS64l: O, t3K_8HRXy_fukpWLKAO4KkrV0LP5EcyA: @escaping (O.E, BrewAttribute) throws -> (BrewAttribute)) {
        let attributeObservable: Observable<BrewAttribute> = {
            if let attribute = pFMXUsg54hMBXqod70yXNz6k9zHW7DRj.VPXwgp9nWfsBRXGR06eTZISB91jigODw()?.CIT4NIIpB4gskA2aF8IT74ou_B7fMd_A(.TampStrength) {
                return Observable.just(attribute)
            } else {
                return pFMXUsg54hMBXqod70yXNz6k9zHW7DRj.pc7RokByJs6TFwuLjYDLJqRDi3yyP_so(US2U7U2zqwFKLBrfqx3NQIq7158C0Xdl: .TampStrength)
            }
        }()
        
        Observable
            .combineLatest(yhsRPC1PygRmhRLEwpHT5ZL6yfBAS64l, attributeObservable, resultSelector: t3K_8HRXy_fukpWLKAO4KkrV0LP5EcyA)
            .subscribe(onNext: { attribute in attribute.brew = self.pFMXUsg54hMBXqod70yXNz6k9zHW7DRj.VPXwgp9nWfsBRXGR06eTZISB91jigODw() })
            .disposed(by: Krr6YKqobdfcITGehIn2BRsEn9Q8oJT1)
    }
}
