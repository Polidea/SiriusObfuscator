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

class PlaygroundScopeWriter : PlaygroundWriter {
    func encode(scope: ScopeEvent, range: SourceRange) {
        encode(header: range)
        stream.write("") // empty name field - maybe we can use it some day, just keep it consistent for now
        stream.write(PlaygroundRepresentation(scope: scope))
    }
}

