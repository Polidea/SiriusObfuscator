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

extension Float : Serializable {
    
    func toBytes() -> [UInt8] {
        var udPtr = UnsafeMutablePointer<Float>.allocate(capacity: 1)
        defer { udPtr.deallocate(capacity: 1) }
        udPtr.pointee = self
        let ubPtr = UnsafeMutableRawPointer(udPtr)
        var arr = Array<UInt8>(repeating: 0, count: 4)
        4.doFor {
            arr[$0] = ubPtr.load(fromByteOffset: $0, as: UInt8.self)
        }
        return arr
    }
    
    
    init? (storage: BytesStorage) {
        var ubPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        defer { ubPtr.deallocate(capacity: 4) }
        4.doFor {
            ubPtr[$0] = storage.get()
        }
        let udPtr = UnsafeMutableRawPointer(ubPtr).bindMemory(
            to: Float.self, capacity: 1)
        self = udPtr.pointee
    }
    
}

