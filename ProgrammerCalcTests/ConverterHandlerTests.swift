//
//  ConverterHandlerTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 31.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class ConverterHandlerTests: XCTestCase {
    
    // Storages
    var conversionStorage: ConversionStorageProtocol? = ConversionStorage()
    var calcStatetorage: CalcStateStorageProtocol? = CalcStateStorage()
    let wordSizeStorage: WordSizeStorageProtocol? = WordSizeStorage()
    
    var converterHandlerTest: ConverterHandler?
    let binaryStrInput = "1100"
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    override func setUp() {
        super.setUp()
        converterHandlerTest = ConverterHandler()
        let dummyConversionSettings = ConversionSettings(systMain: "Decimal", systConverter: "Binary", number: 8.0)
        conversionStorage?.saveData(dummyConversionSettings)
        
    }
    
    override func tearDown() {
        converterHandlerTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // XCTAssert to test model
    func testOnesComplementUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        wordSizeStorage?.saveData(WordSize(8))
        let binary = Binary(stringLiteral: binaryStrInput) // 1100
        
        // 2. when
        let converted = converterHandlerTest!.toOnesComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110011", "Converted values are wrong")
    }
    
    func testOnesComplementSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSizeStorage?.saveData(WordSize(8))
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let converted = converterHandlerTest!.toOnesComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110011", "Converted values are wrong")
    }
    
    func testTwosComplementUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        wordSizeStorage?.saveData(WordSize(8))
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let converted = converterHandlerTest!.toTwosComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110100", "Converted values are wrong")
    }
    
    func testTwosComplementSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSizeStorage?.saveData(WordSize(8))
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let converted = converterHandlerTest!.toTwosComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110100", "Converted values are wrong")
    }
    
    
}
