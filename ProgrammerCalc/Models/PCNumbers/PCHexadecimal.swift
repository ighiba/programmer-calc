//
//  PCHexadecimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.11.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

struct PCHexadecimal: PCNumber, PCNumberDigits, PCNumberBinaryRepresentatable {
    
    // MARK: - Properties
    
    var description: String { formatted() }
    
    var pcDecimalValue: PCDecimal { bitsToPCDecimal(intPart: intPart, fractPart: fractPart) }
    
    private var maxBitWidth: UInt8 = 64
    
    private(set) var intPart: BitArray = BitArray(64)
    private(set) var fractPart: BitArray = BitArray(0)
    
    private(set) var intDigits: DigitArray = []
    private(set) var fractDigits: DigitArray = []

    private let hexHelper: OctHexHelper = OctHexHelper(bitTable: .hex)
    private let bitsInDigitCount: Int = 4
    
    // MARK: - Initialization
    
    init(pcDecimal: PCDecimal) {
        self.setupFrom(pcDecimal: pcDecimal)
    }
    
    init(pcDecimal: PCDecimal, bitWidth: UInt8, isSigned: Bool) {
        self.setupFrom(pcDecimal: pcDecimal, bitWidth: bitWidth)
    }

    init(intPart: BitArray, fractPart: BitArray) {
        self.setupFrom(intPart: intPart, fractPart: fractPart, reverseFractPart: true)
    }
    
    init<T: PCNumberBinaryRepresentatable>(_ binaryRepresentable: T) {
        self.setupFrom(intPart: binaryRepresentable.intPart, fractPart: binaryRepresentable.fractPart)
    }
    
    init?(_ description: String) {
        if let parsedResult = hexHelper.parseInputString(description) {
            self.setupFrom(intPart: parsedResult.intPart, fractPart: parsedResult.fractPart)
        } else {
            return nil
        }
    }
    
    // MARK: - Methods
    
    mutating private func setupFrom(pcDecimal: PCDecimal, bitWidth: UInt8 = 64, reverseFractPart: Bool = false) {
        let intPart = extractIntegerBits(from: pcDecimal, bitWidth: bitWidth)
        let fractPart = extractFractionalBits(from: pcDecimal)
        self.setupFrom(intPart: intPart, fractPart: fractPart, bitWidth: bitWidth, reverseFractPart: reverseFractPart)
    }
    
    mutating private func setupFrom(intPart: BitArray, fractPart: BitArray, bitWidth: UInt8 = 64, reverseFractPart: Bool = false) {
        self.maxBitWidth = bitWidth
        self.intPart = intPart.expanded(toWidth: bitWidth, withBit: 0)
        self.fractPart = reverseFractPart ? fractPart.reversed() : fractPart
        self.intDigits = convertToIntegerDigits(from: self.intPart)
        self.fractDigits = convertToFractionalDigits(from: self.fractPart)
    }
    
    mutating func reset() {
        intPart = extractIntegerBits(from: .zero, bitWidth: maxBitWidth)
        intDigits = convertToIntegerDigits(from: intPart)
        fractPart = []
        fractDigits = []
    }

    func formatted() -> String {
        let integerString = intDigits.stringValue.reversedString()
        let fractionalString = fractDigits.stringValue

        return composeHexadecimalString(integerString: integerString, fractionalString: fractionalString)
    }
    
    func formattedInput(bitWidth: UInt8) -> String {
        let bitWidth = Int(bitWidth)
        let contractedIntegerBits = intPart.bits.contracted(toCount: bitWidth)
        let integerDigitsForOutput = convertToIntegerDigits(from: BitArray(bits: contractedIntegerBits))
        
        let integerString = integerDigitsForOutput.stringValue.reversedString()
        let fractionalString = fractDigits.stringValue

        return composeHexadecimalString(integerString: integerString, fractionalString: fractionalString)
    }
    
    func formattedOutput(bitWidth: UInt8, fractionalWidth: UInt8) -> String {
        let bitWidth = Int(bitWidth)
        let contractedIntegerBits = intPart.bits.contracted(toCount: bitWidth)
        let integerDigitsForOutput = convertToIntegerDigits(from: BitArray(bits: contractedIntegerBits))
        
        let integerString = integerDigitsForOutput.stringValue.reversedString()
        let fractionalString = fractDigits.stringValue

        return composeHexadecimalString(integerString: integerString, fractionalString: fractionalString)
    }
    
    private func composeHexadecimalString(integerString: String, fractionalString: String) -> String {
        if fractionalString.isEmpty {
            return "\(integerString)"
        } else {
            return "\(integerString).\(fractionalString)"
        }
    }
    
    private func convertToIntegerDigits(from bits: BitArray) -> DigitArray {
        var integerDigits = hexHelper.convertToIntegerDigits(from: bits).removedTrailingZeroDigits()
        if integerDigits.isEmpty {
            integerDigits.prepend("0")
        }
        
        return integerDigits
    }
    
    private func convertToFractionalDigits(from bits: BitArray) -> DigitArray {
        return hexHelper.convertToFractionalDigits(from: bits).removedTrailingZeroDigits()
    }

    mutating func appendIntegerDigit(_ digit: Digit, bitWidth: UInt8, isSigned: Bool) {
        guard canAppendIntegerDigit(digit, bitWidth: bitWidth) else { return }
        
        let bits: [Bit] = hexHelper.convertDigitToBits(digit).reversed()
        intPart.prepend(contentsOf: bits)
        
        if intDigits.hasOnlyOneZero {
            intDigits = [digit]
        } else {
            intDigits.prepend(digit)
        }
        
        if intPart.bits.count > maxBitWidth {
            intPart.removeLast(bitsInDigitCount)
        }
    }
    
    mutating func appendFractionalDigit(_ digit: Digit, fractionalWidth: UInt8) {
        guard canAppendFractionalDigit(digit, fractionalWidth: fractionalWidth) else { return }

        let bits = hexHelper.convertDigitToBits(digit)
        fractPart.append(contentsOf: bits)
        fractDigits.append(digit)
    }
    
    func canAppendIntegerDigit(_ digit: Digit, bitWidth: UInt8) -> Bool {
        guard digit.isHexDigit else { return false }
        
        let lowerBound = Int(bitWidth) - bitsInDigitCount
        let upperBound = Int(bitWidth)
        let range = lowerBound..<upperBound
        let isBoundsValid = intPart.isBoundsValid(range)
        let hasAvailablePlace = !(intPart[range].contains(where: { $0 != 0 }))

        return (isBoundsValid && hasAvailablePlace) || intPart.bits.count <= lowerBound
    }
    
    func canAppendFractionalDigit(_ digit: Digit, fractionalWidth: UInt8) -> Bool {
        guard digit.isHexDigit else { return false }
        
        return fractPart.bits.count <= Int(fractionalWidth) - bitsInDigitCount
    }

    mutating func removeLeastSignificantIntegerDigit() {
        guard !intDigits.hasOnlyOneZero else { return }
        
        let emptyBits = Array<Bit>(repeating: 0, count: bitsInDigitCount)
        intPart.append(contentsOf: emptyBits)
        intPart.removeFirst(bitsInDigitCount)
        intDigits.removeFirst()
        
        if intDigits.isEmpty {
            intDigits.prepend("0")
        }
    }
    
    mutating func removeLeastSignificantFractionalDigit() {
        fractPart.removeLast(bitsInDigitCount)
        fractDigits.removeLast()
    }
}
