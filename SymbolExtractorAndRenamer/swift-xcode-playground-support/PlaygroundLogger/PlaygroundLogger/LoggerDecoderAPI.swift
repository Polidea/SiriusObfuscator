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

// LoggerDecoder is not meant for public consumption, is not complete
// and is distinct from the decoder logic used by Xcode - the purpose
// of this decoding API is to enable testing of PlaygroundLogger

import Foundation

public class PlaygroundDecodedLogEntry {
    let version: UInt64
    let range: SourceRange
    let header: [String: String]
    let object: PlaygroundDecodedObject
    
    init (version: UInt64,
          startLine: UInt64,
          startColumn: UInt64,
          endLine: UInt64,
          endColumn: UInt64,
          header: [String: String],
          object: PlaygroundDecodedObject) {
        self.version = version
        self.range = SourceRange(begin: (line: startLine, col: startColumn), end: (line: endLine, col: endColumn))
        self.header = header
        self.object = object
    }
    
    func print<T: TextOutputStream>(to stream: inout T) {
        Swift.print("Version: \(version)", to: &stream)
        Swift.print("\(header.count) header entries", to: &stream)
        for (key,value) in header {
            Swift.print("\t\(key) = \(value)", to: &stream)
        }
        object.print(&stream,0)
    }
    
    public func toString() -> String {
        var s = ""
        print(to: &s)
        return s
    }
}

@_silgen_name("playground_log_decode") public
func playground_log_decode(_ object : NSData) -> PlaygroundDecodedLogEntry? {
    return PlaygroundDecoder(BytesStorage(object)).decode()
}

