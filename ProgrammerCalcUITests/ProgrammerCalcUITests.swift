//
//  ProgrammerCalcUITests.swift
//  ProgrammerCalcUITests
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import XCTest
import ProgrammerCalc

class ProgrammerCalcUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testMainViewController() throws {
        // 1. given
        let scrollViewsQuery = app.scrollViews
        
        let mainButtons = ["AC", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "=", "+", "+", "-", "×", "÷"]
        let additionalButtons = ["00", "FF", "A", "B", "C", "D", "E", "F", "1's", "2's", "X<<Y", "X>>Y", "<<", ">>", "AND", "OR", "XOR", "NOR"]
        
        let buttonsFirstPage: [XCUIElement] = mainButtons.map { scrollViewsQuery.otherElements.buttons[$0] }
        let buttonsSecondPage: [XCUIElement] = additionalButtons.map { scrollViewsQuery.otherElements.buttons[$0] }
        
        // 2. then
        // Test main buttons existing
        for button in buttonsFirstPage {
            XCTAssert(button.exists)
            button.tap()
        }
        
        // Scroll to additional page
        let startPoint = scrollViewsQuery.element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let endPoint = scrollViewsQuery.element.coordinate(withNormalizedOffset: CGVector(dx: 1.0, dy: 1.0))
        startPoint.press(forDuration: 0, thenDragTo: endPoint)

