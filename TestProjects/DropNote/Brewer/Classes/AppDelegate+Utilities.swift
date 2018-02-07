//
//  AppDelegate+Utilities.swift
//  Brewer
//
//  Created by Maciej Oczko on 31.07.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Reveal

extension AppDelegate {
    func loadReveal() {
        #if !DEBUG
            return
        #else
            if NSClassFromString("IBARevealLoader") == nil {
                let revealLibName = "libReveal"
                let revealLibExtension = "dylib"
                var error: String?
                
                if let dylibPath = Bundle.main.path(forResource: revealLibName, ofType: revealLibExtension) {
                    print("Loading dynamic library \(dylibPath)")
                    
                    let revealLib = dlopen(dylibPath, RTLD_NOW)
                    if revealLib == nil {
                        error = String(describing: dlerror())
                    }
                } else {
                    error = "File not found."
                }
                
                if error != nil {
                    let alert = UIAlertController(title: "Reveal library could not be loaded",
                                                  message: "\(revealLibName).\(revealLibExtension) failed to load with error: \(error!)",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        #endif
    }
}

// MARK: Mock data

extension AppDelegate {
    func loadMockData() {
        #if !DEBUG
            return
        #else
            let stack = assembler.resolver.resolve(StackType.self)!
            
            let coffeeOperations = CoreDataOperations<Coffee>(managedObjectContext: stack.mainContext)
            let machineOperations = CoreDataOperations<CoffeeMachine>(managedObjectContext: stack.mainContext)
            
            let coffee1 = coffeeOperations.create(); coffee1.name = "Brazylia Sao Judas"
            let coffee2 = coffeeOperations.create(); coffee2.name = "Gwatemala Sierra Morena"
            let coffee3 = coffeeOperations.create(); coffee3.name = "Kolumbia Maria Chavez"
            let coffee4 = coffeeOperations.create(); coffee4.name = "Etiopia Chucho"
            let coffee5 = coffeeOperations.create(); coffee5.name = "Etiopia Kefa"
            
            let machine1 = machineOperations.create(); machine1.name = "La Pavoni BAR T 2L"
            let machine2 = machineOperations.create(); machine2.name = "Nuova Simonelli Talento"
            
            _ = Observable.of(
                newBrew(.CoffeeMachine, coffee: coffee5, machine: machine1, attributes: [20, 25, 96, 34, 26]),
                newBrew(.CoffeeMachine, coffee: coffee5, machine: machine2, attributes: [20, 23, 97, 34, 26]),
                newBrew(.PourOverV60, coffee: coffee1, machine: nil, attributes: [36, 600, 91, 14, 121]),
                newBrew(.AeropressTraditional, coffee: coffee2, machine: nil, attributes: [18, 250, 90, 10, 90]),
                newBrew(.PourOverChemex, coffee: coffee3, machine: nil, attributes: [48, 800, 87, 18, 300]),
                newBrew(.AeropressInverted, coffee: coffee4, machine: nil, attributes: [18, 104, 88, 12, 120])
                )
                .merge()
                .flatMap {
                    _ in stack.save()
                }
                .subscribe()
        #endif
    }
    
    fileprivate func newBrew(_ method: BrewMethod, coffee: Coffee?, machine: CoffeeMachine?, attributes: [Double]) -> Observable<Brew> {
        let brewModelController = assembler.resolver.resolve(BrewModelControllerType.self)!
        return brewModelController
            .createNewBrew(withMethod: method, coffee: coffee, coffeeMachine: machine)
            .flatMap {
                brew in
                return Observable<Brew>.zip(
                    brewModelController.createNewBrewAttribute(forType: .CoffeeWeight),
                    brewModelController.createNewBrewAttribute(forType: .WaterWeight),
                    brewModelController.createNewBrewAttribute(forType: .WaterTemperature),
                    brewModelController.createNewBrewAttribute(forType: .GrindSize),
                    brewModelController.createNewBrewAttribute(forType: .Time)
                ) {
                    coffeeWeight, waterWeight, waterTemperature, grindSize, time in
                    let attributesArray: [BrewAttribute] = [coffeeWeight, waterWeight, waterTemperature, grindSize, time]
                    attributesArray.enumerated().forEach { $1.value = attributes[$0] }
                    brew.brewAttributes = NSSet(array: attributesArray)
                    return brew
                }
            }
            .do(onNext: {
                brew in
                brew.isFinished = true
                brew.score = 5.0 + Double(arc4random_uniform(5000)) / 1000.0
                brew.cuppingAttributes?.map { $0 as! Cupping }.forEach {
                    $0.value = 5.0 + Double(arc4random_uniform(5000)) / 1000.0
                }
            })
    }
}
