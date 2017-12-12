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

public typealias LoggerClosure = () -> ()

private
func playgroundLogWithPolicy(_ policy: LoggingLevelPolicy, _ f : LoggerClosure) {
    LoggingPolicyStack.get().push(policy)
    f()
    LoggingPolicyStack.get().pop()
}

public
func playground_log_default (_ f: LoggerClosure) {
    playgroundLogWithPolicy(LoggingLevelPolicy_Default(), f)
}

public
func playground_log_never (_ f : LoggerClosure) {
    playgroundLogWithPolicy(LoggingLevelPolicy_Never(), f)
}

public
func playground_log_adaptive (_ f : LoggerClosure) {
    playgroundLogWithPolicy(LoggingLevelPolicy_Adaptive(), f)
}
