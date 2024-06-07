//
//  PCBinary.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.11.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

struct PCBinary: PCNumber, PCNumberDigits, PCNumberBinaryRepresentatable {
    
    // MARK: - Properties
    
    var description: String { formatted().removedAllSpaces() }

    var pcDecimalValue: PCDecimal { bitsToPCDecimal(intPart: intPart, fractPart: fractPart) }
    
    private var maxBitWidth: UInt8 = 64

    private(set) var intPart: BitArray = BitArray(64)
    private(set) var fractPart: BitArray = BitArray(0)
    
    private(set) var intDigits: DigitArray = []
    private(set) var fractDigits: DigitArray = []
    
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
    
    init?(stringIntPart: String, stringFractPart: String) {
        if let intPart = BitArray(stringIntPart), let fractPart = BitArray(stringFractPart) {
            self.setupFrom(intPart: intPart, fractPart: fractPart, reverseFractPart: true)
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
        self.intDigits = bitsToDigits(self.intPart)
        self.fractDigits = bitsToDigits(self.fractPart)
    }
    
    mutating func reset() {
        intPart = extractIntegerBits(from: .zero, bitWidth: maxBitWidth)
        intDigits = bitsToDigits(intPart)
        fractPart = []
        fractDigits = []
    }

    func formatted() -> String {
        let integerString = intDigits.stringValue.reversedString()
        let fractionalString = fractDigits.stringValue
        
        return composeBinaryString(integerString: integerString, fractionalString: fractionalString)
    }
    
    func formattedInput(bitWidth: UInt8) -> String {
        let bitWidth = Int(bitWidth)
        let integerString = intDigits.stringValue.contracted(toLenght: bitWidth).reversedString()
        let fractionalString = fractDigits.stringValue

        return composeBinaryString(integerString: integerString, fractionalString: fractionalString)
    }
    
    func formattedOutput(bitWidth: UInt8, fractionalWidth: UInt8) -> String {
        let bitWidth = Int(bitWidth)
        let fractionalWidth = Int(fractionalWidth)
        let integerString = intDigits.stringValue.contracted(toLenght: bitWidth).reversedString()
        var fractionalString = fractDigits.stringValue

        if !fractionalString.isEmpty {
            fractionalString = fractionalString.adjusted(toLenght: fractionalWidth, repeatingCharacter: "0")
        }

        return composeBinaryString(integerString: integerString, fractionalString: fractionalString)
    }
    
    private func composeBinaryString(integerString: String, fractionalString: String) -> String {
        let formattedIntegerString = addSpacesInBinaryString(integerString)
        let formattedFractionalString = addSpacesInBinaryString(fractionalString)

        if formattedFractionalString.isEmpty {
            return "\(formattedIntegerString)"
        } else {
            return "\(formattedIntegerString).\(formattedFractionalString)"
        }
    }
    
    private func addSpacesInBinaryString(_ string: String) -> String {
        return string.enumerated().map { (index, bit) in
            index % 4 == 0 ? " \(bit)" : "\(bit)"
        }.joined().removedLeadingSpaces()
    }
    
    private func bitsToDigits(_ bits: BitArray) -> DigitArray {
        let digits = bits.bits.map { Digit($0) }
        
        return DigitArray(digits: digits)
    }

    mutating func appendIntegerDigit(_ digit: Digit, bitWidth: UInt8, isSigned: Bool) {
        guard canAppendIntegerDigit(digit, bitWidth: bitWidth), let bit = Bit(digit) else { return }
        
        intPart.prepend(bit)
        intDigits.prepend(digit)
        
        if intPart.bits.count > self.maxBitWidth {
            intPart.removeLast()
            intDigits.removeLast()
        }
    }
    
    mutating func appendFractionalDigit(_ digit: Digit, fractionalWidth: UInt8) {
        guard canAppendFractionalDigit(digit, fractionalWidth: fractionalWidth), let bit = Bit(digit) else { return }

        fractPart.append(bit)
        fractDigits.append(digit)
    }
    
    func canAppendIntegerDigit(_ digit: Digit, bitWidth: UInt8) -> Bool {
        guard digit.isBinDigit else { return false }
        
        let signIndex = Int(bitWidth - 1)
        let isSignIndexValid = intPart.isIndexValid(signIndex)
        
        return (isSignIndexValid && intPart[signIndex] != 1) || intPart.bits.count < bitWidth
    }
    
    func canAppendFractionalDigit(_ digit: Digit, fractionalWidth: UInt8) -> Bool {
        guard digit.isBinDigit else { return false }
        
        return fractPart.bits.count < fractionalWidth
    }
    
    mutating func removeLeastSignificantIntegerDigit() {
        guard !intDigits.isAllZeros else { return }
        
        intPart.removeFirst()
        intDigits.removeFirst()
        intPart.append(0)
        intDigits.append("0")
    }
    
    mutating func removeLeastSignificantFractionalDigit() {
        fractPart.removeLast()
        fractDigits.removeLast()
    }
    
    mutating func switchBit(_ bit: Bit, atIndex bitIndex: UInt8) {
        guard bitIndex < intPart.bitWidth, bit == 0 || bit == 1 else { return }
        
        let index = Int(bitIndex)
        intPart[index] = bit
        intDigits = bitsToDigits(intPart)
    }
    
    static func + (lhs: PCBinary, rhs: PCBinary) -> PCBinary {
        let (resultFractPart, isFractPartOverflowed) = lhs.fractPart.reversed().addingReportingOverflow(rhs.fractPart.reversed())
        
        var resultIntPart = lhs.intPart + rhs.intPart
        if isFractPartOverflowed {
            resultIntPart += BitArray("1")!
        }

        return PCBinary(intPart: resultIntPart, fractPart: resultFractPart)
    }
}
