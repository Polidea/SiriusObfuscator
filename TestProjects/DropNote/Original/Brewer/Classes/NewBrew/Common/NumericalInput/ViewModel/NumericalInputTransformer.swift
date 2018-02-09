//
// Created by Maciej Oczko on 20.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

protocol NumericalInputTransformerType {
    func initialString() -> String
    func transform(withRange range: NSRange, replacementString string: String) -> String
}

extension InputTransformer {
    
    static func temperatureTransformer() -> NumericalInputTransformerType {
        return InputTransformer(maximumDigitsCount: 5, separatorIndex: 5, separator: ".")
    }

    static func numberTransformer() -> NumericalInputTransformerType {
        return InputTransformer(maximumDigitsCount: 5, separatorIndex: 4, separator: ".")
    }

    static func timeTransformer() -> NumericalInputTransformerType {
        return InputTransformer(maximumDigitsCount: 4, separatorIndex: 2, separator: ":")
    }
}

final class InputTransformer: NumericalInputTransformerType {
    fileprivate var digits = [Int]()
    fileprivate let maximumDigitsCount: Int
    fileprivate let separatorIndex: Int
    fileprivate let separator: Character

    init(maximumDigitsCount count: Int, separatorIndex index: Int, separator character: Character) {
        maximumDigitsCount = count
        separatorIndex = index
        separator = character
    }

    func initialString() -> String {
        var string = ""
        for _ in 0..<maximumDigitsCount {
            string += "0"
        }
        return formatResult(string)
    }

    func transform(withRange range: NSRange, replacementString string: String) -> String {
        if shouldAppendDigit(range) {
            if let intValue = Int(string) {
                digits.append(intValue)
            } else {
                digits.append(0)
            }
        }

        if shouldRemoveDigit(range) && !digits.isEmpty {
            digits.removeLast()
        }

        let result = digitsCopyWithFilledZeros()
            .map(String.init)
            .joined(separator: "")

        return formatResult(result)
    }

    // MARK: Helpers

    fileprivate func shouldAppendDigit(_ range: NSRange) -> Bool {
        return digits.count <= maximumDigitsCount && range.length == 0
    }

    fileprivate func shouldRemoveDigit(_ range: NSRange) -> Bool {
        return range.length != 0
    }

    fileprivate func digitsCopyWithFilledZeros() -> [Int] {
        var stringable = digits
        while stringable.count < maximumDigitsCount {
            stringable.insert(0, at: 0)
        }
        return stringable
    }
    
    fileprivate func formatResult(_ result: String) -> String {
        let numberRepresentation = Double(insertSeparator(".", toString: result))!
        return numberRepresentation
            .format(".\(maximumDigitsCount - separatorIndex)")
            .replacingOccurrences(of: ".", with: String(separator))
    }

    fileprivate func insertSeparator(_ separator: Character, toString string: String) -> String {
        let index = string.characters.index(string.startIndex, offsetBy: separatorIndex)
        var mutableString = String(string)
        mutableString.insert(separator, at: index)
        return mutableString
    }
}
