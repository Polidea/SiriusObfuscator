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

/// This function has been deprecated. Instead, set `PlaygroundPage.current.needsIndefiniteExecution` to the appropriate value.
@available(*,deprecated,message:"Set 'PlaygroundPage.current.needsIndefiniteExecution' from the 'PlaygroundSupport' module instead")
public func XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: Bool = true) {
    XCPlaygroundPage.currentPage.needsIndefiniteExecution = continueIndefinitely
}

/// This function has been deprecated. Instead, check `PlaygroundPage.current.needsIndefiniteExecution` to see if indefinite execution has been requested.
@available(*,deprecated,message:"Use 'PlaygroundPage.current.needsIndefiniteExecution' from the 'PlaygroundSupport' module instead")
public func XCPExecutionShouldContinueIndefinitely() -> Bool {
    return XCPlaygroundPage.currentPage.needsIndefiniteExecution
}
