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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        //DescriptionView
        let infoButton = app.buttons["INFO"]
        XCTAssertTrue(infoButton.exists)
        
        infoButton.tap()

        app/*@START_MENU_TOKEN@*/.buttons["Hide"].staticTexts["Hide"]/*[[".buttons[\"Hide\"].staticTexts[\"Hide\"]",".staticTexts[\"Hide\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()

        let iconSearchButton = app.buttons["icon search"]
        iconSearchButton.tap()
        // first city search
        let enterCityNameTextField = app.textFields["Enter city name"]
        enterCityNameTextField.typeText("Portland")
        enterCityNameTextField.tap()

        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        cell.tap()
        // update data by vertical swiping stoneImage
        let element = app.scrollViews.children(matching: .other).element(boundBy: 0)
        element.tap()

        //second city search
        iconSearchButton.tap()
        enterCityNameTextField.tap()
        enterCityNameTextField.typeText("London")
        cell.tables.children(matching: .cell).element(boundBy: 0)
        
        cell.tap()
        app.buttons["icon location"].tap()
        
        iconSearchButton.tap()
        app.buttons["close"].tap()
    }
    
}
