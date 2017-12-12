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

class PlaygroundWriter {
    var stream : BytesStream
    
    // this is the version of the PlaygroundLogger protocol
    // this needs to be changed if anyhthing in the encoding changes
    // in such a way that it would break existing consumers
    static let version : UInt8 = 10
    
    init() {
        stream = BytesStream()
    }
    
    func encode(range: SourceRange) {
        stream.write(range.begin.line.toEightBytes())
        stream.write(range.begin.col.toEightBytes())
        stream.write(range.end.line.toEightBytes())
        stream.write(range.end.col.toEightBytes())
    }
    
    func encodeConfigInfo() {
        #if os(OSX) || os(iOS) || os(tvOS)
            stream.write(UInt8(1))
            let tid : mach_port_t = pthread_mach_thread_np(pthread_self())
            stream.write("tid").write("\(tid)")
        #else
            stream.write(UInt8(0))
        #endif
    }
    
    func encode(header: SourceRange) {
        stream.write(PlaygroundWriter.version)
        encode(range: header)
        encodeConfigInfo()
    }
}

