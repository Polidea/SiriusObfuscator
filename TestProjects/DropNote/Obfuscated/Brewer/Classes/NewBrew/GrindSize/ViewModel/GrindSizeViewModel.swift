//
//  GrindSizeViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 19.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum h0Ge1LxoyNIgZ77XQi4N2MY9L_t29lDc: Int32 {
	case slider
	case numeric
}

enum TeOpHVmZuIISqPU8uxDrsA2TDLFEgmyr: Double {
	case extraFine = 1.0
	case fine = 2.0
	case medium = 3.0
	case coarse = 4.0
}

extension TeOpHVmZuIISqPU8uxDrsA2TDLFEgmyr: CustomStringConvertible {
	var description: String {
		switch self {
		case .extraFine: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.grindSizeLevelExtraFine)
		case .fine: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.grindSizeLevelFine)
		case .medium: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.grindSizeLevelMedium)
        case .coarse: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.grindSizeLevelCoarse)
		}
	}
}

protocol S5kCJG4IgkiAiGWnEgNVW80g0mfFMZVN {
	var MIKjGs8M_YzNMF5R_WdTUNfo6PbAmkLM: Float { get }
	var j21w2jpm12DWT3DmcGT1WXgrbe14jTfd: Float { get }
	var A7aoOuOEIq2kkuy7l1ljX1WEfOncMQO0: Variable<Float> { get }
	var qMwc1fwMXPkK3uD7l1vcoph4dUJZmpb9: Variable<String> { get }
    var H7AeQjwpnlhhX_i3dT8S9chowg8UUa63: mMhVBR3TDKD0aRiE4Lq1srELaxIZmKz8 { get }
    var OPgB49RAPDCG0aDEQkA67t1vEDyp0qic: Bool { get set }
    var bM4YoUvy4dgTYePbx9WvIgbtN1aSjFql: String { get }
}

final class ckDjoI4LBVm2K4VsANv5OkBTfqhwS7kH: S5kCJG4IgkiAiGWnEgNVW80g0mfFMZVN {
	fileprivate let V5kJaY5OyjSulC7fkxe_9griQVA3pHti = DisposeBag()
    
    enum hofb6ZN_xDUexwanH5IKpAHqjyCrY2yh: String {
        case GrindSizeSliderVisibility = "GrindSizeSliderVisibilitySetting"
    }

    let H7AeQjwpnlhhX_i3dT8S9chowg8UUa63 = rIuG9RwkfBG1CNhnbFPWZNknMVmq06Q2.UsVQWPjqJO734UmZc6Y1wsSyEdPGT6By()
	let iSvzLGoSoKyZBlDZkUcozZmN54hWwVhm: Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4
    let wn83etfGGkgV94Pk24_M01lFS2TqmjoC: M5jGoZc5zWwxlh8ebhtk0wDxk8apfl1e

	fileprivate(set) var A7aoOuOEIq2kkuy7l1ljX1WEfOncMQO0 = Variable<Float>(0.0)
	fileprivate(set) var qMwc1fwMXPkK3uD7l1vcoph4dUJZmpb9 = Variable<String>("")
    
