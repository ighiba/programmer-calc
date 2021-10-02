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
    
    // Storages
    var conversionStorage: ConversionStorageProtocol? = ConversionStorage()
    var calcStatetorage: CalcStateStorageProtocol? = CalcStateStorage()
    
    var binaryTest: Binary!
    var binaryStrInput: String = "1100" // dec = 12
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    override func setUp() {
        super.setUp()
        binaryTest = Binary()
        let dummyConversionSettings = ConversionSettings(systMain: "Decimal", systConverter: "Binary", number: 8.0)
        conversionStorage?.saveData(dummyConversionSettings)
        
    }
    
    override func tearDown() {
        binaryTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // XCTAssert to test model
    func testBinaryUnsignedInit() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        
        // 2. when
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "1100", "Converted values are wrong")
    }
    
    func testBinarySignedInit() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        
        // 2. when
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "00001100", "Converted values are wrong")
    }
    
    func testBinaryChangeSignedBit() throws {
        // 1. give
        calcStatetorage?.saveData(signedData)
        let bit: Character = "1"
        
        // 2. when
        binaryTest = Binary(stringLiteral: binaryStrInput)
        binaryTest.changeSignedBit(to: bit)
        binaryTest.updateSignedState()
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "10001100", "Converted values are wrong")
    }
    
    func testBinaryDivide() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        binaryTest = binaryTest.divideBinary(by: 4)

        // 3. then
        XCTAssertEqual(binaryTest.value, "0000 1100", "No spaces inserted")
    }
    
    func testBinaryRemoveAllSpaces() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        binaryTest = binaryTest.divideBinary(by: 4)
        
        // 2. when
        let removedSpaces = binaryTest.value.removeAllSpaces()

        // 3. then
        XCTAssertEqual(removedSpaces, "00001100", "Spaces not deleted")
    }
    
    func testBinaryRemoveZerosBefore() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let removedZerosBefore = binaryTest.removeZerosBefore(str: binaryTest.value)

        // 3. then
        XCTAssertEqual(removedZerosBefore, "1100", "Zeros before not removed")
    }
    
    func testBinaryRemoveZerosAfter() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: "\(binaryStrInput).0100")
        // 2. when
        let removedZerosAfter = binaryTest.removeZerosAfter(str: binaryTest.value)

        // 3. then
        XCTAssertEqual(removedZerosAfter, "00001100.01", "Zeros after not removed")
    }
    
    func testBinaryAppendDigitToUnsigned() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        binaryTest = Binary(stringLiteral: "01001100")
        
        // 2. when
        binaryTest.appendDigit("1")

        // 3. then
        XCTAssertEqual(binaryTest.value, "10011001", "Digit not appended")
    }
    
    func testBinaryAppendDigitToSigned() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: "01001100")
        
        // 2. when
        binaryTest.appendDigit("1")

        // 3. then
        XCTAssertEqual(binaryTest.value, "0000000010011001", "Digit not appended")
    }
    
    func testBinaryToDecSignedPlus() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        
        // 3. then
        XCTAssertEqual(decValue.decimalValue, 12, "Wrong conversion")
    }

    func testBinaryToDecSignedMinus() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        binaryTest.changeSignedBit(to: "1")
        binaryTest.updateSignedState()
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        
        // 3. then
        XCTAssertEqual(decValue.decimalValue, -116, "Wrong conversion")
    }
    
    func testBinaryToDecUnsignedPlus() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        
        // 3. then
        XCTAssertEqual(decValue.decimalValue, 12, "Wrong conversion")
    }

    func testBinaryToDecUnsignedMinus() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        binaryTest = Binary(stringLiteral: "1000\(binaryStrInput)")
        
        // 2. when
        let decValue = DecimalSystem(binaryTest)
        // 3. then
        XCTAssertEqual(decValue.decimalValue, 140, "Wrong conversion")
    }
    
    func testBinaryConvertDoubleTo() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let binaryInt: Binary.IntPart = "12"
        let binaryFract: Binary.FractPart = "25"

        // 2. when
        binaryTest.value = binaryTest.convertDoubleToBinaryStr(numberStr: (binaryInt, binaryFract))
        // 3. then
        XCTAssertEqual(binaryTest.value, "01100.01000000", "Wrong conversion")
    }
    
    func testConvertIntToBinary() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        let intValue = 12

        // 2. when
        binaryTest.value = binaryTest.convertIntToBinary(intValue)
        // 3. then
        XCTAssertEqual(binaryTest.value, "01100", "Wrong conversion")
    }
    
    func testBinaryInvert() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        binaryTest = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        binaryTest.invert()
        
        // 3. then
        XCTAssertEqual(binaryTest.value, "11110011", "Wrong inversion")
    }
    


}
