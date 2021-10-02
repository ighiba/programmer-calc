//
//  OctalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 31.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class OctalTests: XCTestCase {
    
    // Storages
    var conversionStorage: ConversionStorageProtocol? = ConversionStorage()
    var calcStatetorage: CalcStateStorageProtocol? = CalcStateStorage()
    
    var octalTest: Octal!
    var octalStrInput: String = "357" // dec = 239
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    override func setUp() {
        super.setUp()
        octalTest = Octal()
        let dummyConversionSettings = ConversionSettings(systMain: "Decimal", systConverter: "Octal", number: 8.0)
        conversionStorage?.saveData(dummyConversionSettings)
        
    }
    
    override func tearDown() {
        octalTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // XCTAssert to test model
    func testOctalUnsignedInit() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        
        // 2. when
        octalTest = Octal(stringLiteral: octalStrInput)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalSignedInit() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        
        // 2. when
        octalTest = Octal(stringLiteral: octalStrInput)
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalBinaryUnsignedInit() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binary = Binary(stringLiteral: "011101111")
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalBinarySignedInit() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binary = Binary(stringLiteral: "011101111")
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalBinarySignedInitWithMinus() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binary = Binary(stringLiteral: "1000000011101111")
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "100357", "Converted values are wrong")
    }
    
    func testOctalBinaryUnsignedInitWithMinus() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binary = Binary(stringLiteral: "1000000011101111")
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "100357", "Converted values are wrong")
    }
    
    func testOctalCovnertToBinaryUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        octalTest = Octal(stringLiteral: octalStrInput)
        
        // 2. when
        let binary = octalTest.convertOctToBinary()
        
        // 3. then
        XCTAssertEqual(binary.value, "011101111", "Converted values are wrong")
    }
    
    func testOctalCovnertToBinarySigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        octalTest = Octal(stringLiteral: octalStrInput)
        
        // 2. when
        let binary = octalTest.convertOctToBinary()
        
        // 3. then
        XCTAssertEqual(binary.value, "11101111", "Converted values are wrong")
    }
    
    
    
}
