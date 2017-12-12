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
//

import Foundation

@_silgen_name("playground_log_scope_entry") public
func playground_log_scope_entry(_ startline: Int,
                                _ endline: Int,
                                _ startcolumn: Int,
                                _ endcolumn: Int) -> NSData {
    let range = (begin: (line: UInt64(startline), col: UInt64(startcolumn)), end: (line: UInt64(endline), col: UInt64(endcolumn)))
    let encoder = PlaygroundScopeWriter()
    encoder.encode(scope: .ScopeEntry, range: range)
    return encoder.stream.data
}

@_silgen_name("playground_log_scope_exit") public
func playground_log_scope_exit(_ startline: Int,
                               _ endline: Int,
                               _ startcolumn: Int,
                               _ endcolumn: Int) -> NSData {
    let range = (begin: (line: UInt64(startline), col: UInt64(startcolumn)), end: (line: UInt64(endline), col: UInt64(endcolumn)))
    let encoder = PlaygroundScopeWriter()
    encoder.encode(scope: .ScopeExit, range: range)
    return encoder.stream.data
}

