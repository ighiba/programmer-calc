//
//  BinaryTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 30.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class BinaryTests: XCTestCase {
    
    let storage = CalculatorStorage()
    
    var binaryTest: Binary!
    var binaryStrInput: String = "1100" // dec = 12
    
    let unsignedData = CalcState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    let signedData = CalcState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
    
    let calcState: CalcState = CalcState.shared
    
    override func setUp() {
        super.setUp()
        binaryTest = Binary()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        storage.saveData(dummyConversionSettings)
    }
    
    override func tearDown() {
        binaryTest = nil
        super.tearDown()
    }
    
    // XCTAssert to test model
    func testBinaryUnsignedInit() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        
        // 2. when
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "0000000000000000000000000000000000000000000000000000000000001100", "Converted values are wrong")
    }
    
    func testBinarySignedInit() throws {
        // 1. given
        calcState.setCalcState(signedData)
        
        // 2. when
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "0000000000000000000000000000000000000000000000000000000000001100", "Converted values are wrong")
    }
    
    func testToBinary() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        binaryTest = binaryTest.toBinary()
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "0000000000000000000000000000000000000000000000000000000000001100", "Converted values are wrong")
    }
    
    func testBinaryChangeSignedBit() throws {
        // 1. give
        calcState.setCalcState(signedData)
        let bit: Character = "1"
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        binaryTest.changeSignedBit(to: bit)
        binaryTest.updateSignedState()
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "1000000000000000000000000000000000000000000000000000000000001100", "Converted values are wrong")
    }
    
    func testBinaryDivide() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        binaryTest = binaryTest.divideBinary(by: 4)

        // 3. then
        XCTAssertEqual(binaryTest.value, "0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 1100", "No spaces inserted")
    }
    
    func testBinaryRemoveAllSpaces() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        binaryTest = binaryTest.divideBinary(by: 4)
        
        // 2. when
        let removedSpaces = binaryTest.value.removedAllSpaces()

        // 3. then
        XCTAssertEqual(removedSpaces, "0000000000000000000000000000000000000000000000000000000000001100", "Spaces not deleted")
    }
    
    func testBinaryRemoveZerosBefore() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let removedZerosBefore = binaryTest.removeZerosBefore(str: binaryTest.value)

        // 3. then
        XCTAssertEqual(removedZerosBefore, "1100", "Zeros before not removed")
    }
    
    func testBinaryRemoveZerosAfter() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: "\(binaryStrInput).0100")
        // 2. when
        let removedZerosAfter = binaryTest.removeZerosAfter(str: binaryTest.value)

        // 3. then
        XCTAssertEqual(removedZerosAfter, "0000000000000000000000000000000000000000000000000000000000001100.01", "Zeros after not removed")
    }
    
    func testBinaryAppendDigitToUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        binaryTest = Binary(stringLiteral: "01001100")
        
        // 2. when
        binaryTest.appendDigit("1")

        // 3. then
        XCTAssertEqual(binaryTest.value, "10011001", "Digit not appended")
    }
    
    func testBinaryAppendDigitToSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: "01001100")
        
        // 2. when
        binaryTest.appendDigit("1")

        // 3. then
        XCTAssertEqual(binaryTest.value, "0000000000000000000000000000000000000000000000000000000010011001", "Digit not appended")
    }
    
    func testBinaryToDecSignedPlus() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        
        // 3. then
        XCTAssertEqual(decValue.decimalValue, 12, "Wrong conversion")
    }

    func testBinaryToDecSignedMinus() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        binaryTest.changeSignedBit(to: "1")
        binaryTest.updateSignedState()
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        
        // 3. then
        XCTAssertEqual(decValue.decimalValue, -9223372036854775796 as Decimal, "Wrong conversion")
    }
    
    func testBinaryToDecUnsignedPlus() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        
        // 3. then
        XCTAssertEqual(decValue.decimalValue, 12, "Wrong conversion")
    }

    func testBinaryToDecUnsignedMinus() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        binaryTest = Binary(stringLiteral: "01001100")
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        
        // 3. then
        XCTAssertEqual(decValue.decimalValue, 76, "Wrong conversion")
    }
    
    func testBinaryConvertDoubleTo() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        let binaryInt: Binary.IntPart = "12"
        let binaryFract: Binary.FractPart = "25"

        // 2. when
        binaryTest.value = binaryTest.convertDoubleToBinaryStr(numberStr: (binaryInt, binaryFract))
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "01100.0100000000000000", "Wrong conversion")
    }
    
    func testConvertIntToBinary() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        let intValue = 12

        // 2. when
        binaryTest.value = binaryTest.convertIntToBinary(intValue)
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "01100", "Wrong conversion")
    }
    
    func testBinaryInvert() throws {
        // 1. given
        calcState.setCalcState(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        binaryTest.invert()
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "1111111111111111111111111111111111111111111111111111111111110011", "Wrong inversion")
    }
}
