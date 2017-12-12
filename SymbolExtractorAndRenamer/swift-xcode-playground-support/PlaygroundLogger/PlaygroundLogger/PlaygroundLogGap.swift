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

func playground_log_gap(_ name: String,
                        _ range: SourceRange) -> NSData {
    let encoder = PlaygroundGapWriter()
    encoder.encode(gap: name, range: range)
    return encoder.stream.data
}

