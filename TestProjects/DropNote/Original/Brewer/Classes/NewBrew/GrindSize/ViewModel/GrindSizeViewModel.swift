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

enum GrindSizeUnit: Int32 {
	case slider
	case numeric
}

enum GrindSizeSliderValue: Double {
	case extraFine = 1.0
	case fine = 2.0
	case medium = 3.0
	case coarse = 4.0
}

extension GrindSizeSliderValue: CustomStringConvertible {
	var description: String {
		switch self {
		case .extraFine: return tr(.grindSizeLevelExtraFine)
		case .fine: return tr(.grindSizeLevelFine)
		case .medium: return tr(.grindSizeLevelMedium)
        case .coarse: return tr(.grindSizeLevelCoarse)
		}
	}
}

protocol GringSizeViewModelType {
	var sliderMinimumValue: Float { get }
	var sliderMaximumValue: Float { get }
	var sliderValue: Variable<Float> { get }
	var numericValue: Variable<String> { get }
    var inputTransformer: NumericalInputTransformerType { get }
    var isSliderVisible: Bool { get set }
    var informativeText: String { get }
}

final class GringSizeViewModel: GringSizeViewModelType {
	fileprivate let disposeBag = DisposeBag()
    
    enum Keys: String {
        case GrindSizeSliderVisibility = "GrindSizeSliderVisibilitySetting"
    }

    let inputTransformer = InputTransformer.numberTransformer()
	let brewModelController: BrewModelControllerType
    let keyValueStore: KeyValueStoreType

	fileprivate(set) var sliderValue = Variable<Float>(0.0)
	fileprivate(set) var numericValue = Variable<String>("")
    
    var informativeText: String {
        return tr(.grindSizeInformativeText)
    }
    
    var isSliderVisible: Bool {
        set {
            keyValueStore.set(NSNumber(value: newValue as Bool), forKey: Keys.GrindSizeSliderVisibility.rawValue)
        }
        get {
            if let visibilitySetting = keyValueStore.object(forKey: Keys.GrindSizeSliderVisibility.rawValue) as? NSNumber {
                return visibilitySetting.boolValue
            }
            return true
        }
    }

	var sliderMinimumValue: Float { return Float(GrindSizeSliderValue.extraFine.rawValue) }
	var sliderMaximumValue: Float { return Float(GrindSizeSliderValue.coarse.rawValue) }

	init(brewModelController: BrewModelControllerType, keyValueStore: KeyValueStoreType) {
		self.brewModelController = brewModelController
        self.keyValueStore = keyValueStore

		configureAttributeUpdates()
	}
    
    fileprivate func configureAttributeUpdates() {
        let sliderObservable = sliderValue
            .asObservable()
            .map { (Double(round($0 * 4)), GrindSizeUnit.slider.rawValue) }
        
        let numericObservable = numericValue
            .asObservable()
            .filter { !$0.characters.isEmpty }
            .map { (Double($0)!, GrindSizeUnit.numeric.rawValue) }
                
        let valueUnits = Observable
            .of(sliderObservable, numericObservable)
            .merge()
        
        updateAttribute(valueUnits) {
            (valueUnitPair, attribute) in
            attribute.type = BrewAttributeType.GrindSize.intValue
            attribute.value = valueUnitPair.0
            attribute.unit = valueUnitPair.1
            return attribute
        }
    }

	fileprivate func updateAttribute<O: ObservableType>(_ source: O, resultSelector: @escaping (O.E, BrewAttribute) throws -> (BrewAttribute)) {
		let attributeObservable: Observable<BrewAttribute> = {
			if let attribute = brewModelController.currentBrew()?.brewAttributeForType(.GrindSize) {
				return Observable.just(attribute)
			} else {
				return brewModelController.createNewBrewAttribute(forType: .GrindSize)
			}
		}()

		Observable
			.combineLatest(source, attributeObservable, resultSelector: resultSelector)
            .subscribe(onNext: { attribute in attribute.brew = self.brewModelController.currentBrew() })
			.disposed(by: disposeBag)
	}

}
