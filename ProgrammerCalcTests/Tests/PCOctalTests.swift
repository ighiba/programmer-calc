//
//  PCOctalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 05.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

final class PCOctalTests: XCTestCase {
    
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
        let testValue: PCNumber = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "5.75", "Incorrect PCNumber.pcDecimalValue")
    }
    
    func testInitPCDecimal() throws {
        let testValue: PCDecimal = 321
        
        let result = PCOctal(pcDecimal: testValue)
        
        XCTAssertEqual(result.description, "501", "Failed to init")
    }
    
    func testInitPCDecimalSignedByte() throws {
        let testValue: PCDecimal = 255
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "377", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedByte() throws {
        let testValue: PCDecimal = 260
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: byte.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "4", "Failed to init")
    }
    
    func testInitPCDecimalSignedWord() throws {
        let testValue: PCDecimal = 32769
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "100001", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedWord() throws {
        let testValue: PCDecimal = 65537
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: word.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "1", "Failed to init")
    }
    
    func testInitPCDecimalSignedDword() throws {
        let testValue: PCDecimal = -2147483649
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "17777777777", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedDword() throws {
        let testValue: PCDecimal = 4294967298
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: dword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "2", "Failed to init")
    }
    
    func testInitPCDecimalSignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "9223372036854775808")!
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: true)

        XCTAssertEqual(result.description, "1000000000000000000000", "Failed to init")
    }
    
    func testInitPCDecimalUnsignedQword() throws {
        let testValue: PCDecimal = PCDecimal(string: "18446744073709551617")!
        
        let result = PCOctal(pcDecimal: testValue, bitWidth: qword.bitWidth, isSigned: false)

        XCTAssertEqual(result.description, "1", "Failed to init")
    }
    
    func testReset() throws {
        var testValue: PCNumber = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        testValue.reset()
        let result = testValue.pcDecimalValue
        
        XCTAssertEqual(result.description, "0", "Reset failure")
    }
    
    // MARK: - PCNumberInput
    
    func testFormattedInput() throws {
        let testValue: PCNumberInput = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)
        
        XCTAssertEqual(result, "5.6", "Format error")
    }
    
    func testFormattedOutput() throws {
        let testValue: PCNumberInput = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        let result = testValue.formattedOutput(bitWidth: byte.bitWidth, fractionalWidth: 8)
        
        XCTAssertEqual(result, "5.6", "Format error")
    }
    
    func testAppendIntegerDigit() throws {
        var testValue: PCNumberInput = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        testValue.appendIntegerDigit("1", bitWidth: byte.bitWidth, isSigned: true)
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "51.6", "Failed to append digit")
    }
    
    func testAppendFractionalDigit() throws {
        var testValue: PCNumberInput = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        testValue.appendFractionalDigit("0", fractionalWidth: 8)
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "5.60", "Failed to append digit")
    }
    
    func testRemoveLeastSignificantIntegerDigit() throws {
        var testValue: PCNumberInput = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        testValue.removeLeastSignificantIntegerDigit()
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "0.6", "Failed to remove digit")
    }
    
    func testRemoveLeastSignificantFractionalDigit() throws {
        var testValue: PCNumberInput = PCOctal(PCBinary(stringIntPart: "101", stringFractPart: "11")!)
        
        testValue.removeLeastSignificantFractionalDigit()
        let result = testValue.formattedInput(bitWidth: byte.bitWidth)

        XCTAssertEqual(result, "5", "Failed to remove digit")
    }
}
