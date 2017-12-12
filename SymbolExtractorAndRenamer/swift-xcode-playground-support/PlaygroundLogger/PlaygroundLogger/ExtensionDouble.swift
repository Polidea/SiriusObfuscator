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

extension Double : Serializable {
    
    func toBytes() -> [UInt8] {
        var udPtr = UnsafeMutablePointer<Double>.allocate(capacity: 1)
        defer { udPtr.deallocate(capacity: 1) }
        udPtr.pointee = self
        let ubPtr = UnsafeMutableRawPointer(udPtr)
        var arr = Array<UInt8>(repeating: 0, count: 8)
        8.doFor {
            arr[$0] = ubPtr.load(fromByteOffset: $0, as: UInt8.self)
        }
        return arr
    }
    
    
    init? (storage: BytesStorage) {
        var ubPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
        defer { ubPtr.deallocate(capacity: 8) }
        8.doFor {
            ubPtr[$0] = storage.get()
        }
        let udPtr = UnsafeMutableRawPointer(ubPtr).bindMemory(
            to: Double.self, capacity: 1)
        self = udPtr.pointee
    }
    
}

