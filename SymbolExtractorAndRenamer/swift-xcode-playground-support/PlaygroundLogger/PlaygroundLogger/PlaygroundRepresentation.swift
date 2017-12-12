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

enum PlaygroundRepresentation : UInt8, Hashable, Serializable, CustomStringConvertible, Equatable {
    case Class = 1
    case Struct = 2
    case Tuple = 3
    case Enum = 4
    case Aggregate = 5
    case Container = 6
    case IDERepr = 7
    case Gap = 8
    case ScopeEntry = 9
    case ScopeExit = 10
    case Error = 11
    case IndexContainer = 12
    case KeyContainer = 13
    case MembershipContainer = 14
    case Unknown = 0xFF
	
	func toBytes() -> [UInt8] {
		return [ self.rawValue ]
	}
	
	init (byte: UInt8) {
        if let repr = PlaygroundRepresentation(rawValue: byte) {
            self = repr
        } else {
            self = .Unknown
        }
	}
    
    init? (storage : BytesStorage) {
        self = PlaygroundRepresentation(byte: storage.get())
    }
    
	var hashValue : Int {
        return Int(self.rawValue)
	}
    
    var description: String {
        switch self {
        case .Class: return "Class"
        case .Struct: return "Struct"
        case .Tuple: return "Tuple"
        case .Enum: return "Enum"
        case .Aggregate: return "Aggregate"
        case .Container: return "Container"
        case .IDERepr: return "IDERepr"
        case .Gap: return "Gap"
        case .ScopeEntry: return "ScopeEntry"
        case .ScopeExit: return "ScopeExit"
        case .Error: return "Error"
        case .IndexContainer: return "IndexContainer"
        case .KeyContainer: return "KeyContainer"
        case .MembershipContainer: return "MembershipContainer"
        default: return "Unknown"
        }
    }
    
    init(_ x: Mirror.DisplayStyle)
    {
        switch (x) {
        case .`class`: self = .Class
        case .`struct`: self = .Struct
        case .tuple: self = .Tuple
        case .`enum`: self = .Enum
        case .optional: self = .Aggregate
        case .collection: self = .IndexContainer
        case .dictionary: self = .KeyContainer
        case .set: self = .MembershipContainer
        default: self = .Unknown
        }
    }
}
