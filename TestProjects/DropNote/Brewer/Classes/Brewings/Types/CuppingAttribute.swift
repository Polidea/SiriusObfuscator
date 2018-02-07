//
//  CuppingAttribute.swift
//  Brewer
//
//  Created by Maciej Oczko on 06.08.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum CuppingAttribute: Int32 {
    case aroma
    case acidity
    case aftertaste
    case balance
    case body
    case sweetness
    case overall
    
    static let allValues = [aroma, acidity, aftertaste, balance, body, sweetness, overall]
}

extension CuppingAttribute: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .aroma: return tr(.cuppingAttributeAroma)
        case .acidity: return tr(.cuppingAttributeAcidity)
        case .aftertaste: return tr(.cuppingAttributeAftertaste)
        case .balance: return tr(.cuppingAttributeBalance)
        case .body: return tr(.cuppingAttributeBody)
        case .sweetness: return tr(.cuppingAttributeSweetness)
        case .overall: return tr(.cuppingAttributeOverall)
        }
    }
}
