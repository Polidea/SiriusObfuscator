//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// a wrapper over the reflection APIs providing a one-stop shop for all the things PlaygroundLogger needs

final class LoggerMirror {
    private let mirror: Mirror

    private var object: Any?
    private var text: String?
    private var superclassMirror: (Bool, LoggerMirror?)
    private var typeNameData: String?
    private var displayTypeNameData: String?
    private var quickLookData: PlaygroundQuickLook?? = nil
    
    private static let Swift_Stdlib_Regex = Regex(pattern: "(?<!\\.)\\b(Swift\\.)")
    
    static func reflect(_ x: Any) -> LoggerMirror {
        return LoggerMirror(object: x)
    }
    
    private init(object x: Any) {
        self.object = x
        self.mirror = Mirror(reflecting: x)
        self.superclassMirror = (false,nil)
    }
    
    private init(object x: Any, label: String?) {
        self.object = x
        self.mirror = Mirror(reflecting: x)
        self.text = label
        self.superclassMirror = (false,nil)
    }

    private init(mirror x: Mirror, _ label: String?) {
        self.object = nil
        self.mirror = x
        self.text = label
        self.superclassMirror = (false,nil)
    }
    
    var count: Int {
        let direct_count = self.mirror.children.count
        let base_count: Int64 = (nil == self.superclass ? 0 : 1)
        return Int(direct_count+base_count)
    }
    
    var superclass: LoggerMirror? {
        if !self.superclassMirror.0 {
            if let sm = self.mirror.superclassMirror {
                self.superclassMirror.1 = LoggerMirror(mirror: sm, "super")
            }
            self.superclassMirror.0 = true
        }
        return self.superclassMirror.1
    }
    
    subscript(x: Int) -> LoggerMirror {
        get {
            var actualIndex: Int = x
            // this will abort if called on an invalid child - call at own risk
            if let sm = self.superclass {
                if x == 0 { return sm }
                else { actualIndex = actualIndex - 1 }
            }
            let startIndex = self.mirror.children.startIndex
            let index = self.mirror.children.index(startIndex, offsetBy:Int64(actualIndex))
            let child = self.mirror.children[index]
            return LoggerMirror(object: child.value, label: child.label)
        }
    }
    
    var value: Any {
        return object
    }
    
    var valueType: Any.Type {
        return self.mirror.subjectType
    }
    
    var typeName: String {
        if typeNameData == nil {
            typeNameData = _typeName(valueType)
        }
        return typeNameData ?? ""
    }
    
    var displayTypeName: String {
        guard let regex = LoggerMirror.Swift_Stdlib_Regex else { return typeName }
        if displayTypeNameData == nil {
            displayTypeNameData = regex.replace(in: typeName, with: "")
        }
        return displayTypeNameData ?? ""
    }
    
    var label: String? {
        return text
    }
    
    var debugDescription: String {
        guard let obj = object else { return "" }
        if let str = obj as? String {
            return str
        }
        return String(reflecting: obj)
    }
    
    var description: String {
        guard let obj = object else { return "" }
        if let str = obj as? String {
            return str
        }
        return String(describing: obj)
    }
    
    var displayStyle: Mirror.DisplayStyle {
        if let ds = self.mirror.displayStyle { return ds }
        else { return .`struct` }
    }
    
    var quickLookObject: PlaygroundQuickLook? {
        if let prefetched = quickLookData {
            return prefetched
        }
        guard let obj = object else { return nil }
        quickLookData = nil
        let cpql = PlaygroundQuickLook(reflecting: obj)
        switch cpql {
        case .text( _):
            if (obj as? CustomPlaygroundQuickLookable) != nil {
                quickLookData = cpql
            } else {
                // ignore .Text quicklook data that doesn't come from a CustomPlaygroundQuickLookable as that is a synthetized conformance
            }
        default:
            quickLookData = cpql
        }
        return quickLookData ?? nil
    }
    
    var isCustomPrintable: Bool {
        get {
            guard let obj = object else { return false }
            if obj is CustomDebugStringConvertible { return true }
            if obj is CustomStringConvertible { return true }
            if displayStyle == .`enum` { return true }
            return false
        }
    }

    var isEnumWithoutCustomConformace: Bool {
        get {
            guard let obj = object else { return false }
            if displayStyle != .enum { return false }
            if obj is CustomDebugStringConvertible { return false }
            if obj is CustomStringConvertible { return false }
            return true
        }
    }
    
    func getSummaries() -> (type_name: String, summary : String) {
        var tuple : (type_name : String, summary : String) = (displayTypeName, displayTypeName)
        if isEnumWithoutCustomConformace {
            tuple.summary = description
        }
        else if isCustomPrintable {
            tuple.summary = debugDescription
        }
        
        if let _ = quickLookObject?.getStringIfAny() {
            if tuple.summary.length > 1024 {
                if let trunc = tuple.summary.substr(from: 0, len: 1024) {
                    tuple.summary = trunc
                }
            }
        }
        
        return tuple
    }
    
    func unwrapOptionality() -> LoggerMirror {
        guard let _ = object else { return self }
        if displayStyle == .optional && count == 1 {
            Woodchuck.chuck {
                return Woodchuck.LogEntry("object is .Some mirror, delving deeper")
            }
            return self[0].unwrapOptionality()
        }
        return self
    }
}
