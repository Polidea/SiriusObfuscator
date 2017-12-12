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

// “How much logging could a PlaygroundLogger log if a PlaygroundLogger could log logs"

import Foundation

private extension NSDate {
    func toShortString() -> String {
        let f = DateFormatter()
        f.locale = nil
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f.string(from: self as Date)
    }
}

enum Woodchuck {
    struct LogEntry: CustomStringConvertible {
        let message: String
        
        var description: String {
            return "[\(getpid())] @ \(NSDate().toShortString()): \(message)"
        }
        
        init (_ message: String) {
            self.message = message
        }
    }
    
    typealias LogClosure = () -> LogEntry
    
    struct OutputStream_Stdout : WoodchuckOutputStream {
        func write(_ s: Woodchuck.LogClosure)
        {
            print(s().description)
        }
    }
    
    struct OutputStream_DevNull : WoodchuckOutputStream {
        func write(_ s: Woodchuck.LogClosure)
        {
        }
    }
    
    static func chuck (_ s: LogClosure)
    {
        LoggerDefaults.LoggerLogger.output.write(s)
    }
    
    class InstanceData {
        var output: WoodchuckOutputStream
        
        init() {
                if Environment.get(variable: "PLAYGROUNDLOGGER_WOODCHUCK") != nil {
                    self.output = OutputStream_Stdout()
                } else {
                    self.output = OutputStream_DevNull()
            }
        }
    }
}

protocol WoodchuckOutputStream {
    func write (_ s: Woodchuck.LogClosure)
}
