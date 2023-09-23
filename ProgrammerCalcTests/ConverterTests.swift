//
//  ConverterTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 31.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class ConverterTests: XCTestCase {
    
    let storage = CalculatorStorage()
    
    var converterTest: Converter?
    let binaryStrInput = "1100"
    
    let unsignedData = CalcState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    let signedData = CalcState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
    
    let wordSize: WordSize = WordSize.shared
    let calcState: CalcState = CalcState.shared
    
    let qword = WordSize(.qword)
    let dword = WordSize(.dword)
    let word = WordSize(.word)
    let byte = WordSize(.byte)
    
    override func setUp() {
        super.setUp()
        converterTest = Converter()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        storage.saveData(dummyConversionSettings)
        
    }
    
    override func tearDown() {
        converterTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOnesComplementUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: binaryStrInput) // 1100
        
        // 2. when
        let converted = converterTest!.toOnesComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110011", "Converted values are wrong")
    }
    
    func testOnesComplementSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let converted = converterTest!.toOnesComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110011", "Converted values are wrong")
    }
    
    func testTwosComplementUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let converted = converterTest!.toTwosComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110100", "Converted values are wrong")
    }
    
    func testTwosComplementSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let converted = converterTest!.toTwosComplement(value: binary, mainSystem: .bin)
        
        // 3. then
        XCTAssertEqual(converted.value, "11110100", "Converted values are wrong")
    }
    
    
}
