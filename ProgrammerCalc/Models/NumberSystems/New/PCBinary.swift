//
//  PCBinary.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.11.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

struct PCBinary: PCNumber {
    
    typealias Bit = BitArray.Bit
    
    var pcDecimalValue: PCDecimal { toPCDecimal() }

    private var intPart: BitArray = BitArray(64)
    private var fractPart: BitArray = BitArray(16)
    
    // MARK: - Initialization
    
    init(pcDecimal: PCDecimal) {
        self.intPart = extractIntegerBits(from: pcDecimal)
        self.fractPart = extractFractionalBits(from: pcDecimal)
    }

    init(intPart: BitArray, fractPart: BitArray) {
        self.intPart = intPart
        self.fractPart = fractPart.reversed()
    }
    
    init?(stringIntPart: String, stringFractPart: String) {
        if let intPart = BitArray(stringIntPart), let fractPart = BitArray(stringFractPart) {
            self.intPart = intPart
            self.fractPart = fractPart.reversed()
        } else {
            return nil
        }
    }
    
    // MARK: - Methods
    
    private func extractIntegerBits(from pcDecimalValue: PCDecimal) -> BitArray {
        let intPartBits: [Bit] = String(pcDecimalValue.decimalValue, radix: 2).compactMap({ Bit($0) }).reversed()
        
        return BitArray(bits: intPartBits)
    }
    
    private func extractFractionalBits(from pcDecimalValue: PCDecimal) -> BitArray {
        var decimalFloatPartBuffer = abs(pcDecimalValue.decimalValue.floatPart)
        let fractPartBits: [Bit] = (0..<16).map { _ in
            decimalFloatPartBuffer *= 2
            if decimalFloatPartBuffer >= 1 {
                decimalFloatPartBuffer -= 1
                return 1
            } else {
                return 0
            }
        }
        
        return BitArray(bits: fractPartBits)
    }
    
    private func toPCDecimal() -> PCDecimal {
        let decimalValue = intPartToDecimal() + fractPartToDecimal()
        return PCDecimal(value: decimalValue)
    }
    
    private func intPartToDecimal() -> Decimal {
        return intPart.bits.enumerated().reduce(0) { partialResult, bit in
            return partialResult + Decimal(bit.element) * pow(2, bit.offset)
        }
    }
    
    private func fractPartToDecimal() -> Decimal {
        return fractPart.bits.enumerated().reduce(0) { partialResult, bit in
            return partialResult + Decimal(bit.element) * (1 / pow(2, bit.offset + 1))
        }
    }
    
    static func + (lhs: PCBinary, rhs: PCBinary) -> PCBinary {
        let (resultFractPart, isFractPartOverflowed) = lhs.fractPart.reversed().addingReportingOverflow(rhs.fractPart.reversed())
        
        var resultIntPart = lhs.intPart + rhs.intPart
        
        if isFractPartOverflowed {
            resultIntPart = resultIntPart + BitArray("1")!
        }

        let result = PCBinary(intPart: resultIntPart, fractPart: resultFractPart)
        
        print(result.pcDecimalValue)
//
//        var test = BitArray("1011")! + BitArray("1")!
//
//        print(test)
//
//
//        print(BitArray("11111100")! & BitArray("00111111")!)
//
//        print(BitArray("10110010")! | BitArray("01011110")!)
//
//        print(BitArray("00010100")! ^ BitArray("00000101")!)

        return result
    }
}

// MARK: - BitArray

struct BitArray {
    
    typealias Bit = UInt8
    
    private let bitWidth: UInt8
    private(set) var bits: [Bit]
    
    // MARK: - Initialization
    
    init(_ bitWidth: UInt8) {
        self.bitWidth = bitWidth
        self.bits = Array(repeating: 0, count: Int(bitWidth))
    }
    
    init(bits: [Bit]) {
        self.bitWidth = UInt8(bits.count)
        self.bits = bits
    }
    
    init?(_ description: String) {
        if let result = Self.parseInputString(description) {
            self.bitWidth = result.bitWidth
            self.bits = result.bits
        } else {
            return nil
        }
    }
    
    // MARK: - Methods
    
