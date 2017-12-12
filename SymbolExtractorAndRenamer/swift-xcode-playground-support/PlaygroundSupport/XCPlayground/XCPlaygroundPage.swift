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

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// The URL for the directory where data which is shared between all playgrounds may be stored.
///
/// This directory is at the path `~/Documents/Shared Playground Data/`.
/// This directory must already exist to be usable by playgrounds; Xcode will *not* create it for you.
@available(*,deprecated,message:"Use 'PlaygroundSharedDataDirectoryURL' from the 'PlaygroundSupport' module instead")
public let XCPlaygroundSharedDataDirectoryURL: NSURL = {
    if let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        return NSURL(fileURLWithPath: documentsDirectory + "/Shared Playground Data/")
    }
    return NSURL(fileURLWithPath: ("~/Documents/Shared Playground Data/" as NSString).expandingTildeInPath)
}()

/// `XCPlaygroundPage` provides a collection of methods and properties which represent the state of a playground page and
/// which allow the code in a playground page to interact with Xcode.
///
/// This includes things like capturing values into the page's timeline, controlling the page's execution lifecycle, and
/// setting up a live view for the page.
public final class XCPlaygroundPage {
    /// Returns the `XCPlaygroundPage` instance representing the current page in the playground.
    public static let currentPage: XCPlaygroundPage = XCPlaygroundPage()

    /// The initializer used to create XCPlaygroundPage.currentPage.
    private init() {}

    /// Captures the given `value` and passes it to Xcode, where it is displayed in a timeline item along with other values captured with the given `identifier`.
    ///
    /// - note: This function has been deprecated. 
    @available(*,deprecated) public func captureValue<T>(value: T, withIdentifier identifier: String) {
        if let value = value as? AnyObject {
            NotificationCenter.default.post(name: "XCPCaptureValue" as NSString as NSNotification.Name, object: self, userInfo: [ "value" : value, "identifier": identifier as AnyObject])
        }
    }

    /// Indicates whether the playground page needs to execute indefinitely.
    /// The default value of this property is `false`, but playground pages with live views will automatically set this to `true`.
    ///
    /// If set to `true`, this tells Xcode that the playground page should continue to run once it reaches the end of top-level code.
    /// If set to `false`, Xcode will kill the playground page when it has finished executing top-level code.
    ///
    /// Setting this after the playground page has reached the end of top-level code has no effect.
    /// Instead, use `XCPlaygroundPage.finishExecution()` to indicate to Xcode execution is done and the page should stop executing.
    ///
    /// - note: This is the replacement for the `XCPExecutionShouldContinueIndefinitely` and `XCPSetExecutionShouldContinueIndefinitely` APIs.
    @available(*,deprecated,message:"Use 'PlaygroundPage.current.needsIndefiniteExecution' from the 'PlaygroundSupport' module instead")
    public var needsIndefiniteExecution: Bool = false {
        didSet {
            NotificationCenter.default.post(name: "XCPlaygroundPageNeedsIndefiniteExecutionDidChangeNotification" as NSString as NSNotification.Name, object: self, userInfo: [ "XCPlaygroundPageNeedsIndefiniteExecution" : needsIndefiniteExecution as AnyObject])
        }
    }

    /// Instructs Xcode that the playground page has finished execution.
    ///
    /// This method does not return, as Xcode will kill the process hosting playground execution when this method is called.
    @available(*,deprecated,message:"Use 'PlaygroundPage.current.finishExecution()' from the 'PlaygroundSupport' module instead")
    public func finishExecution() -> Never {
        // Send a message to Xcode requesting that we be killed.
        NotificationCenter.default.post(name: "XCPlaygroundPageFinishExecutionNotification" as NSString as NSNotification.Name, object: self, userInfo: nil)
    
        // Sleep for a while to let Xcode kill us.
        for _ in 1...10 {
            sleep(60)
        }

        // If Xcode doesn't kill us before we stop sleeping, just exit on our own.
        exit(0)
    }

