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

func playground_log_impl<T>(_ object : T, _ name : String, _ range: SourceRange) -> NSData {
    Woodchuck.chuck {
        return Woodchuck.LogEntry("LoggerDefaults.MaxLevelsOfDepth = \(LoggerDefaults.MaxLevelsOfDepth), LoggerDefaults.Capping_Aggregates = \(LoggerDefaults.Capping_Aggregates), LoggerDefaults.Capping_Containers = \(LoggerDefaults.Capping_Containers)")
    }
    let encoder = PlaygroundObjectWriter(LoggerDefaults.MaxLevelsOfDepth, LoggerDefaults.Capping_Aggregates, LoggerDefaults.Capping_Containers)
    _ = encoder.encodeObject(object, name, range)
    return encoder.stream.data
}

@_silgen_name("playground_log_hidden") public
func playground_log<T>(_ object: T,
                       _ name: String,
                       _ ID: Int,
                       _ startline: Int,
                       _ endline: Int,
                       _ startcolumn: Int,
                       _ endcolumn: Int) -> NSData {
    
    let range = (begin: (line: UInt64(startline), col: UInt64(startcolumn)), end: (line: UInt64(endline), col: UInt64(endcolumn)))
    
    let policy = LoggingPolicyStack.get().peek()
    if policy.proceed(ID) {
        Woodchuck.chuck {
            return Woodchuck.LogEntry("logging policy \(policy) allows logging to proceed")
        }
        return policy.update(ID,playground_log_impl(object, name, range))
    }
    else {
        Woodchuck.chuck {
            return Woodchuck.LogEntry("logging policy \(policy) prevents logging - gap emitted instead")
        }
        return playground_log_gap(name, range)
    }
}
