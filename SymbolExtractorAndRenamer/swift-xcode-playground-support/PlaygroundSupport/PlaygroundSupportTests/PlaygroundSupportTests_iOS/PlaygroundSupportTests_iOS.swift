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

import XCTest
import PlaygroundSupport

class PlaygroundTests_iOS: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        PlaygroundPage.current.liveView = nil
        super.tearDown()
    }
    
    func testLiveViewWithView() {
        let view = UIView()
        
        // Test setting to a view
        expectation(forNotification: "PlaygroundPageLiveViewDidChangeNotification", object: PlaygroundPage.current) { (notification) in
            guard let userInfoView = notification.userInfo?["PlaygroundPageLiveView"] as? UIView else { return false }
            guard notification.userInfo?["PlaygroundPageLiveViewController"] == nil else { return false }
            XCTAssertEqual(userInfoView, view)
            return true
        }
        PlaygroundPage.current.liveView = view
        waitForExpectations(withTimeout: 0.1, handler: nil)
        
        // Test setting back to nil
        expectation(forNotification: "PlaygroundPageLiveViewDidChangeNotification", object: PlaygroundPage.current) { (notification) in
            guard notification.userInfo?["PlaygroundPageLiveView"] == nil else { return false }
            guard notification.userInfo?["PlaygroundPageLiveViewController"] == nil else { return false }
            return true
        }
        PlaygroundPage.current.liveView = nil
        waitForExpectations(withTimeout: 0.1, handler: nil)
    }
    
    func testLiveViewWithViewController() {
        let viewController = UIViewController()
        
        // Test setting to a view controller
        expectation(forNotification: "PlaygroundPageLiveViewDidChangeNotification", object: PlaygroundPage.current) { (notification) in
            guard let userInfoViewController = notification.userInfo?["PlaygroundPageLiveViewController"] as? UIViewController else { return false }
            guard notification.userInfo?["PlaygroundPageLiveView"] == nil else { return false }
            XCTAssertEqual(userInfoViewController, viewController)
            return true
        }
        PlaygroundPage.current.liveView = viewController
        waitForExpectations(withTimeout: 0.1, handler: nil)
        
        // Test setting back to nil
        expectation(forNotification: "PlaygroundPageLiveViewDidChangeNotification", object: PlaygroundPage.current) { (notification) in
            guard notification.userInfo?["PlaygroundPageLiveView"] == nil else { return false }
            guard notification.userInfo?["PlaygroundPageLiveViewController"] == nil else { return false }
            return true
        }
        PlaygroundPage.current.liveView = nil
        waitForExpectations(withTimeout: 0.1, handler: nil)
    }
}
