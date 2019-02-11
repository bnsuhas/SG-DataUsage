//
//  SG_DataUsageUITests.swift
//  SG-DataUsageUITests
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import XCTest

class SG_DataUsageUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVolumeDecreasedButtonHidden() {
        
        let app = XCUIApplication()
        let cell = app.tables.cells.containing(.staticText, identifier:"Year: 2005").element
        app.tables.element.scrollToElement(element: cell)
        let button = cell.buttons["volumeDropButton"]
        XCTAssertFalse(button.visible())
    }
    
    func testVolumeDecreasedButtonVisible() {
        
        let app = XCUIApplication()
        let cell = app.tables.cells.containing(.staticText, identifier:"Year: 2011").element
        app.tables.element.scrollToElement(element: cell)
        let button = cell.buttons["volumeDropButton"]
        XCTAssertTrue(button.visible())
    }
    
    func testVolumeDecreaseButtonTap() {
        let app = XCUIApplication()
        let cell = app.tables.cells.containing(.staticText, identifier:"Year: 2011").element
        app.tables.element.scrollToElement(element: cell)
        cell.buttons["volumeDropButton"].tap()
        XCTAssertNotNil(app.alerts["Volume Dropped"]) 
    }
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
