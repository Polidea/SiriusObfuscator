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

extension UInt64 : Serializable {
	static let largeNumMarker : UInt8 = 0xFF
	
	func toBytes() -> [UInt8] {
		if (self < UInt64(UInt64.largeNumMarker)) {
			return [ UInt8(self) ]
		}

		var ret = Array<UInt8>()
        ret.append(UInt64.largeNumMarker)
        var up_int = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        defer { up_int.deallocate(capacity: 1) }
		up_int.pointee = self
        var up_byte = UnsafeRawPointer(up_int)
        8.doFor {
			ret.append(up_byte.load(as: UInt8.self))
			up_byte += 1
		}
		return ret
	}

    func toEightBytes() -> [UInt8] {
        var ret = Array<UInt8>()
        var up_int = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        defer { up_int.deallocate(capacity: 1) }
        up_int.pointee = self
        var up_byte = UnsafeRawPointer(up_int)
        8.doFor {
            ret.append(up_byte.load(as: UInt8.self))
            up_byte += 1
        }
        return ret
    }
    
    init? (storage : BytesStorage) {
		let byte0 = storage.get()
		if (byte0 == UInt64.largeNumMarker) {
            if let x = UInt64(eightBytesStorage: storage) {
                self = x
            } else {
                return nil
            }
		} else {
			self = UInt64(byte0)
		}
	}

    init? (eightBytesStorage: BytesStorage) {
        if !eightBytesStorage.has(8) { return nil }
		var up_byte = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
        defer { up_byte.deallocate(capacity: 8) }
        8.doFor {
            up_byte[$0] = eightBytesStorage.get()
        }
        let up_int: UnsafePointer<UInt64> = UnsafeRawPointer(up_byte).bindMemory(
            to: UInt64.self, capacity: 1)
		self = up_int.pointee
    }
}
