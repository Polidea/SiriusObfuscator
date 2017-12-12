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

import Foundation

enum QuickLookEncoding {
    case Array([UInt8]) // Swift objects are very well stored as array of bytes
    case Buffer(Data) // ObjC objects usually are easy to write to an NSData
    
    var count : UInt64 {
    get {
        switch (self) {
        case .Array(let x): return UInt64(x.count)
        case .Buffer(let x): return UInt64(x.count)
        }
    }
    }
}

struct QuickLookEncodedObject : CustomStringConvertible
{
    var repr_type : String
    var repr_data : QuickLookEncoding
    
    init(_ repr_type: String, _ repr_data: QuickLookEncoding) {
        self.repr_type = repr_type
        self.repr_data = repr_data
    }
    
    var description: String {
        return "repr_type: \(repr_type) worth \(repr_data.count) bytes"
    }
}

enum QuickLookingResult : CustomStringConvertible {
    case Success(QuickLookEncodedObject) // we succeeded: here's the data
    case Failure(String?) // we failed: I might have more to say about it
    
    init(_ ql: QuickLookEncodedObject) {
        self = .Success(ql)
    }

    init (_ ex: NSException) {
        self = .Failure(ex.description)
    }
    
    init () {
        self = .Failure(nil)
    }
    
    init (_ m: String) {
        self = .Failure(m)
    }
    
    init (_ r: String, _ d: QuickLookEncoding) {
        self = .Success(QuickLookEncodedObject(r,d))
    }
    
    init (_ r: String, _ d: NSData) {
        self = .Success(QuickLookEncodedObject(r,.Buffer(d as Data)))
    }

    init (_ r: String, _ d: Data) {
        self = .Success(QuickLookEncodedObject(r,.Buffer(d)))
    }
    
    init (_ r: String, _ a: [UInt8]) {
        self = .Success(QuickLookEncodedObject(r,.Array(a)))
    }
    
    init (_ r: String, _ a: LoggerArchiver.ArchiverState) {
        switch (a) {
        case .Buffer(let d): self = .Success(QuickLookEncodedObject(r,.Buffer(d)))
        case .Exception(let except): self = .Failure(except.description)
        }
    }
    
    var description: String {
        switch self {
        case .Success(let ql_obj): return "Success(\(ql_obj))"
        case .Failure(let msg): return "Failure(\(msg))"
        }
    }
}