    var bM4YoUvy4dgTYePbx9WvIgbtN1aSjFql: String {
        return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.grindSizeInformativeText)
    }
    
    var OPgB49RAPDCG0aDEQkA67t1vEDyp0qic: Bool {
        set {
            wn83etfGGkgV94Pk24_M01lFS2TqmjoC.set(NSNumber(value: newValue as Bool), forKey: hofb6ZN_xDUexwanH5IKpAHqjyCrY2yh.GrindSizeSliderVisibility.rawValue)
        }
        get {
            if let visibilitySetting = wn83etfGGkgV94Pk24_M01lFS2TqmjoC.object(forKey: hofb6ZN_xDUexwanH5IKpAHqjyCrY2yh.GrindSizeSliderVisibility.rawValue) as? NSNumber {
                return visibilitySetting.boolValue
            }
            return true
        }
    }

	var MIKjGs8M_YzNMF5R_WdTUNfo6PbAmkLM: Float { return Float(TeOpHVmZuIISqPU8uxDrsA2TDLFEgmyr.extraFine.rawValue) }
	var j21w2jpm12DWT3DmcGT1WXgrbe14jTfd: Float { return Float(TeOpHVmZuIISqPU8uxDrsA2TDLFEgmyr.coarse.rawValue) }

	init(xkqXlDkndm8uxW52AEd8pg0d7z83s_5v: Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4, DV1o9DXGAnnuNJh94upJfGwHiM03MA1C: M5jGoZc5zWwxlh8ebhtk0wDxk8apfl1e) {
		self.iSvzLGoSoKyZBlDZkUcozZmN54hWwVhm = xkqXlDkndm8uxW52AEd8pg0d7z83s_5v
        self.wn83etfGGkgV94Pk24_M01lFS2TqmjoC = DV1o9DXGAnnuNJh94upJfGwHiM03MA1C

		KD4uUZ5RxNAbig527AXv9mJEY0gfdTi8()
	}
    
    fileprivate func KD4uUZ5RxNAbig527AXv9mJEY0gfdTi8() {
        let sliderObservable = A7aoOuOEIq2kkuy7l1ljX1WEfOncMQO0
            .asObservable()
            .map { (Double(round($0 * 4)), h0Ge1LxoyNIgZ77XQi4N2MY9L_t29lDc.slider.rawValue) }
        
        let numericObservable = qMwc1fwMXPkK3uD7l1vcoph4dUJZmpb9
            .asObservable()
            .filter { !$0.characters.isEmpty }
            .map { (Double($0)!, h0Ge1LxoyNIgZ77XQi4N2MY9L_t29lDc.numeric.rawValue) }
                
        let valueUnits = Observable
            .of(sliderObservable, numericObservable)
            .merge()
        
        ankVAnUkVtbI1FNVtx76fd_nQJMNazCO(valueUnits) {
            (valueUnitPair, attribute) in
            attribute.type = Dvzdce97fie2QBNN2QeyAMRncrQUlOcu.GrindSize.intValue
            attribute.value = valueUnitPair.0
            attribute.unit = valueUnitPair.1
            return attribute
        }
    }

	fileprivate func ankVAnUkVtbI1FNVtx76fd_nQJMNazCO<O: ObservableType>(_ wMHf1OWD7quTZH0L2FqxSGnm4sxEO7Tr: O, shc68sFeOEA2Is5JOekH8u7ekcCUot7E: @escaping (O.E, BrewAttribute) throws -> (BrewAttribute)) {
		let attributeObservable: Observable<BrewAttribute> = {
			if let attribute = iSvzLGoSoKyZBlDZkUcozZmN54hWwVhm.VPXwgp9nWfsBRXGR06eTZISB91jigODw()?.CIT4NIIpB4gskA2aF8IT74ou_B7fMd_A(.GrindSize) {
				return Observable.just(attribute)
			} else {
				return iSvzLGoSoKyZBlDZkUcozZmN54hWwVhm.pc7RokByJs6TFwuLjYDLJqRDi3yyP_so(US2U7U2zqwFKLBrfqx3NQIq7158C0Xdl: .GrindSize)
			}
		}()

		Observable
			.combineLatest(wMHf1OWD7quTZH0L2FqxSGnm4sxEO7Tr, attributeObservable, resultSelector: shc68sFeOEA2Is5JOekH8u7ekcCUot7E)
            .subscribe(onNext: { attribute in attribute.brew = self.iSvzLGoSoKyZBlDZkUcozZmN54hWwVhm.VPXwgp9nWfsBRXGR06eTZISB91jigODw() })
			.disposed(by: V5kJaY5OyjSulC7fkxe_9griQVA3pHti)
	}

}
