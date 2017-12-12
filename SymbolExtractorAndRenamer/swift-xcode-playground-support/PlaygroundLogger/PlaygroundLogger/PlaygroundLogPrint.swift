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

// this does not need @_silgen_name() nor public, since it will be fed to the stdlib via a function pointer
func playground_logger_print_hook(_ x: String) -> Void {
    let buffer = ThreadLocalStorage<NSString>(key: "swiftPrintBuffer")
    buffer.Data = NSString(string: x)
}

@_silgen_name("playground_log_postprint") public
func playground_log_postprint (_ startline: Int,
                               _ endline: Int,
                               _ startcolumn: Int,
                               _ endcolumn: Int) -> NSData {
    let range = (begin: (line: UInt64(startline), col: UInt64(startcolumn)), end: (line: UInt64(endline), col: UInt64(endcolumn)))
    let buffer = ThreadLocalStorage<NSString>(key: "swiftPrintBuffer")
    if let string = buffer.Data {
#if APPLE_FRAMEWORKS_AVAILABLE
        let logdata = playground_log_impl(string, "", range)
#else
        let logdata = playground_log_impl(string.bridge(), "", range)
#endif
        buffer.Data = nil
        return logdata
    }
    // return an empty string if nothing interesting can be said here
    return playground_log_impl(LoggerDefaults.DefaultPostprintResult,"", range)
}
