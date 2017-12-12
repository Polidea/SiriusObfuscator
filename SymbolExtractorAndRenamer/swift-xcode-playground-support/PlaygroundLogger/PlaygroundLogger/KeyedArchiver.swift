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

final class LoggerArchiver {
    var archiver: NSKeyedArchiver
    var data: NSMutableData
    var exception: NSException?
    
    enum ArchiverState {
        case Buffer(Data)
        case Exception(NSException)
    }
    
    init() {
        data = NSMutableData()
        archiver = NSKeyedArchiver(forWritingWith:data)
        exception = nil
    }
    
    func archive(object: AnyObject) {
        archive(key: "root", object: object)
    }
    
    func archive(key: String, object: AnyObject) {
        self.exception = SwiftExceptionSafety.doTry {
            self.archiver.encode(object, forKey: key)
        }
    }
    
    func archive(double: Double) {
        archive(key: "root", double: double)
    }
    
    func archive(key: String, double: Double) {
        self.exception = SwiftExceptionSafety.doTry {
            self.archiver.encode(double, forKey: key)
        }
    }
    
    func archive(bool: Bool) {
        archive(key: "root", bool: bool)
    }
    
    func archive(key: String, bool: Bool) {
        self.exception = SwiftExceptionSafety.doTry {
            self.archiver.encode(bool, forKey: key)
        }
    }
    
    func archive(int64: Int64) {
        archive(key: "root", int64: int64)
    }
    
    func archive(key: String, int64: Int64) {
        self.exception = SwiftExceptionSafety.doTry {
            self.archiver.encode(int64, forKey: key)
        }
    }
    
    func archive(uint64: UInt64) {
        archive(key: "root", uint64: uint64)
    }
    
    func archive(key: String, uint64: UInt64) {
        self.exception = SwiftExceptionSafety.doTry {
            self.archiver.encode(Int64(uint64), forKey: key)
        }
    }
    
    func archive(storage: BytesStorage) {
        archive(key: "root", storage: storage)
    }
    
    func archive(key: String, storage: BytesStorage) {
        self.exception = SwiftExceptionSafety.doTry {
            self.archiver.encodeBytes(storage.bytes, length: storage.count, forKey: key)
        }
    }
    
    func finalize() {
        archiver.finishEncoding()
    }
    
    func getData() -> NSData {
        finalize()
        return data
    }
    
    func getException() -> NSException? {
        finalize()
        return exception
    }
    
    // preferred accessor unless you know for sure that you did/did not cause an exception
    func getState() -> ArchiverState {
        finalize()
        if let except = exception {
            return .Exception(except)
        }
        return .Buffer(data as Data)
    }
}
