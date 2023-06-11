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

class PCDecimalTests: XCTestCase {

    var pcDecimalTest: PCDecimal!
    
    let byte = WordSize(8)
    let word = WordSize(16)
    let dword = WordSize(32)
    let qword = WordSize(64)

    override func setUp() {
        super.setUp()
        pcDecimalTest = PCDecimal()
    }
    
    override func tearDown() {
        pcDecimalTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDivisionByZero() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(0)
        
        // 2. when
        var result = lhs / rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "NaN", "Calaculation failure")
    }
    
    // MARK: - ADD
    
    func testCalcDecAdd() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = lhs + rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "22", "Calaculation failure")
    }
    
    // MARK: - SUB
    
    func testCalcDecSub() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = lhs - rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "2", "Calaculation failure")
    }
    
    // MARK: - MUL
    
    func testCalcDecMul() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "120", "Calaculation failure")
    }
    
    // MARK: - DIV
    
    func testCalcDecDiv() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = lhs / rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "1.2", "Calaculation failure")
    }
    
    // MARK: - AND
    
    func testUnsignedAND() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = lhs & rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "8", "Calaculation failure")
    }
    
    func testSignedAND() throws {
        // 1. given
        let lhs = PCDecimal(value: -12)
        let rhs = PCDecimal(4)
        
        // 2. when
        var result = lhs & rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "4", "Calaculation failure")
    }
    
    // MARK: - OR
    
    func testUnsignedOR() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = lhs | rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "14", "Calaculation failure")
    }
    
    func testSignedOR() throws {
        // 1. given
        let lhs = PCDecimal(value: -12)
        let rhs = PCDecimal(4)
        
        // 2. when
        var result = lhs | rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-12", "Calaculation failure")
    }
   
    // MARK: - XOR
    
    func testUnsignedXOR() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = lhs ^ rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "6", "Calaculation failure")
    }
    
    func testSignedXOR() throws {
        // 1. given
        let lhs = PCDecimal(value: -16)
        let rhs = PCDecimal(99)
        
        // 2. when
        var result = lhs ^ rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-109", "Calaculation failure")
    }
   
   // MARK: - NOR
    
    func testUnsignedNOR() throws {
        // 1. given
        let lhs = PCDecimal(12)
        let rhs = PCDecimal(10)
        
        // 2. when
        var result = ~(lhs | rhs)
        result.fixOverflow(bitWidth: byte.value, processSigned: false)

        // 3. then
        XCTAssertEqual(result.description, "241", "Calaculation failure")
    }
    
    func testSignedNOR() throws {
        // 1. given
        let lhs = PCDecimal(value: 16)
        let rhs = PCDecimal(99)
        
        // 2. when
        var result = ~(lhs | rhs)
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-116", "Calaculation failure")
    }
    
    // MARK: - NOT
     
     func testUnsignedNOT() throws {
         // 1. given
         let lhs = PCDecimal(12)

         // 2. when
         var result = ~lhs
         result.fixOverflow(bitWidth: byte.value, processSigned: false)
         
         // 3. then
         XCTAssertEqual(result.description, "243", "Calaculation failure")
     }
     
     func testSignedNOT() throws {
         // 1. given
         let lhs = PCDecimal(value: -16)
         
         // 2. when
         var result = ~lhs
         result.fixOverflow(bitWidth: byte.value, processSigned: true)
         
         // 3. then
         XCTAssertEqual(result.description, "15", "Calaculation failure")
     }
   
    // MARK: - Bitwise shift
    
    func testBitwiseShiftLeftUnsigned() throws {
        // 1. given
        let lhs = PCDecimal(12)
        
        // 2. when
        var result = lhs << 1
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "24", "Failed shifting left")
    }
    
    func testBitwiseShiftLeftSigned() throws {
        // 1. given
        let lhs = PCDecimal(value: -12)
        
        // 2. when
        var result = lhs << 1
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-24", "Failed shifting left")
    }
    
    func testBitwiseShiftRightUnsigned() throws {
        // 1. given
        let lhs = PCDecimal(12)
        
        // 2. when
        var result = lhs >> 1
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "6", "Failed shifting right")
    }
    
    func testBitwiseShiftRightSigned() throws {
        // 1. given
        let lhs = PCDecimal(value: -12)
        
        // 2. when
        var result = lhs >> 1
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-6", "Failed shifting right")
    }
    
    func testBitwiseShiftTwelveRightUnsigned() throws {
        // 1. given
        let lhs = PCDecimal(123456)
        
        // 2. when
        var result = lhs >> 12
        result.fixOverflow(bitWidth: dword.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "30", "Failed shifting 12 right")
    }
    
    func testBitwiseShiftTwoRightUnsigned() throws {
        // 1. given
        let lhs = PCDecimal(12)
        
        // 2. when
        var result = lhs >> 2
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "3", "Failed shifting 2 right")
    }
    
    func testBitwiseShiftTwelveLeftSigned() throws {
        // 1. given
        let lhs = PCDecimal(12)
        
        // 2. when
        var result = lhs << 12
        result.fixOverflow(bitWidth: dword.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "49152", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightSigned() throws {
        // 1. given
        let lhs = PCDecimal(12)
        
        // 2. when
        var result = lhs >> 2
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "3", "Failed shifting 2 right")
    }
    
    // MARK: - Fix Overflow
    
    func testFixMaxSignedOverflowBYTE() throws {
        // 1. given
        let lhs = PCDecimal(107)
        let rhs = PCDecimal(4)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-84", "Failed fixing overflow")
    }

    func testFixMaxSignedOverflowWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: 31766)
        let rhs = PCDecimal(321)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: word.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-26730", "Failed fixing overflow")
    }
    
    func testFixMaxSignedOverflowDWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: 2147483647)
        let rhs = PCDecimal(value: 123456789)
        
        // 2. when
        var result = lhs + rhs
        result.fixOverflow(bitWidth: dword.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-2024026860", "Failed fixing overflow")
    }
    
    func testFixMaxSignedOverflowQWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: Decimal(string: "999999999999999999")!)
        let rhs = PCDecimal(value: Decimal(string: "999999999999999999")!)

        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: qword.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-7527149226598858751", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowBYTE() throws {
        // 1. given
        let lhs = PCDecimal(107)
        let rhs = PCDecimal(4)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "172", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: 31766)
        let rhs = PCDecimal(321)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: word.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "38806", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowDWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: 2147483647)
        let rhs = PCDecimal(value: 123456789)
        
        // 2. when
        var result = lhs + rhs
        result.fixOverflow(bitWidth: dword.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "2270940436", "Failed fixing overflow")
    }
    
    func testFixMaxUnsignedOverflowQWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: Decimal(string: "9999999999999999999")!)
        let rhs = PCDecimal(value: Decimal(string: "9999999999999999999")!)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: qword.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "17580887698819776513", "Failed fixing overflow")
    }
    
    func testFixMinSignedOverflowBYTE() throws {
        // 1. given
        let lhs = PCDecimal(value: -107)
        let rhs = PCDecimal(4)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "84", "Failed fixing overflow")
    }

    func testFixMinSignedOverflowWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: -31766)
        let rhs = PCDecimal(321)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: word.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "26730", "Failed fixing overflow")
    }
    
    func testFixMinSignedOverflowDWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: -2147483647)
        let rhs = PCDecimal(value: 123456789)
        
        // 2. when
        var result = lhs + rhs
        result.fixOverflow(bitWidth: dword.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-2024026858", "Failed fixing overflow")
    }
    
    func testFixMinSignedOverflowQWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: Decimal(string: "-999999999999999999")!)
        let rhs = PCDecimal(value: Decimal(string: "9876543210")!)

        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: qword.value, processSigned: true)
        
        // 3. then
        XCTAssertEqual(result.description, "-4546160997919353110", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowBYTE() throws {
        // 1. given
        let lhs = PCDecimal(value: 107)
        let rhs = PCDecimal(value: -123)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: byte.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "151", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: 31766)
        let rhs = PCDecimal(value: -2344)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: word.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "54928", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowDWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: 235452346)
        let rhs = PCDecimal(value: 2147483647)
        
        // 2. when
        var result = lhs - rhs
        result.fixOverflow(bitWidth: dword.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "2382935995", "Failed fixing overflow")
    }
    
    func testFixMinUnsignedOverflowQWORD() throws {
        // 1. given
        let lhs = PCDecimal(value: Decimal(string: "9999999999999999999")!)
        let rhs = PCDecimal(value: Decimal(string: "9999999999999999999")!)
        
        // 2. when
        var result = lhs * rhs
        result.fixOverflow(bitWidth: qword.value, processSigned: false)
        
        // 3. then
        XCTAssertEqual(result.description, "17580887698819776513", "Failed fixing overflow")
    }
    
}
