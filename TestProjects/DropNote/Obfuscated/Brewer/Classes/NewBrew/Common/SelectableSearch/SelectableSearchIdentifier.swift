//
//  SelectableSearchIdentifier.swift
//  Brewer
//
//  Created by Maciej Oczko on 07.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum flhRd7pwiw7CARx6LbncF57oUCFzQPEE: String {
    case Coffee
    case CoffeeMachine
}

extension flhRd7pwiw7CARx6LbncF57oUCFzQPEE: CustomStringConvertible {
    var description: String {
        switch self {
        case .Coffee: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.selectableSearchCoffeeItemTitle)
        case .CoffeeMachine: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.selectableSearchCoffeeMachineItemTitle)
        }
    }
}
