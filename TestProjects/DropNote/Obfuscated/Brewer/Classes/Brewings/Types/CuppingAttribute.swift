//
//  CuppingAttribute.swift
//  Brewer
//
//  Created by Maciej Oczko on 06.08.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum vrYgz8ae2jdaPI26N_gsmzoxFTBAI3Ze: Int32 {
    case aroma
    case acidity
    case aftertaste
    case balance
    case body
    case sweetness
    case overall
    
    static let MZ5qZ2sUdhe7B7ZckEUKczPCWSTRm1QJ = [aroma, acidity, aftertaste, balance, body, sweetness, overall]
}

extension vrYgz8ae2jdaPI26N_gsmzoxFTBAI3Ze: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .aroma: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.cuppingAttributeAroma)
        case .acidity: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.cuppingAttributeAcidity)
        case .aftertaste: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.cuppingAttributeAftertaste)
        case .balance: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.cuppingAttributeBalance)
        case .body: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.cuppingAttributeBody)
        case .sweetness: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.cuppingAttributeSweetness)
        case .overall: return Kkl9ZTHpGF5FUBju4Jnf6OcJ4oZUcQDv(.cuppingAttributeOverall)
        }
    }
}