    /// The live view currently being displayed by Xcode on behalf of the playground page, or nil if there is no live view.
    ///
    /// Setting this property to a non-nil value will cause the live view to become visible, and implies setting `XCPlaygroundPage.needsIndefiniteExecution` to `true`.
    /// Setting this property to nil will cause Xcode to dismiss the live view.
    ///
    /// - note: This is nil by default.
    @available(*,deprecated,message:"Use 'PlaygroundPage.current.liveView' from the 'PlaygroundSupport' module instead")
    public var liveView: XCPlaygroundLiveViewable? = nil {
        didSet {
            if liveView != nil {
                // Setting a live view enables implies a need for indefinite execution.
                needsIndefiniteExecution = true
            }
            
            let userInfo: [AnyHashable: Any]
            
            if let liveView = liveView {
                switch liveView.playgroundLiveViewRepresentation() {
                case .ViewController(let viewController):
                    userInfo = ["XCPlaygroundPageLiveViewController" : viewController]
                case .View(let view):
                    userInfo = ["XCPlaygroundPageLiveView" : view]
                }
            }
            else {
                if oldValue == nil {
                    // Don't send a notification if we just went from nil to nil.
                    return
                }
                
                userInfo = [:]
            }

            NotificationCenter.default.post(name: "XCPlaygroundPageLiveViewDidChangeNotification" as NSString as NSNotification.Name, object: self, userInfo: userInfo)
        }
    }
}

/// An enum describing the supported representations for live views in playgrounds.
public enum XCPlaygroundLiveViewRepresentation {
#if os(iOS) || os(tvOS)
    /// A view which will be displayed as the live view.
    ///
    /// - note: This view must be the root of a view hierarchy (i.e. it must not have a superview), and it must *not* be owned by a view controller.
    case View(UIView)

    /// A view controller whose view will be displayed as the live view.
    ///
    /// - note: This view controller must be the root of a view controller hierarchy (i.e. it has no parent view controller), and its view must *not* have a superview.
    case ViewController(UIViewController)

#elseif os(OSX)
    /// A view which will be displayed as the live view.
    ///
    /// - note: This view must be the root of a view hierarchy (i.e. it must not have a superview), and it must *not* be owned by a view controller.
    case View(NSView)

    /// A view controller whose view will be displayed as the live view.
    ///
    /// - note: This view controller must be the root of a view controller hierarchy (i.e. it has no parent view controller), and its view must *not* have a superview.
    case ViewController(NSViewController)

#endif
}

/// A protocol for types which can be displayed as the live view for a playground page.
///
/// On iOS and tvOS, `UIView` and `UIViewController` conform to this protocol.
/// Likewise, on OS X, `NSView` and `NSViewController` conform to this protocol.
///
/// Implement this protocol if your custom type should be usable as the "live view" for a playground page.
public protocol XCPlaygroundLiveViewable {
    /// Returns the `XCPlaygroundLiveViewRepresentation` for the receiver.
    ///
    /// The value returned from this method can but does not need to be the same every time; XCPlaygroundLiveViewables may choose to create a new view or view controller every time.
    ///
    /// - seealso: `XCPlaygroundLiveViewRepresentation`
    func playgroundLiveViewRepresentation() -> XCPlaygroundLiveViewRepresentation
}

#if os(iOS) || os(tvOS)
extension UIView: XCPlaygroundLiveViewable {
    public func playgroundLiveViewRepresentation() -> XCPlaygroundLiveViewRepresentation {
        return .View(self)
    }
}

extension UIViewController: XCPlaygroundLiveViewable {
    public func playgroundLiveViewRepresentation() -> XCPlaygroundLiveViewRepresentation {
        return .ViewController(self)
    }
}
#elseif os(OSX)
extension NSView: XCPlaygroundLiveViewable {
    public func playgroundLiveViewRepresentation() -> XCPlaygroundLiveViewRepresentation {
        return .View(self)
    }
}

extension NSViewController: XCPlaygroundLiveViewable {
    public func playgroundLiveViewRepresentation() -> XCPlaygroundLiveViewRepresentation {
        return .ViewController(self)
    }
}
#endif
