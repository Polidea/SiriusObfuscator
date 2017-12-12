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

#if os(OSX)
import AppKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif

/// `XCPShowView` has been deprecated. Instead, set `XCPlaygroundPage.liveView` to the appropriate value.
#if os(OSX)
@available(*,deprecated,message:"Set 'PlaygroundPage.current.liveView' from the 'PlaygroundSupport' module instead")
public func XCPShowView(identifier: String, view: NSView) {
    guard XCPlaygroundPage.currentPage.liveView == nil else { fatalError("Presenting multiple live views is not supported") }
    XCPlaygroundPage.currentPage.liveView = view
}
#elseif os(iOS) || os(tvOS)
@available(*,deprecated,message:"Set 'PlaygroundPage.current.liveView' from the 'PlaygroundSupport' module instead")
public func XCPShowView(identifier: String, view: UIView) {
    guard XCPlaygroundPage.currentPage.liveView == nil else { fatalError("Presenting multiple live views is not supported") }
    XCPlaygroundPage.currentPage.liveView = view
}
#endif
