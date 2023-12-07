//
//  PCBinaryTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 05.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

final class PCBinaryTests: XCTestCase {
    
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
        let testValue: PCNumber = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "5.75", "Incorrect PCNumber.pcDecimalValue")
    }
    
    func testInitPCDecimal() throws {
        let testValue: PCDecimal = 321
        
        let result = PCBinary(pcDecimal: testValue)
        
        XCTAssertEqual(result.description, "0000000000000000000000000000000000000000000000000000000101000001", "Failed to init")
    }
    
    func testInitPCDecimalSignedByte() throws {
        let testValue: PCDecimal = 255
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "11111111", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedByte() throws {
        let testValue: PCDecimal = 260
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "00000100", "Failed to init")
    }
    
    func testInitPCDecimalSignedWord() throws {
        let testValue: PCDecimal = 32769
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "1000000000000001", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedWord() throws {
        let testValue: PCDecimal = 65537
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "0000000000000001", "Failed to init")
    }
    
    func testInitPCDecimalSignedDword() throws {
        let testValue: PCDecimal = -2147483649
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "01111111111111111111111111111111", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedDword() throws {
        let testValue: PCDecimal = 4294967298
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "00000000000000000000000000000010", "Failed to init")
    }
    
    func testInitPCDecimalSignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "9223372036854775808")!
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "1000000000000000000000000000000000000000000000000000000000000000", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "18446744073709551617")!
        
        let result = PCBinary(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "0000000000000000000000000000000000000000000000000000000000000001", "Failed to init")
    }
    
    func testReset() throws {
        var testValue: PCNumber = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        testValue.reset()
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "0", "Reset failure")
    }
    
    // MARK: - PCNumberInput
    
    func testFormattedInput() throws {
        let testValue: PCNumberInput = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)
        
        XCTAssertEqual(result, "0000 0101.11", "Format error")
    }
    
    func testFormattedOutput() throws {
        let testValue: PCNumberInput = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        let result = testValue.formattedOutput(bitWidth: byte.bitWidth, fractionalWidth: 8)
        
        XCTAssertEqual(result, "0000 0101.1100 0000", "Format error")
    }
    
    func testAppendIntegerDigit() throws {
        var testValue: PCNumberInput = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        testValue.appendIntegerDigit("1", bitWidth: byte.bitWidth, isSigned: true)
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "0000 1011.11", "Failed to append digit")
    }
    
    func testAppendFractionalDigit() throws {
        var testValue: PCNumberInput = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        testValue.appendFractionalDigit("0", fractionalWidth: 8)
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "0000 0101.110", "Failed to append digit")
    }
    
    func testRemoveLeastSignificantIntegerDigit() throws {
        var testValue: PCNumberInput = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        testValue.removeLeastSignificantIntegerDigit()
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "0000 0010.11", "Failed to remove digit")
    }
    
    func testRemoveLeastSignificantFractionalDigit() throws {
        var testValue: PCNumberInput = PCBinary(stringIntPart: "101", stringFractPart: "11")!
        
        testValue.removeLeastSignificantFractionalDigit()
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "0000 0101.1", "Failed to remove digit")
    }
}
