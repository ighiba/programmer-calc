//
//  PCDecimalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 05.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

final class PCDecimalTests: XCTestCase {
    
    let qword = WordSize(.qword)
    let dword = WordSize(.dword)
    let word = WordSize(.word)
    let byte = WordSize(.byte)

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - PCNumber
    
    func testPCDecimalValue() throws {
        let testValue: PCNumber = PCDecimal(value: 123.321)
        
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "123.321", "Incorrect PCNumber.pcDecimalValue")
    }
    
    func testInitPCDecimal() throws {
        let testValue: PCDecimal = 321
        
        let result = PCDecimal(pcDecimal: testValue)
        
        XCTAssertEqual(result.description, "321", "Failed to init")
    }
    
    func testInitPCDecimalSignedByte() throws {
        let testValue: PCDecimal = 255
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "-1", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedByte() throws {
        let testValue: PCDecimal = 260
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "4", "Failed to init")
    }
    
    func testInitPCDecimalSignedWord() throws {
        let testValue: PCDecimal = 32769
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "-32767", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedWord() throws {
        let testValue: PCDecimal = 65537
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "1", "Failed to init")
    }
    
    func testInitPCDecimalSignedDword() throws {
        let testValue: PCDecimal = -2147483649
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "2147483647", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedDword() throws {
        let testValue: PCDecimal = 4294967298
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "2", "Failed to init")
    }
    
    func testInitPCDecimalSignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "9223372036854775808")!
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "-9223372036854775808", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "18446744073709551617")!
        
        let result = PCDecimal(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "1", "Failed to init")
    }
    
    func testReset() throws {
        var testValue: PCNumber = PCDecimal(value: 123.321)
        
        testValue.reset()
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "0", "Reset failure")
    }
    
    // MARK: - PCNumberInput
    
    func testFormattedInput() throws {
        let testValue: PCNumberInput = PCDecimal(value: 123.321)
        
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)
        
        XCTAssertEqual(result, "123.321", "Format error")
    }
    
    func testFormattedOutput() throws {
        let testValue: PCNumberInput = PCDecimal(string: "123.12345678")!
        
        let result = testValue.formattedOutput(bitWidth: byte.bitWidth, fractionalWidth: 8)
        
        XCTAssertEqual(result, "123.12345678", "Format error")
    }
    
    func testAppendIntegerDigit() throws {
        var testValue: PCNumberInput = PCDecimal(string: "123.12345678")!
        
        testValue.appendIntegerDigit("4", bitWidth: word.bitWidth, isSigned: true)

        XCTAssertEqual(testValue.description, "1234.12345678", "Failed to append digit")
    }
    
    func testAppendFractionalDigit() throws {
        var testValue: PCNumberInput = PCDecimal(string: "123.12345678")!
        
        testValue.appendFractionalDigit("9", fractionalWidth: 8)

        XCTAssertEqual(testValue.description, "123.12345678", "Failed to append digit")
    }
    
    func testRemoveLeastSignificantIntegerDigit() throws {
        var testValue: PCNumberInput = PCDecimal(string: "123.12345678")!
        
        testValue.removeLeastSignificantIntegerDigit()

        XCTAssertEqual(testValue.description, "12.12345678", "Failed to remove digit")
    }
    
    func testRemoveLeastSignificantFractionalDigit() throws {
        var testValue: PCNumberInput = PCDecimal(string: "123.12345678")!
        
        testValue.removeLeastSignificantFractionalDigit()

        XCTAssertEqual(testValue.description, "123.1234567", "Failed to remove digit")
    }
    
    // MARK: - Div by zero

    func testDivisionByZero() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 0
        
        // 2. when
        var result = lhs / rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "NaN", "Calaculation failure")
    }
    
    // MARK: - ADD
    
    func testCalcDecAdd() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = lhs + rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "22", "Calaculation failure")
    }
    
    // MARK: - SUB
    
    func testCalcDecSub() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = lhs - rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "2", "Calaculation failure")
    }
    
    // MARK: - MUL
    
    func testCalcDecMul() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "120", "Calaculation failure")
    }
    
    // MARK: - DIV
    
    func testCalcDecDiv() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = lhs / rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "1.2", "Calaculation failure")
    }
    
    // MARK: - AND
    
    func testUnsignedAND() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = lhs & rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "8", "Calaculation failure")
    }
    
    func testSignedAND() throws {
        // 1. given
        let lhs: PCDecimal = -12
        let rhs: PCDecimal = 4
        
        // 2. when
        var result = lhs & rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "4", "Calaculation failure")
    }
    
    // MARK: - OR
    
    func testUnsignedOR() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = lhs | rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "14", "Calaculation failure")
    }
    
    func testSignedOR() throws {
        // 1. given
        let lhs: PCDecimal = -12
        let rhs: PCDecimal = 4
        
        // 2. when
        var result = lhs | rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-12", "Calaculation failure")
    }
   
    // MARK: - XOR
    
    func testUnsignedXOR() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = lhs ^ rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "6", "Calaculation failure")
    }
    
    func testSignedXOR() throws {
        // 1. given
        let lhs: PCDecimal = -16
        let rhs: PCDecimal = 99
        
        // 2. when
        var result = lhs ^ rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-109", "Calaculation failure")
    }
   
   // MARK: - NOR
    
    func testUnsignedNOR() throws {
        // 1. given
        let lhs: PCDecimal = 12
        let rhs: PCDecimal = 10
        
        // 2. when
        var result = ~(lhs | rhs)
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)

        // 3. then
        XCTAssertEqual(result.description, "241", "Calaculation failure")
    }
    
    func testSignedNOR() throws {
        // 1. given
        let lhs: PCDecimal = 16
        let rhs: PCDecimal = 99
        
        // 2. when
        var result = ~(lhs | rhs)
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-116", "Calaculation failure")
    }
    
    // MARK: - NOT
     
     func testUnsignedNOT() throws {
         // 1. given
         let lhs: PCDecimal = 12

         // 2. when
         var result = ~lhs
         result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
         
         // 3. then
         XCTAssertEqual(result.description, "243", "Calaculation failure")
     }
     
     func testSignedNOT() throws {
         // 1. given
         let lhs: PCDecimal = -16
         
         // 2. when
         var result = ~lhs
         result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
         
         // 3. then
         XCTAssertEqual(result.description, "15", "Calaculation failure")
     }
   
    // MARK: - Bitwise shift
    
    func testBitwiseShiftLeftUnsigned() throws {
        // 1. given
        let lhs: PCDecimal = 12
        
        // 2. when
        var result = lhs << 1
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "24", "Failed shifting left")
    }
    
    func testBitwiseShiftLeftSigned() throws {
        // 1. given
        let lhs: PCDecimal = -12
        
        // 2. when
        var result = lhs << 1
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-24", "Failed shifting left")
    }
    
    func testBitwiseShiftRightUnsigned() throws {
        // 1. given
        let lhs: PCDecimal = 12
        
        // 2. when
        var result = lhs >> 1
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "6", "Failed shifting right")
    }
    
    func testBitwiseShiftRightSigned() throws {
        // 1. given
        let lhs: PCDecimal = -12
        
        // 2. when
        var result = lhs >> 1
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-6", "Failed shifting right")
    }
    
    func testBitwiseShiftTwelveRightUnsigned() throws {
        // 1. given
        let lhs: PCDecimal = 123456
        
        // 2. when
        var result = lhs >> 12
        result = result.fixedOverflow(bitWidth: dword.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "30", "Failed shifting 12 right")
    }
    
    func testBitwiseShiftTwoRightUnsigned() throws {
        // 1. given
        let lhs: PCDecimal = 12
        
        // 2. when
        var result = lhs >> 2
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "3", "Failed shifting 2 right")
    }
    
    func testBitwiseShiftTwelveLeftSigned() throws {
        // 1. given
        let lhs: PCDecimal = 12
        
        // 2. when
        var result = lhs << 12
        result = result.fixedOverflow(bitWidth: dword.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "49152", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightSigned() throws {
        // 1. given
        let lhs: PCDecimal = 12
        
        // 2. when
        var result = lhs >> 2
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "3", "Failed shifting 2 right")
    }
    
    // MARK: - Fix Overflow
    
    func testFixMaxSignedOverflowBYTE() throws {
        // 1. given
        let lhs: PCDecimal = 107
        let rhs: PCDecimal = 4
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-84", "Failed fixing overflow")
    }

    func testFixMaxSignedOverflowWORD() throws {
        // 1. given
        let lhs: PCDecimal = 31766
        let rhs: PCDecimal = 321
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: word.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-26730", "Failed fixing overflow")
    }
    
    func testFixMaxSignedOverflowDWORD() throws {
        // 1. given
        let lhs: PCDecimal = 2147483647
        let rhs: PCDecimal = 123456789
        
        // 2. when
        var result = lhs + rhs
        result = result.fixedOverflow(bitWidth: dword.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-2024026860", "Failed fixing overflow")
    }
    
    func testFixMaxSignedOverflowQWORD() throws {
        // 1. given
        let lhs: PCDecimal = 999999999999999999
        let rhs: PCDecimal = 999999999999999999

        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: qword.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-7527149226598858751", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowBYTE() throws {
        // 1. given
        let lhs: PCDecimal = 107
        let rhs: PCDecimal = 4
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "172", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowWORD() throws {
        // 1. given
        let lhs: PCDecimal = 31766
        let rhs: PCDecimal = 321
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: word.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "38806", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowDWORD() throws {
        // 1. given
        let lhs: PCDecimal = 2147483647
        let rhs: PCDecimal = 123456789
        
        // 2. when
        var result = lhs + rhs
        result = result.fixedOverflow(bitWidth: dword.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "2270940436", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowQWORD() throws {
        // 1. given
        let lhs = PCDecimal(string: "9999999999999999999")!
        let rhs = PCDecimal(string: "9999999999999999999")!
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: qword.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "17580887698819776513", "Failed fixing overflow")
    }
    
    func testFixMinSignedOverflowBYTE() throws {
        // 1. given
        let lhs: PCDecimal = -107
        let rhs: PCDecimal = 4
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "84", "Failed fixing overflow")
    }

    func testFixMinSignedOverflowWORD() throws {
        // 1. given
        let lhs: PCDecimal = -31766
        let rhs : PCDecimal = 321
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: word.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "26730", "Failed fixing overflow")
    }
    
    func testFixMinSignedOverflowDWORD() throws {
        // 1. given
        let lhs: PCDecimal = -2147483647
        let rhs : PCDecimal = 123456789
        
        // 2. when
        var result = lhs + rhs
        result = result.fixedOverflow(bitWidth: dword.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-2024026858", "Failed fixing overflow")
    }
    
    func testFixMinSignedOverflowQWORD() throws {
        // 1. given
        let lhs = PCDecimal(string: "-999999999999999999")!
        let rhs = PCDecimal(string: "9876543210")!

        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: qword.bitWidth, isSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-4546160997919353110", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowBYTE() throws {
        // 1. given
        let lhs: PCDecimal = 107
        let rhs: PCDecimal = -123
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: byte.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "151", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowWORD() throws {
        // 1. given
        let lhs: PCDecimal = 31766
        let rhs: PCDecimal = -2344
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: word.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "54928", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowDWORD() throws {
        // 1. given
        let lhs: PCDecimal = 235452346
        let rhs: PCDecimal = 2147483647
        
        // 2. when
        var result = lhs - rhs
        result = result.fixedOverflow(bitWidth: dword.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "2382935995", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowQWORD() throws {
        // 1. given
        let lhs = PCDecimal(string: "9999999999999999999")!
        let rhs = PCDecimal(string: "9999999999999999999")!
        
        // 2. when
        var result = lhs * rhs
        result = result.fixedOverflow(bitWidth: qword.bitWidth, isSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "17580887698819776513", "Failed fixing overflow")
    }
}
