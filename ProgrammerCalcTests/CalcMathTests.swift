//
//  CalcMathTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 03.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class CalcMathTests: XCTestCase {
    
    // Storages
    var conversionStorage: ConversionStorageProtocol? = ConversionStorage()
    var calcStatetorage: CalcStateStorageProtocol? = CalcStateStorage()
    
    
    var calcMathTest: CalcMath!
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    override func setUp() {
        super.setUp()
        calcMathTest = CalcMath()
        let dummyConversionSettings = ConversionSettings(systMain: "Decimal", systConverter: "Binary", number: 8.0)
        conversionStorage?.saveData(dummyConversionSettings)
        
    }
    
    override func tearDown() {
        calcMathTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFillUpBits() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let testValue = "10001100"
        
        // 2. when
        let result = calcMathTest.fillUpBits(str: testValue)
        
        // 3. then
        XCTAssertEqual(result, "0000000010001100", "Calaculation failure")
    }
    
    // MARK: - ADD
    
    // XCTAssert to test model
    func testCalcDecAdd() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .add, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "22", "Calaculation failure")
    }
    
    // MARK: - SUB
    
    func testCalcDecSub() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .sub, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "2", "Calaculation failure")
    }
    
    // MARK: - MUL
    
    func testCalcDecMul() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .mul, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "120", "Calaculation failure")
    }
    
    // MARK: - DIV
    
    func testCalcDecDiv() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .div, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "1.2", "Calaculation failure")
    }
    
    // MARK: - Negate
    
    func testBinNegateSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let bin = Binary(stringLiteral: "00010000") // 16
        
        // 2. when
        let result = calcMathTest.negate(value: bin, system: .bin)
        
        // 3. then
        XCTAssertEqual(result.value, "1111 0000", "Calaculation failure")
    }
    
    func testDecNegateSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let dec = DecimalSystem(stringLiteral: "12")
        
        // 2. when
        let result = calcMathTest.negate(value: dec, system: .dec)
        
        // 3. then
        XCTAssertEqual(result.value, "-12", "Calaculation failure")
    }
    
    func testOctNegateSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let oct = Octal(stringLiteral: "12") // 10
        
        // 2. when
        let result = calcMathTest.negate(value: oct, system: .oct)
        
        // 3. then
        XCTAssertEqual(result.value, "366", "Calaculation failure") // -10
    }
    
    func testHexNegateSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let hex = Hexadecimal(stringLiteral: "FEED") // -275
        
        // 2. when
        let result = calcMathTest.negate(value: hex, system: .hex)
        
        // 3. then
        XCTAssertEqual(result.value, "113", "Calaculation failure")
    }
    
    
    // MARK: - AND
    
    func testCalcDecUnsignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .and, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "8", "Calaculation failure")
    }
    
    func testCalcBinUnsignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binFirst = Binary(stringLiteral: "110001")
        let binSecond = Binary(stringLiteral: "101010")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "0010 0000", "Calaculation failure")
    }
    
    func testCalcHexUnsignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let hexFirst = Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "BEC8", "Calaculation failure")
    }
    
    func testCalcOctUnsignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let octFirst = Octal(stringLiteral: "357")
        let octSecond = Octal(stringLiteral: "123")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "103", "Calaculation failure")
    }
    
    func testCalcDecSignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let decFirst = DecimalSystem(stringLiteral: "-12")
        let decSecond = DecimalSystem(stringLiteral: "4")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .and, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "4", "Calaculation failure")
    }
    
    func testCalcBinSignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "0110 0000", "Calaculation failure")
    }
    
    func testCalcHexSignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let hexFirst = Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: .hex)!
        // 3. then
        XCTAssertEqual(result.value, "BEC8", "Calaculation failure")
    }
    
    func testCalcOctSignedAND() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let octFirst = Octal(stringLiteral: "357")
        let octSecond = Octal(stringLiteral: "123")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "103", "Calaculation failure")
    }
    
    // MARK: - OR
    
    func testCalcDecUnsignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst =  DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .or, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "14", "Calaculation failure")
    }
    
    func testCalcBinUnsignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binFirst =  Binary(stringLiteral: "110001")
        let binSecond = Binary(stringLiteral: "101010")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .or, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "0011 1011", "Calaculation failure")
    }
    
    func testCalcHexUnsignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .or, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "FEEF", "Calaculation failure")
    }
    
    func testCalcOctUnsignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let octFirst =  Octal(stringLiteral: "357")
        let octSecond = Octal(stringLiteral: "123")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .or, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "377", "Calaculation failure")
    }
    
    func testCalcDecSignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let decFirst = DecimalSystem(stringLiteral: "-12")
        let decSecond = DecimalSystem(stringLiteral: "4")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .or, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "-12", "Calaculation failure")
    }
    
    func testCalcBinSignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec

        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .or, secondValue: binSecond, for: .bin)!

        // 3. then
        XCTAssertEqual(result.value, "1111 0011", "Calaculation failure") // -13
    }
    
    func testCalcHexSignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .or, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "FEEF", "Calaculation failure")
    }
    
    func testCalcOctSignedOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let octFirst =  Octal(stringLiteral: "207") // -121
        let octSecond = Octal(stringLiteral: "12") // 10

        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .or, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "217", "Calaculation failure")
    }
    
    // MARK: - XOR
    
    func testCalcDecUnsignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst =  DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .xor, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "6", "Calaculation failure")
    }
    
    func testCalcBinUnsignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binFirst =  Binary(stringLiteral: "110001")
        let binSecond = Binary(stringLiteral: "101010")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .xor, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "0001 1011", "Calaculation failure")
    }
    
    func testCalcHexUnsignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .xor, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "4027", "Calaculation failure")
    }
    
    func testCalcOctUnsignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let octFirst =  Octal(stringLiteral: "357") // -17
        let octSecond = Octal(stringLiteral: "123") // 83
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .xor, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "274", "Calaculation failure")
    }
    
    func testCalcDecSignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let decFirst = DecimalSystem(stringLiteral: "-16")
        let decSecond = DecimalSystem(stringLiteral: "99")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .xor, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "-109", "Calaculation failure")
    }
    
    func testCalcBinSignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec

        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .xor, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "1001 0011", "Calaculation failure") // -109
    }
    
    func testCalcHexSignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .xor, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "4027", "Calaculation failure")
    }
    
    func testCalcOctSignedXOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let octFirst =  Octal(stringLiteral: "357") // -17
        let octSecond = Octal(stringLiteral: "123") // 83

        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .xor, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "274", "Calaculation failure")
    }
   
   // MARK: - NOR
   
    func testCalcDecUnsignedNOR() throws {

        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let decFirst =  DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")

        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .nor, secondValue: decSecond, for: .dec)!

        // 3. then
        XCTAssertEqual(result.value, "1", "Calaculation failure")
   }
   
   func testCalcBinUnsignedNOR() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binFirst =  Binary(stringLiteral: "110001")
        let binSecond = Binary(stringLiteral: "101010")

        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .nor, secondValue: binSecond, for: .bin)!

        // 3. then
        XCTAssertEqual(result.value, "0100", "Calaculation failure")
   }
   
   func testCalcHexUnsignedNOR() throws {
       // 1. given
       calcStatetorage?.saveData(unsignedData)
       let hexFirst =  Hexadecimal(stringLiteral: "FEED")
       let hexSecond = Hexadecimal(stringLiteral: "BECA")
       
       // 2. when
       let result = calcMathTest.calculate(firstValue: hexFirst, operation: .nor, secondValue: hexSecond, for: .hex)!
       
       // 3. then
       XCTAssertEqual(result.value, "110", "Calaculation failure")
   }
   
   func testCalcOctUnsignedNOR() throws {
       // 1. given
       calcStatetorage?.saveData(unsignedData)
       let octFirst =  Octal(stringLiteral: "327") // -17
       let octSecond = Octal(stringLiteral: "123") // 83
       
       // 2. when
       let result = calcMathTest.calculate(firstValue: octFirst, operation: .nor, secondValue: octSecond, for: .oct)!
       
       // 3. then
       XCTAssertEqual(result.value, "50", "Calaculation failure")
   }
    func testCalcDecSignedNOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let decFirst = DecimalSystem(stringLiteral: "-16")
        let decSecond = DecimalSystem(stringLiteral: "99")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .nor, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "12", "Calaculation failure")
    }
    
    func testCalcBinSignedNOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec

        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .nor, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "0000 1100", "Calaculation failure")
    }
    
    func testCalcHexSignedNOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .nor, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "110", "Calaculation failure")
    }
    
    func testCalcOctSignedNOR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let octFirst =  Octal(stringLiteral: "357") // -17
        let octSecond = Octal(stringLiteral: "123") // 83

        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .nor, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "0", "Calaculation failure")
    }
    
    // MARK: - Bitwise shift
    
    func testBitwiseShiftLeftUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binary = Binary(stringLiteral: "1100")
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: 1)
        
        // 3. then
        XCTAssertEqual(shifted?.value, "00011000", "Failed shifting left")
    }
    
    func testBitwiseShiftLeftSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binary = Binary(stringLiteral: "11110100") // -12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: 1)!
        
        // 3. then
        XCTAssertEqual(shifted.value, "11101000", "Failed shifting left") // -24
    }
    
    func testBitwiseShiftRightUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binary = Binary(stringLiteral: "1100")
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: 1)!
        
        // 3. then
        XCTAssertEqual(shifted.value, "0110", "Failed shifting right")
    }
    
    func testBitwiseShiftRightSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binary = Binary(stringLiteral: "11110100") // -12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: 1)!
        
        // 3. then
        XCTAssertEqual(shifted.value, "11111010", "Failed shifting right") // -6
    }
    
    func testBitwiseShiftTwelveRightUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binary = Binary(stringLiteral: "1100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: 12)!
        
        // 3. then
        XCTAssertEqual(shifted.value, "1100000000000000", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binary = Binary(stringLiteral: "1100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: 2)!
        
        // 3. then
        XCTAssertEqual(shifted.value, "0011", "Failed shifting 2 right")
    }
    
    func testBitwiseShiftTwelveLeftSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binary = Binary(stringLiteral: "1100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: 12)!
        
        // 3. then
        XCTAssertEqual(shifted.value, "00000000000000001100000000000000", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        let binary = Binary(stringLiteral: "1100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(value: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: 2)!
        
        // 3. then
        XCTAssertEqual(shifted.value, "00000011", "Failed shifting 2 right")
    }
}
