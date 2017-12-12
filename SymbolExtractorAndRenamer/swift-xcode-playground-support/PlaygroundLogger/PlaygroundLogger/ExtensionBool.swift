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

extension Bool : Serializable {
    func toBytes() -> [UInt8] {
        return [self ? 1 : 0]
    }
    
    init? (storage: BytesStorage) {
        let b = storage.get()
        if b == 1 { self = true }
        else if b == 0 { self = false }
        else { return nil }
    }
}
