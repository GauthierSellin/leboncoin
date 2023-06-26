//
//  leboncoinUITests.swift
//  leboncoinUITests
//
//  Created by Gauthier Sellin on 23/06/2023.
//

import XCTest

private struct Constants {
    static let timeoutValue = 90.0
}

class leboncoinUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        //start app
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        XCUIApplication().terminate()
    }
    
    func testNominalWorkflow() throws {
        sleep(5)
        
        let rightNavBarButton = app.navigationBars.children(matching: .button).firstMatch
        waitUntilExist(element: rightNavBarButton)
        rightNavBarButton.tap()
        
        let categoryCell = app.tables.element(boundBy: 0).cells.element(boundBy: 3)
        waitUntilExist(element: categoryCell)
        categoryCell.tap()
        
        let productCell = app.tables.element(boundBy: 0).cells.element(boundBy: 1)
        waitUntilExist(element: productCell)
        productCell.tap()
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        waitUntilExist(element: backButton)
        backButton.tap()
    }
    
    func waitUntilExist(element: XCUIElement) {
        if !element.waitForExistence(timeout: Constants.timeoutValue) {
            XCTFail("required element not found")
        }
    }
}
