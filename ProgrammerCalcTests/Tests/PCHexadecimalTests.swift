//
//  PCHexadecimalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 05.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

final class PCHexadecimalTests: XCTestCase {
    
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
        let testValue: PCNumber = PCHexadecimal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "5.75", "Incorrect PCNumber.pcDecimalValue")
    }
    
    func testInitPCDecimal() throws {
        let testValue: PCDecimal = 321
        
        let result = PCHexadecimal(pcDecimal: testValue)
        
        XCTAssertEqual(result.description, "141", "Failed to init")
    }
    
    func testInitPCDecimalSignedByte() throws {
        let testValue: PCDecimal = 255
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "FF", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedByte() throws {
        let testValue: PCDecimal = 260
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "4", "Failed to init")
    }
    
    func testInitPCDecimalSignedWord() throws {
        let testValue: PCDecimal = 32769
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "8001", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedWord() throws {
        let testValue: PCDecimal = 65537
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "1", "Failed to init")
    }
    
    func testInitPCDecimalSignedDword() throws {
        let testValue: PCDecimal = -2147483649
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "7FFFFFFF", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedDword() throws {
        let testValue: PCDecimal = 4294967298
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "2", "Failed to init")
    }
    
    func testInitPCDecimalSignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "9223372036854775808")!
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "8000000000000000", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "18446744073709551617")!
        
        let result = PCHexadecimal(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "1", "Failed to init")
    }
    
    func testReset() throws {
        var testValue: PCNumber = PCHexadecimal(PCBinary(stringIntPart: "1101", stringFractPart: "11")!)
        
        testValue.reset()
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "0", "Reset failure")
    }
    
    // MARK: - PCNumberInput
    
    func testFormattedInput() throws {
        let testValue: PCNumberInput = PCHexadecimal(PCBinary(stringIntPart: "1101", stringFractPart: "11")!)
        
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)
        
        XCTAssertEqual(result, "D.C", "Format error")
    }
    
    func testFormattedOutput() throws {
        let testValue: PCNumberInput = PCHexadecimal(PCBinary(stringIntPart: "1101", stringFractPart: "11")!)
        
        let result = testValue.formattedOutput(bitWidth: byte.bitWidth, fractionalWidth: 8)
        
        XCTAssertEqual(result, "D.C", "Format error")
    }
    
    func testAppendIntegerDigit() throws {
        var testValue: PCNumberInput = PCHexadecimal(PCBinary(stringIntPart: "1101", stringFractPart: "11")!)
        
        testValue.appendIntegerDigit("F", bitWidth: byte.bitWidth, isSigned: true)
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "DF.C", "Failed to append digit")
    }
    
    func testAppendFractionalDigit() throws {
        var testValue: PCNumberInput = PCHexadecimal(PCBinary(stringIntPart: "1101", stringFractPart: "11")!)
        
        testValue.appendFractionalDigit("0", fractionalWidth: 8)
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "D.C0", "Failed to append digit")
    }
    
    func testRemoveLeastSignificantIntegerDigit() throws {
        var testValue: PCNumberInput = PCHexadecimal(PCBinary(stringIntPart: "1101", stringFractPart: "11")!)
        
        testValue.removeLeastSignificantIntegerDigit()
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "0.C", "Failed to remove digit")
    }
    
    func testRemoveLeastSignificantFractionalDigit() throws {
        var testValue: PCNumberInput = PCHexadecimal(PCBinary(stringIntPart: "1101", stringFractPart: "11")!)
        
        testValue.removeLeastSignificantFractionalDigit()
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "D", "Failed to remove digit")
    }
}
