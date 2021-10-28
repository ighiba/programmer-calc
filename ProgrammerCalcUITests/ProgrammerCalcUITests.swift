//
//  ProgrammerCalcUITests.swift
//  ProgrammerCalcUITests
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import XCTest

class ProgrammerCalcUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSettingsButton() throws {
        // 1. given
        let settingsButton = app.navigationBars.buttons["gearshape"]
        let tablesQuery = app.tables
        let darkModeRow = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Appearance"]/*[[".cells.matching(identifier: \"0\").staticTexts[\"Appearance\"]",".staticTexts[\"Appearance\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let tappingSoundsRow = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Tapping sounds"]/*[[".cells.matching(identifier: \"0\").staticTexts[\"Tapping sounds\"]",".staticTexts[\"Tapping sounds\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let hapticFeedbackRow = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Haptic feedback"]/*[[".cells[\"1\"].staticTexts[\"Haptic feedback\"]",".staticTexts[\"Haptic feedback\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let aboutAppRow = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["About app"]/*[[".cells.staticTexts[\"About app\"]",".staticTexts[\"About app\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                
        // 2. then
        settingsButton.tap()
        XCTAssertTrue(darkModeRow.exists)
        XCTAssertTrue(tappingSoundsRow.exists)
        XCTAssertTrue(hapticFeedbackRow.exists)
        XCTAssertTrue(aboutAppRow.exists)
    }
    
//    func testAboutView() throws {
//        // 1. given
//
//        let tablesQuery_About = app.tables
//        let descriptionRow = tablesQuery_About/*@START_MENU_TOKEN@*/.staticTexts["Description"]/*[[".cells.staticTexts[\"Description\"]",".staticTexts[\"Description\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//        let rateAppRow = tablesQuery_About/*@START_MENU_TOKEN@*/.staticTexts["Rate app"]/*[[".cells.staticTexts[\"Rate app\"]",".staticTexts[\"Rate app\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        let contactUsRow = tablesQuery_About/*@START_MENU_TOKEN@*/.staticTexts["Contact us"]/*[[".cells.staticTexts[\"Contact us\"]",".staticTexts[\"Contact us\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//
//
//
//        let settingsButton = app.navigationBars.buttons["gearshape"]
//        let tablesQuery_Settings = app.tables
//        let aboutAppRow = tablesQuery_Settings/*@START_MENU_TOKEN@*/.staticTexts["About app"]/*[[".cells.staticTexts[\"About app\"]",".staticTexts[\"About app\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//        // 2. then
//        settingsButton.tap()
//        XCTAssertTrue(aboutAppRow.exists)
//        aboutAppRow.tap()
//        XCTAssertTrue(descriptionRow.exists)
//        XCTAssertTrue(rateAppRow.exists)
//        XCTAssertTrue(contactUsRow.exists)
//        //descriptionRow.tap()
//
//    }
    
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
        let changeWordSizeButton = app.navigationBars/*@START_MENU_TOKEN@*/.staticTexts["BYTE"]/*[[".buttons[\"BYTE\"].staticTexts[\"BYTE\"]",".staticTexts[\"BYTE\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let tablesQuery = app.tables
        let qword = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["QWORD"]/*[[".cells.staticTexts[\"QWORD\"]",".staticTexts[\"QWORD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let dword = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["DWORD"]/*[[".cells.staticTexts[\"DWORD\"]",".staticTexts[\"DWORD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let word = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["WORD"]/*[[".cells.staticTexts[\"WORD\"]",".staticTexts[\"WORD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let byte = tablesQuery.staticTexts["BYTE"]
        let doneButton = app.buttons["Done"]
        
        // 2. then
        changeWordSizeButton.tap()
        XCTAssertTrue(qword.exists)
        XCTAssertTrue(dword.exists)
        XCTAssertTrue(word.exists)
        XCTAssertTrue(byte.exists)
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
