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
    class func wOV9nyUd86Qlf5q6JPku6WMytwaLHltD() -> NSPredicate {
        return NSPredicate(format: "FALSEPREDICATE")
    }

    class func SJuLI2foJ21JIoX_FbtpcpJldhrtH4ij() -> NSPredicate {
        return NSPredicate(format: "TRUEPREDICATE")
    }
}

extension Float {
    func do8HfppNcrCjI8Gd1jlMdxnSAPGB4ePD(_ _V7bWdGOiDCY_mt8gGdkgDATrgBBCXHV: String) -> String {
        return String(format: "%\(_V7bWdGOiDCY_mt8gGdkgDATrgBBCXHV)f", self)
    }
}

extension Double {
    func vrJ9PczfT8fFqlpPaoahG1lls85gfGKW(_ jcRTUo4dNn4XHFytY4K1WBtFYYFfMnB6: String) -> String {
        return String(format: "%\(jcRTUo4dNn4XHFytY4K1WBtFYYFfMnB6)f", self)
    }
}

extension Collection {    
    func elements<T>(ofType hOA93MlTxzC8ANrKQkn3B_Zv0QghFyMW: T.Type) -> [T] {
        return self.filter { $0 is T }.map { $0 as! T }
    }
}
