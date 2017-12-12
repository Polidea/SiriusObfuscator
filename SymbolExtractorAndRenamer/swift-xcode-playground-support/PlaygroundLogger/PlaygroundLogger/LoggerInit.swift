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

/***
* Call this API before calling anything else in PlaygroundLogger
* If you fail to do that, then whatever fails to work is well deserved pain
***/
@_silgen_name("playground_logger_initialize") public
func playground_logger_initialize() {
    Swift._playgroundPrintHook = playground_logger_print_hook
    Woodchuck.chuck {
        return Woodchuck.LogEntry("PlaygroundLogger initialized correctly")
    }
}
