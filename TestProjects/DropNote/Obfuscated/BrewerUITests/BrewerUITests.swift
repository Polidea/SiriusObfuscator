//
//  BrewerUITests.swift
//  BrewerUITests
//
//  Created by Maciej Oczko on 31.07.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import XCTest

class BrewerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    
        let app = XCUIApplication()
        app.launchArguments = ["use_mock_data"]
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // It's used for fastlane snapshot purposes
    func testExample() {        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        snapshot("01MethodPicker")
        tabBarsQuery.buttons["Select Second"].tap()
        snapshot("02History")
        tabBarsQuery.buttons["Select Third"].tap()
        snapshot("03Settings")
        XCTAssert(true)
    }
    
}
