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

struct ArraySink <T> {
    typealias Element = T;
    var elements: Array<T>
    var i = 0
    
    init(count: Int, element: T) {
        elements = Array(repeating: element, count: count)
    }
    
    mutating func put(_ x: T) {
        if i >= elements.capacity {
            elements.reserveCapacity(2 * i)
        }
        if i >= elements.count {
            elements.append(x)
        } else {
            elements[i] = x
        }
        i += 1
    }
    
    func get() -> [T] {
        return [T](elements[0..<i])
    }
}

extension String : Serializable {
	func toBytesAndSize() -> [UInt8] {
		var bas = ArraySink<UInt8>(count: self.byteLength, element: 0)
        let len = UInt64(self.byteLength).toBytes()
        for byte in len {
            bas.put(byte)
        }
        return bas.elements + Array(self.utf8)
	}
    
    func toBytes() -> [UInt8] {
      return Array(self.utf8)
    }
    
    init (rawBytes: [UInt8]) {
        self = rawBytes.withUnsafeBufferPointer { (storage : UnsafeBufferPointer<UInt8>) in
            return String._fromCodeUnitSequenceWithRepair(UTF8.self, input: storage).0
        }
    }
    
    init? (storage: BytesStorage) {
		var str_bytes = Array<UInt8>()
        guard let count = UInt64(storage: storage) else { return nil }
        if count == 0 {
            self = ""
        } else {
            if !storage.has(count) { return nil }
            count.doFor {
                let byte = storage.get()
                str_bytes.append(byte)
            }
            self = String(rawBytes: str_bytes)
        }
	}
    
    init? (fullBytesStorage: BytesStorage) {
        var str_bytes = Array<UInt8>()
        while fullBytesStorage.has(1) {
            let byte = fullBytesStorage.get()
            str_bytes.append(byte)
        }
        self = String(rawBytes: str_bytes)
    }
}


extension String {
    var byteLength: Int {
        return self.utf8.count
    }

    var length: Int {
        return self.characters.count
    }

    func substr(from: Int, len: Int? = nil) -> String? {
        if from >= length { return nil }
        if let l = len {
            if from + l >= length { return nil }
            return NSString(string: self).substring(with: NSRange(location: from, length: l)) as String
        } else {
            return NSString(string: self).substring(from: from)
        }
    }
}

extension String {
    var range: NSRange {
        return NSRange(location: 0, length: self.length)
    }
}

extension String {
    func find(_ x: String) -> Int? {
        let nsstring = NSString(string: self)
        let range = nsstring.range(of: x)
        if range.location == NSNotFound {
            return nil
        }
        return range.location
    }

    func separateDottedPair() -> (String,String)? {
        if let dotpos = self.find(".") {
            return (self.substr(from: 0, len: dotpos)!, self.substr(from: dotpos+1)!)
        }
        return nil
    }
}
