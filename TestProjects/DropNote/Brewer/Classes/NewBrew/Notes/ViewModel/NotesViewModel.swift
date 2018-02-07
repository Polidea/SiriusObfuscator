//
//  NotesViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 19.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NotesViewModelType {
    var notes: Variable<String?> { get }
}

final class NotesViewModel: NotesViewModelType {
    fileprivate let disposeBag = DisposeBag()
    let brewModelController: BrewModelControllerType
    
    fileprivate(set) var notes: Variable<String?> = Variable("")
    
    init(brewModelController: BrewModelControllerType) {
        self.brewModelController = brewModelController
        notes.value = brewModelController.currentBrew()?.notes ?? ""
        notes.asDriver().map { $0 ?? "" }.drive(onNext: setNotesToBrew).addDisposableTo(disposeBag)
    }
    
    fileprivate func setNotesToBrew(_ notes: String) {
        brewModelController.currentBrew()?.notes = notes
    }
}
