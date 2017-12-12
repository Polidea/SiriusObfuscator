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

enum NestedDataCappingPolicy : CustomStringConvertible {
    typealias Count = UInt64
    typealias Percentage = UInt8
    case All // log everything
    case Head(Count) // log [0,count-1]
    case HeadTail(Count, Percentage) // if size < count, log all else log head% at the head of the container and 100-head% at the tail of the container
    case None // don't log any children
    
    var description: String {
        switch (self) {
        case .All:
            return ".All"
        case .Head(let count):
            return ".Head(\(count as UInt64))" // the cast appeases the type-checker here
        case .HeadTail(let count, let head):
            return ".HeadTail(\(count),\(head))"
        case .None:
            return ".none"
        }
    }
}

protocol LoggingLevelPolicy : CustomStringConvertible {
    func proceed (_ ID: Int) -> Bool
    func update (_ ID: Int, _ data: NSData) -> NSData
}

class LoggingLevelPolicy_Default : LoggingLevelPolicy {
    func proceed (_ ID: Int) -> Bool { return true }
    func update (_ ID: Int, _ data: NSData) -> NSData { return data }
    var description : String = "Default"
}

class LoggingLevelPolicy_Never : LoggingLevelPolicy {
    func proceed (_ ID: Int) -> Bool { return false }
    func update (_ ID: Int, _ data: NSData) -> NSData { return data }
    var description : String = "Never"
}

class LoggingLevelPolicy_Adaptive : LoggingLevelPolicy {
    private let threshold: Int
    
    init() {
        self.threshold = LoggerDefaults.MaxAdaptiveCountPerID
    }
    
    init (_ t: Int) {
        self.threshold = t
    }

    func proceed (_ ID: Int) -> Bool {
        return proceed(NSNumber(value: ID))
    }
    
    func update (_ ID: Int, _ data: NSData) -> NSData {
        return update(NSNumber(value: ID), data)
    }
    
    func proceed (_ ID: NSNumber) -> Bool {
        let consumedAmountTLS: ThreadLocalStorage<NSMutableDictionary> = ThreadLocalStorage(key: "PlaygroundLogger_AdaptiveLoggingStats")
        if consumedAmountTLS.Data == nil {
            consumedAmountTLS.Data = NSMutableDictionary()
        }
        if let consumedAmounts = consumedAmountTLS.Data {
            if let consumedAmount = (consumedAmounts.object(forKey: ID) as? NSNumber) {
                return (consumedAmount.intValue < threshold)
            }
        }
        // something weird is happening.. just keep going
        return true
    }
    
    var description : String { return "Adaptive(\(threshold) bytes)" }
    
    func update (_ ID: NSNumber, _ data: NSData) -> NSData {
        let consumedAmountTLS: ThreadLocalStorage<NSMutableDictionary> = ThreadLocalStorage(key: "PlaygroundLogger_AdaptiveLoggingStats")
        if consumedAmountTLS.Data == nil {
            consumedAmountTLS.Data = NSMutableDictionary()
        }
        if let consumedAmounts = consumedAmountTLS.Data {
            if let consumedAmount = consumedAmounts.object(forKey: ID) as? NSNumber {
                consumedAmounts.setObject(NSNumber(value: consumedAmount.intValue + data.length), forKey: ID)
            } else {
                consumedAmounts.setObject(NSNumber(value: data.length), forKey: ID)
            }
        }
        return data
    }
}

// FIXME: I picked some default values for these defaults - are they sensible?
struct LoggerDefaults {
    // max two levels of children
    static var MaxLevelsOfDepth : UInt64 = 2
    
    // if logging a struct type log everything up to 10k elements
    static var Capping_Aggregates : NestedDataCappingPolicy = .Head(10000)
    
    // if logging a container type then log up to a 100, if the size is greater then log 80% off the head and 20% off the tail
    static var Capping_Containers : NestedDataCappingPolicy = .HeadTail(100,80)
    
    // if Adaptive logging is on, how much data should we store before giving up and emitting gaps
    static var MaxAdaptiveCountPerID : Int = 5242880
    
    // the logger's very own logger
    static var LoggerLogger = Woodchuck.InstanceData()
    
    // the thing that logger_postprint returns if no data was ever stored
    static var DefaultPostprintResult = ""
}
