//
//  SelectableSearchIdentifier.swift
//  Brewer
//
//  Created by Maciej Oczko on 07.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum SelectableSearchIdentifier: String {
    case Coffee
    case CoffeeMachine
}

extension SelectableSearchIdentifier: CustomStringConvertible {
    var description: String {
        switch self {
        case .Coffee: return tr(.selectableSearchCoffeeItemTitle)
        case .CoffeeMachine: return tr(.selectableSearchCoffeeMachineItemTitle)
        }
    }
}
