//
// Created by Maciej Oczko on 07.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

// swiftlint:disable empty_count
extension NSSet {
    var isEmpty: Bool {
        return count == 0
    }
}
// swiftlint:enalbe empty_count

extension NSPredicate {
    class func falsePredicate() -> NSPredicate {
        return NSPredicate(format: "FALSEPREDICATE")
    }

    class func truePredicate() -> NSPredicate {
        return NSPredicate(format: "TRUEPREDICATE")
    }
}

extension Float {
    func format(_ format: String) -> String {
        return String(format: "%\(format)f", self)
    }
}

extension Double {
    func format(_ format: String) -> String {
        return String(format: "%\(format)f", self)
    }
}

extension Collection {    
    func elements<T>(ofType type: T.Type) -> [T] {
        return self.filter { $0 is T }.map { $0 as! T }
    }
}
