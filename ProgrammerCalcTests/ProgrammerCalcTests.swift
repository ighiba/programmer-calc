//
//  ProgrammerCalcTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import XCTest
@testable import ProgrammerCalc

class ProgrammerCalcTests: XCTestCase {
    
    var binaryTest: Binary!
    var binaryStrInput: String = "1100" // dec = 12
    
    override func setUp() {
        super.setUp()
        binaryTest = Binary()
    }
    
    override func tearDown() {
        binaryTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // XCTAssert to test model
    func testBinaryUnsignedInit() throws {
        // 1. given
        let data = CalcState(mainState: "0", convertState: "0", processSigned: false)
        
        // 2. when
        SavedData.calcState = data
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "1100", "Converted values are wrong")
    }
    
    func testBinarySignedInit() throws {
        // 1. given
        let data = CalcState(mainState: "0", convertState: "0", processSigned: true)
        
        // 2. when
        SavedData.calcState = data
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "00001100", "Converted values are wrong")
    }
    
    func testBinaryChangeSignedBit() throws {
        // 1. given
        let data = CalcState(mainState: "0", convertState: "0", processSigned: true)
        let bit: Character = "1"
        
        // 2. when
        SavedData.calcState = data
        binaryTest = Binary(stringLiteral: binaryStrInput)
        binaryTest.changeSignedBit(to: bit)
        binaryTest.updateSignedState()
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "10001100", "Converted values are wrong")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
