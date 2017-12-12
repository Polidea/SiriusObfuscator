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

// On Apple platforms, SwiftExceptionSafety is used to turn ObjC-based throws into an exception return which Swift code then can handle without crashing
// On non-Apple platforms, there is no ObjC runtime throwing things around, so provide a hollow stub to keep other code happy with minimal #ifs

class NSException {
    var description: String {
        return "NSException"
    }
}

class SwiftExceptionSafety {
    class func doTry (_ f: () -> ()) -> NSException? {
        f()
        return nil
    }
}

