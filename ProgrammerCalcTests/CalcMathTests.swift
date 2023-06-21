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
    
    let storage = CalculatorStorage()
    
    var calcMathTest: CalcMath!
    
    let unsignedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    let signedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
    
    let wordSize = WordSize.shared
    let calcState: CalcState = CalcState.shared
    
    let qword = WordSize(.qword)
    let dword = WordSize(.dword)
    let word = WordSize(.word)
    let byte = WordSize(.byte)
    
    override func setUp() {
        super.setUp()
        calcMathTest = CalcMath()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        storage.saveData(dummyConversionSettings)
        
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
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(word)
        let testValue = "10001100"
        
        // 2. when
        let result = calcMathTest.fillUpBits(str: testValue)
        
        // 3. then
        XCTAssertEqual(result, "0000000010001100", "Calaculation failure")
    }
    
    func testDivisionByZero() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "0")
        var result = String()
        
        // 2. when
        do {
            let _ = try calcMathTest.calculate(firstValue: decFirst, operation: .div, secondValue: decSecond, for: .dec)!
        } catch MathErrors.divByZero {
            result = MathErrors.divByZero.localizedDescription ?? ""
        } catch {
            // else
            result = "no error"
        }
        
        // 3. then
        XCTAssertEqual(result, "Cannot divide by zero", "Calaculation failure")
    }
    
    // MARK: - VALUES_TYPES_ERROR
    
    func testCalcValuesTypes_ERROR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decValue = DecimalSystem(stringLiteral: "12")
        let binValue = Binary(stringLiteral: "10") // 2
        let octValue = Octal(stringLiteral: "10") // 8
        let hexValue = Hexadecimal(stringLiteral: "A") // 10
        
        // 2. when
        let result_1 = try! calcMathTest.calculate(firstValue: decValue, operation: .add, secondValue: binValue, for: .dec)! // Dec(12) + Bin(10) = 14
        let result_2 = try! calcMathTest.calculate(firstValue: binValue, operation: .add, secondValue: decValue, for: .dec)! // Bin(10) + Dec(12) = 14
        let result_3 = try! calcMathTest.calculate(firstValue: octValue, operation: .add, secondValue: binValue, for: .dec)! // Oct(10) + Bin(10) = 10
        let result_4 = try! calcMathTest.calculate(firstValue: hexValue, operation: .add, secondValue: decValue, for: .dec)! // Hex(A)  + Dec(12) = 22
        
        // 3. then
        XCTAssertEqual(result_1.value, "14", "Calaculation failure")
        XCTAssertEqual(result_2.value, "14", "Calaculation failure")
        XCTAssertEqual(result_3.value, "10", "Calaculation failure")
        XCTAssertEqual(result_4.value, "22", "Calaculation failure")
    }
    
    // MARK: - ADD
    
    func testCalcDecAdd() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .add, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "22", "Calaculation failure")
    }
    
    // MARK: - SUB
    
    func testCalcDecSub() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .sub, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "2", "Calaculation failure")
    }
    
    // MARK: - MUL
    
    func testCalcDecMul() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .mul, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "120", "Calaculation failure")
    }
    
    // MARK: - DIV
    
    func testCalcDecDiv() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .div, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "1.2", "Calaculation failure")
    }
    
    // MARK: - Negate
    
    func testBinNegateSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let bin = Binary(stringLiteral: "00010000") // 16
        
        
        // 2. when
        let result = calcMathTest.negate(value: bin, system: .bin)
        
        // 3. then
        XCTAssertEqual(result.value, "11110000", "Calaculation failure")
    }
    
    func testDecNegateSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let dec = DecimalSystem(stringLiteral: "12")
        
        // 2. when
        let result = calcMathTest.negate(value: dec, system: .dec)
        
        // 3. then
        XCTAssertEqual(result.value, "-12", "Calaculation failure")
    }
    
    func testOctNegateSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let oct = Octal(stringLiteral: "12") // 10
        
        // 2. when
        let result = calcMathTest.negate(value: oct, system: .oct)
        
        // 3. then
        XCTAssertEqual(result.value, "366", "Calaculation failure") // -10
    }
    
    func testHexNegateSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let hex = Hexadecimal(stringLiteral: "FEED") // -275
        
        // 2. when
        let result = calcMathTest.negate(value: hex, system: .hex)
        
        // 3. then
        XCTAssertEqual(result.value, "113", "Calaculation failure")
    }
    
    
    // MARK: - AND
    
    func testCalcDecUnsignedAND() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .and, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "8", "Calaculation failure")
    }
    
    func testCalcBinUnsignedAND() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binFirst = Binary(stringLiteral: "110001")
        let binSecond = Binary(stringLiteral: "101010")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "00100000", "Calaculation failure")
    }
    
    func testCalcHexUnsignedAND() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(word)
        let hexFirst = Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "BEC8", "Calaculation failure")
    }
    
    func testCalcOctUnsignedAND() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let octFirst = Octal(stringLiteral: "357")
        let octSecond = Octal(stringLiteral: "123")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "103", "Calaculation failure")
    }
    
    func testCalcDecSignedAND() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "-12")
        let decSecond = DecimalSystem(stringLiteral: "4")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .and, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "4", "Calaculation failure")
    }
    
    func testCalcBinSignedAND() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "01100000", "Calaculation failure")
    }
    
    func testCalcHexSignedAND() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let hexFirst = Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: .hex)!
        // 3. then
        XCTAssertEqual(result.value, "BEC8", "Calaculation failure")
    }
    
    func testCalcOctSignedAND() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let octFirst = Octal(stringLiteral: "357")
        let octSecond = Octal(stringLiteral: "123")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "103", "Calaculation failure")
    }
    
    // MARK: - OR
    
    func testCalcDecUnsignedOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst =  DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .or, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "14", "Calaculation failure")
    }
    
    func testCalcBinUnsignedOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binFirst =  Binary(stringLiteral: "110001")
        let binSecond = Binary(stringLiteral: "101010")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .or, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "00111011", "Calaculation failure")
    }
    
    func testCalcHexUnsignedOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(word)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .or, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "FEEF", "Calaculation failure")
    }
    
    func testCalcOctUnsignedOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let octFirst =  Octal(stringLiteral: "357")
        let octSecond = Octal(stringLiteral: "123")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .or, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "377", "Calaculation failure")
    }
    
    func testCalcDecSignedOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "-12")
        let decSecond = DecimalSystem(stringLiteral: "4")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .or, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "-12", "Calaculation failure")
    }
    
    func testCalcBinSignedOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .or, secondValue: binSecond, for: .bin)!

        // 3. then
        XCTAssertEqual(result.value, "11110011", "Calaculation failure") // -13
    }
    
    func testCalcHexSignedOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .or, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "FEEF", "Calaculation failure")
    }
    
    func testCalcOctSignedOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let octFirst =  Octal(stringLiteral: "207") // -121
        let octSecond = Octal(stringLiteral: "12") // 10

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .or, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "217", "Calaculation failure")
    }
    
    // MARK: - XOR
    
    func testCalcDecUnsignedXOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst =  DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .xor, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "6", "Calaculation failure")
    }
    
    func testCalcBinUnsignedXOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binFirst =  Binary(stringLiteral: "110001")
        let binSecond = Binary(stringLiteral: "101010")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .xor, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "00011011", "Calaculation failure")
    }
    
    func testCalcHexUnsignedXOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(word)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .xor, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "4027", "Calaculation failure")
    }
    
    func testCalcOctUnsignedXOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let octFirst =  Octal(stringLiteral: "357") // -17
        let octSecond = Octal(stringLiteral: "123") // 83
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .xor, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "274", "Calaculation failure")
    }
    
    func testCalcDecSignedXOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "-16")
        let decSecond = DecimalSystem(stringLiteral: "99")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .xor, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "-109", "Calaculation failure")
    }
    
    func testCalcBinSignedXOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .xor, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "10010011", "Calaculation failure") // -109
    }
    
    func testCalcHexSignedXOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .xor, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "4027", "Calaculation failure")
    }
    
    func testCalcOctSignedXOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let octFirst =  Octal(stringLiteral: "357") // -17
        let octSecond = Octal(stringLiteral: "123") // 83

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .xor, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "274", "Calaculation failure")
    }
   
   // MARK: - NOR
   
    func testCalcDecUnsignedNOR() throws {

        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let decFirst =  DecimalSystem(stringLiteral: "12")
        let decSecond = DecimalSystem(stringLiteral: "10")

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .nor, secondValue: decSecond, for: .dec)!

        // 3. then
        XCTAssertEqual(result.value, "241", "Calaculation failure") // 1111001
   }
   
   func testCalcBinUnsignedNOR() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binFirst =  Binary(stringLiteral: "110001") // 49
        let binSecond = Binary(stringLiteral: "101010") // 42

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .nor, secondValue: binSecond, for: .bin)!

        // 3. then
        XCTAssertEqual(result.value, "11000100", "Calaculation failure")
   }
   
   func testCalcHexUnsignedNOR() throws {
       // 1. given
       calcState.setCalcState(unsignedData)
       wordSize.setWordSize(word)
       let hexFirst =  Hexadecimal(stringLiteral: "FEED")
       let hexSecond = Hexadecimal(stringLiteral: "BECA")
       
       // 2. when
       let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .nor, secondValue: hexSecond, for: .hex)!
       
       // 3. then
       XCTAssertEqual(result.value, "110", "Calaculation failure")
   }
    
   func testCalcOctUnsignedNOR() throws {
       // 1. given
       calcState.setCalcState(unsignedData)
       wordSize.setWordSize(byte)
       let octFirst =  Octal(stringLiteral: "327") // -17
       let octSecond = Octal(stringLiteral: "123") // 83
       
       // 2. when
       let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .nor, secondValue: octSecond, for: .oct)!
       
       // 3. then
       XCTAssertEqual(result.value, "50", "Calaculation failure")
   }
    func testCalcDecSignedNOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let decFirst = DecimalSystem(stringLiteral: "-16")
        let decSecond = DecimalSystem(stringLiteral: "99")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: decFirst, operation: .nor, secondValue: decSecond, for: .dec)!
        
        // 3. then
        XCTAssertEqual(result.value, "12", "Calaculation failure")
    }
    
    func testCalcBinSignedNOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binFirst =  Binary(stringLiteral: "11110000") // -16 dec
        let binSecond = Binary(stringLiteral: "01100011") // 99 dec

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: binFirst, operation: .nor, secondValue: binSecond, for: .bin)!
        
        // 3. then
        XCTAssertEqual(result.value, "00001100", "Calaculation failure")
    }
    
    func testCalcHexSignedNOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let hexFirst =  Hexadecimal(stringLiteral: "FEED")
        let hexSecond = Hexadecimal(stringLiteral: "BECA")
        
        // 2. when
        let result = try! calcMathTest.calculate(firstValue: hexFirst, operation: .nor, secondValue: hexSecond, for: .hex)!
        
        // 3. then
        XCTAssertEqual(result.value, "110", "Calaculation failure")
    }
    
    func testCalcOctSignedNOR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let octFirst =  Octal(stringLiteral: "357") // -17
        let octSecond = Octal(stringLiteral: "123") // 83

        // 2. when
        let result = try! calcMathTest.calculate(firstValue: octFirst, operation: .nor, secondValue: octSecond, for: .oct)!
        
        // 3. then
        XCTAssertEqual(result.value, "0", "Calaculation failure")
    }
    
    // MARK: - Bitwise shift
    
    func testBitwiseShiftLeftUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: "00001100")
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: DecimalSystem(1))
        
        // 3. then
        XCTAssertEqual(shifted?.value, "00011000", "Failed shifting left")
    }
    
    func testBitwiseShiftLeftSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: "11110100") // -12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: DecimalSystem(1))!
        
        // 3. then
        XCTAssertEqual(shifted.value, "11101000", "Failed shifting left") // -24
    }
    
    func testBitwiseShiftRightUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: "00001100")
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: DecimalSystem(1))!
        
        // 3. then
        XCTAssertEqual(shifted.value, "00000110", "Failed shifting right")
    }
    
    func testBitwiseShiftRightSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: "11110100") // -12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: DecimalSystem(1))!
        
        // 3. then
        XCTAssertEqual(shifted.value, "11111010", "Failed shifting right") // -6
    }
    
    func testBitwiseShiftTwelveRightUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(word)
        let binary = Binary(stringLiteral: "00001100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: DecimalSystem(12))!
        
        // 3. then
        XCTAssertEqual(shifted.value, "1100000000000000", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: "1100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: DecimalSystem(2))!
        
        // 3. then
        XCTAssertEqual(shifted.value, "00000011", "Failed shifting 2 right")
    }
    
    func testBitwiseShiftTwelveLeftSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let binary = Binary(stringLiteral: "00001100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftLeft, shiftCount: DecimalSystem(12))!
        
        // 3. then
        XCTAssertEqual(shifted.value, "1100000000000000", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightSigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let binary = Binary(stringLiteral: "1100") // 12
        
        // 2. when
        let shifted = calcMathTest.shiftBits(number: binary, mainSystem: .bin, shiftOperation: .shiftRight, shiftCount: DecimalSystem(2))!
        
        // 3. then
        XCTAssertEqual(shifted.value, "00000011", "Failed shifting 2 right")
    }
}