    static private func parseInputString(_ stringValue: String) -> (bitWidth: UInt8, bits: [Bit])? {
        guard stringValue.contains(where: { $0 == "0" || $0 == "1" }) else { return nil }
        
        let bits: [Bit] = stringValue.reversed().compactMap { Bit($0) }
        let bitWidth = UInt8(bits.count)
        
        return (bitWidth, bits)
    }
    
    func reversed() -> BitArray {
        return BitArray(bits: bits.reversed())
    }
    
    private func invertedBits() -> [Bit] {
        return bits.map { return $0 == 1 ? 0 : 1 }
    }
    
    private func expandedBits(toWidth bitWidth: UInt8) -> [Bit] {
        guard bitWidth > self.bitWidth else { return bits }
        return bits + Array(repeating: 0, count: Int(bitWidth) - bits.count)
    }
    
    func addingReportingOverflow(_ other: BitArray) -> (partialValue: BitArray, overflow: Bool) {
        let resultBitWidth = max(self.bitWidth, other.bitWidth)
        var result = BitArray(resultBitWidth)
        
        let lhsBits = self.expandedBits(toWidth: resultBitWidth)
        let rhsBits = other.expandedBits(toWidth: resultBitWidth)

        var remainder: Bit = 0
        
        for index in 0..<Int(resultBitWidth) {
            let lhsBit = lhsBits[index]
            let rhsBit = rhsBits[index]
            
            if lhsBit == 1 && rhsBit == 1 {
                result[index] = remainder
                remainder = 1
            } else {
                result[index] = lhsBit + rhsBit
                if remainder == 1 && result[index] == 1 {
                    result[index] = 0
                } else if remainder == 1 {
                    result[index] = remainder
                    remainder = 0
                }
            }
        }

        return (result, remainder != 0)
    }
    
    static func + (lhs: BitArray, rhs: BitArray) -> BitArray {
        return lhs.addingReportingOverflow(rhs).partialValue
    }

    static prefix func ~ (bitArray: BitArray) -> BitArray {
        return BitArray(bits: bitArray.invertedBits())
    }

    static func & (lhs: BitArray, rhs: BitArray) -> BitArray {
        return bitwiseOperation(lhs: lhs, rhs: rhs, predicate: { $0 == 1 && $1 == 1 })
    }
    
    static func | (lhs: BitArray, rhs: BitArray) -> BitArray {
        return bitwiseOperation(lhs: lhs, rhs: rhs, predicate: { $0 == 1 || $1 == 1 })
    }
    
    static func ^ (lhs: BitArray, rhs: BitArray) -> BitArray {
        return bitwiseOperation(lhs: lhs, rhs: rhs, predicate: { $0 != $1 })
    }
    
    private static func bitwiseOperation(lhs: BitArray, rhs: BitArray, predicate: (Bit, Bit) -> Bool) -> BitArray {
        let resultBitWidth = max(lhs.bitWidth, rhs.bitWidth)
        var result = BitArray(resultBitWidth)
        
        let lhsBits = lhs.expandedBits(toWidth: resultBitWidth)
        let rhsBits = rhs.expandedBits(toWidth: resultBitWidth)
        
        for index in 0..<Int(resultBitWidth) where predicate(lhsBits[index], rhsBits[index]) {
            result[index] = 1
        }
        
        return result
    }
    
    subscript(_ index: Int) -> Bit {
        get {
            assert(isIndexValid(index), "Index out of range")
            return bits[index]
        }
        set {
            assert(isIndexValid(index), "Index out of range")
            bits[index] = newValue
        }
    }
    
    private func isIndexValid(_ index: Int) -> Bool {
        return index >= 0 && index < bits.count
    }
}

extension BitArray: CustomStringConvertible {
    var description: String { toString() }
    
    private func toString() -> String {
        return bits.reversed().map({ String($0) }).joined()
    }
}

extension UInt8 {
    init?(_ character: Character) {
        self.init(String(character))
    }
}

struct UInt1: ExpressibleByIntegerLiteral {
    
    typealias IntegerLiteralType = UInt8

    private var value: Bool = false
    
    init(integerLiteral value: IntegerLiteralType) {
        precondition(value == 0 || value == 1, "integer overflow: '\(value)' as '\(Self.self)'")
        self.value = value == 1
    }
}
