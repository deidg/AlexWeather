//
//  AlexWeatherUITests.swift
//  AlexWeatherUITests
//
//  Created by Alex on 16.05.2023.
//

import XCTest

final class AlexWeatherUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
    }
    
    func testInfoButton() throws {
        let app = XCUIApplication()
        app.launch()
    
        let infoButton = app.buttons["INFO"]
        XCTAssertTrue(infoButton.exists)
        
        infoButton.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Hide"].staticTexts["Hide"]/*[[".buttons[\"Hide\"].staticTexts[\"Hide\"]",".staticTexts[\"Hide\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
    }
        
    func testCitySearchAndUpdateBySwiping() throws {
        let app = XCUIApplication()
        app.launch()
        
        let iconSearchButton = app.buttons["icon search"]
        iconSearchButton.tap()
 
        let enterCityNameTextField = app.textFields["Enter city name"]
        enterCityNameTextField.typeText("Portland")
        enterCityNameTextField.tap()
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        cell.tap()
 
        let element = app.scrollViews.children(matching: .other).element(boundBy: 0)
        element.tap()
    }

    func testCitySearchAndUpdateByLocationButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let iconSearchButton = app.buttons["icon search"]
        iconSearchButton.tap()

        let enterCityNameTextField = app.textFields["Enter city name"]
        enterCityNameTextField.typeText("London")
        enterCityNameTextField.tap()
        
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        cell.tap()

        app.buttons["icon location"].tap()
    }
    
    func testCitySearchAndCloseButton() throws {
        let app = XCUIApplication()
        app.launch()
    
        let iconSearchButton = app.buttons["icon search"]
        iconSearchButton.tap()
        
        app.buttons["close"].tap()
    }
    
}