        // Test additional buttons existing
        for button in buttonsSecondPage {
            XCTAssert(button.exists)
            button.tap()
        }
    }

    func testSettingsButton() throws {
        // 1. given
        let settingsButton = app.navigationBars.buttons["gearshape"]
        let tablesQuery = app.tables
        let darkModeRow = tablesQuery.staticTexts["Appearance"]
        let tappingSoundsRow = tablesQuery.staticTexts["Tapping sounds"]
        let hapticFeedbackRow = tablesQuery.staticTexts["Haptic feedback"]
        let aboutAppRow = tablesQuery.staticTexts["About app"]
                
        // 2. then
        settingsButton.tap()
        XCTAssertTrue(darkModeRow.exists)
        XCTAssertTrue(tappingSoundsRow.exists)
        XCTAssertTrue(hapticFeedbackRow.exists)
        XCTAssertTrue(aboutAppRow.exists)
    }
    
    func testAppearanceView() throws {
        // 1. given
        let settingsButton = app.navigationBars.buttons["gearshape"]
        let tablesQuery_Settings = app.tables
        let appearanceRow = tablesQuery_Settings.staticTexts["Appearance"]
        let tablesQuery_Appearance = app.tables
        let lightTheme = tablesQuery_Appearance.staticTexts["Light"]
        let darkTheme = tablesQuery_Appearance.staticTexts["Dark"]
        let oldSchoolTheme = tablesQuery_Appearance.staticTexts["Old School"]
        
        // 2. then
        settingsButton.tap()
        XCTAssertTrue(appearanceRow.exists)
        appearanceRow.tap()
        XCTAssertTrue(lightTheme.exists)
        XCTAssertTrue(darkTheme.exists)
        XCTAssertTrue(oldSchoolTheme.exists)
        lightTheme.tap()
        darkTheme.tap()
        oldSchoolTheme.tap()
        darkTheme.tap()
        app.navigationBars["Appearance"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
    }
    
    func testAboutView() throws {
        // 1. given
        let tablesQuery_About = app.tables
        let descriptionRow = tablesQuery_About.staticTexts["Description"]
        let rateAppRow = tablesQuery_About.staticTexts["Rate app"]
        let contactUsRow = tablesQuery_About.staticTexts["Contact us"]

        let settingsButton = app.navigationBars.buttons["gearshape"]
        let tablesQuery_Settings = app.tables
        let aboutAppRow = tablesQuery_Settings.staticTexts["About app"]

        // 2. then
        settingsButton.tap()
        XCTAssertTrue(aboutAppRow.exists)
        aboutAppRow.tap()
        XCTAssertTrue(descriptionRow.exists)
        XCTAssertTrue(rateAppRow.exists)
        XCTAssertTrue(contactUsRow.exists)
        descriptionRow.tap()
        app.navigationBars["Description"].buttons["About app"].tap()
        app.navigationBars["About app"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
    }
    
    func testChangeConversionButton() throws {
        // 1. given
        let changeConversionButton = app.navigationBars.buttons["sort"]
        let maxNumberOfDigitsAfterPointStaticText = app.staticTexts["Max number of digits after point: "]
        let containerHeader = app.staticTexts["Conversion settings"]
        let doneButton = app.buttons["Done"]
        
        // 2. then
        changeConversionButton.tap()
        XCTAssertTrue(maxNumberOfDigitsAfterPointStaticText.exists)
        XCTAssertTrue(containerHeader.exists)
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
    }
    
    func testChangeWordSizeButton() throws {
        // 1. given
        let changeWordSizeButton = app.buttons["ChangeWordSizeButton"]
        let tablesQuery = app.tables
        let qword = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["QWORD"]/*[[".cells.staticTexts[\"QWORD\"]",".staticTexts[\"QWORD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let dword = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["DWORD"]/*[[".cells.staticTexts[\"DWORD\"]",".staticTexts[\"DWORD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let word = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["WORD"]/*[[".cells.staticTexts[\"WORD\"]",".staticTexts[\"WORD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let byte = tablesQuery.staticTexts["BYTE"]
        let doneButton = app.buttons["Done"]
        
        // 2. then
        changeWordSizeButton.tap()
        XCTAssertTrue(qword.exists)
        qword.tap()
        XCTAssertTrue(dword.exists)
        dword.tap()
        XCTAssertTrue(word.exists)
        word.tap()
        XCTAssertTrue(byte.exists)
        byte.tap()
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
    }
    
    func testBitwiseKeypad() throws {
        // 1. given
        let scrollViewsQuery = app.scrollViews
        let firstResult = ["0","1","1","1","1","0","1","1"] // 123
        let secondResult = ["0","0","0","0","1","1","0","0"] // 12
        let thirdResult = ["0","0","0","0","0","0","0","1"] // 1
        
        var buttonsMain: [XCUIElement] = [
            scrollViewsQuery.otherElements.buttons["AC"],
            scrollViewsQuery.otherElements.buttons["1"],
            scrollViewsQuery.otherElements.buttons["2"],
            scrollViewsQuery.otherElements.buttons["3"],
        ]
        
        let bitButtons = (0 ..< 8).reversed().map { app.buttons["bitButton_\($0)"] }
        
        buttonsMain.forEach { $0.tap() } // input 123 (Dec) -> 0111 1011 (Bin)
        
        let bitwiseSwitch = XCUIApplication().navigationBars.children(matching: .button).element(boundBy: 1)

        // 2. then
        XCTAssert(bitwiseSwitch.exists)
        bitwiseSwitch.tap()
        
        bitButtons.forEach { XCTAssert($0.exists) }
        
        // check 0111 1011
        for i in 0..<8 {
            XCTAssert(bitButtons[i].label == firstResult[i])
        }

        // swipe to delete
        app.buttons["123"].swipeRight()

        // check 0000 1100
        for i in 0..<8 {
            XCTAssert(bitButtons[i].label == secondResult[i])
        }
        
        // swipe to delete
        app.buttons["12"].swipeRight()
        
        // check 0000 1100
        for i in 0..<8 {
            XCTAssert(bitButtons[i].label == thirdResult[i])
        }
    }
    
    func testDivByZeroErrorInLabels() throws {
        // 1. given
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.staticTexts["1"].tap()
        elementsQuery.buttons["÷"].tap()
        elementsQuery.staticTexts["0"].tap()
        elementsQuery.staticTexts["="].tap()

        // 2. then
        XCTAssert(NSLocalizedString("Cannot divide by zero", comment: "") == app.buttons["MainLabel"].label)
        XCTAssert(NSLocalizedString("NaN", comment: "") == app.buttons["ConverterLabel"].label)
    }
}
