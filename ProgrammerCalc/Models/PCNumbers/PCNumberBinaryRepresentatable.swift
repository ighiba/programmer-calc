//
//  PCNumberBinaryRepresentatable.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

typealias Bit = UInt8

protocol PCNumberBinaryRepresentatable: PCNumber {
    var intPart: BitArray { get }
    var fractPart: BitArray { get }
    init(intPart: BitArray, fractPart: BitArray)
    init<T: PCNumberBinaryRepresentatable>(_ binaryRepresentable: T)
}

extension PCNumberBinaryRepresentatable {
    
    func extractIntegerBits(from pcDecimal: PCDecimal, bitWidth: UInt8 = 64) -> BitArray {
        let decimalValue = abs(pcDecimal.value)
        let intPartBits: [Bit] = String(decimalValue, radix: 2).compactMap({ Bit($0) }).reversed()
        
        var result = BitArray(bits: intPartBits).adjusted(toWidth: bitWidth, withBit: 0)
        if pcDecimal.isNegative {
            result = ~result + BitArray("1")!
        }
        
        return result
    }
    
    func extractFractionalBits(from pcDecimal: PCDecimal) -> BitArray {
        var decimalFloatPartBuffer = abs(pcDecimal.value.floatPart)
        var fractPartBits: [Bit] = (0..<16).map { _ in
            decimalFloatPartBuffer *= 2
            if decimalFloatPartBuffer >= 1 {
                decimalFloatPartBuffer -= 1
                return 1
            } else {
                return 0
            }
        }
        
        fractPartBits = removeTrailingZeroBits(fractPartBits)
        
        return BitArray(bits: fractPartBits)
    }
    
    private func removeTrailingZeroBits(_ bits: [Bit]) -> [Bit] {
        var appearedNonZeroBit = false
        return bits.reversed().compactMap({ bit in
            guard !appearedNonZeroBit else { return bit }
            if bit != 0 {
                appearedNonZeroBit = true
                return bit
            } else {
                return nil
            }
        }).reversed()
    }

    func bitsToPCDecimal(intPart: BitArray, fractPart: BitArray) -> PCDecimal {
        let decimalValue = intPartToDecimal(intPart) + fractPartToDecimal(fractPart)
        return PCDecimal(value: decimalValue)
    }
    
    private func intPartToDecimal(_ intPart: BitArray) -> Decimal {
        return intPart.bits.enumerated().reduce(0) { partialResult, bit in
            return partialResult + Decimal(bit.element) * pow(2, bit.offset)
        }
    }
    
    private func fractPartToDecimal(_ fractPart: BitArray) -> Decimal {
        return fractPart.bits.enumerated().reduce(0) { partialResult, bit in
            return partialResult + Decimal(bit.element) * (1 / pow(2, bit.offset + 1))
        }
    }
}

// MARK: - BitArray

struct BitArray {
    
    private(set) var bits: [Bit]
    var bitWidth: UInt8 { UInt8(bits.count) }
    
    // MARK: - Init
    
    init(_ bitWidth: UInt8) {
        self.bits = Array(repeating: 0, count: Int(bitWidth))
    }
    
    init(bits: [Bit]) {
        self.bits = bits
    }
    
    init?(_ description: String) {
        if let parsedResult = Self.parseInputString(description) {
            self.bits = parsedResult.bits
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
    
    func groupedBits(bitsInGroup: Int) -> [[Bit]] {
        guard bitsInGroup > 0 else { return [] }
        
        let remainingBitsCount = bits.count % bitsInGroup
        let bitsToExpandCount = (remainingBitsCount == 0) ? 0 : (bitsInGroup - remainingBitsCount)
        
        let bitsToGroup = expandedBits(toWidth: UInt8(bits.count + bitsToExpandCount), withBit: 0)
        let numberOfGroups = bitsToGroup.count / bitsInGroup

        return (0..<numberOfGroups).map { groupCount in
            let groupRange = groupCount * bitsInGroup..<(groupCount + 1) * bitsInGroup
            return Array<Bit>(bitsToGroup[groupRange])
        }
    }
    
    func adjusted(toWidth bitWidth: UInt8, withBit bit: Bit) -> BitArray {
        guard bit == 0 || bit == 1 else { return self }
        
        let adjustedBits = bits.adjusted(toCount: Int(bitWidth), repeatingElement: bit)
        
        return BitArray(bits: adjustedBits)
    }
    
    func expanded(toWidth bitWidth: UInt8, withBit bit: Bit) -> BitArray {
        guard bitWidth > self.bitWidth else { return self }
        
        let expandedBits = expandedBits(toWidth: bitWidth, withBit: bit)
        
        return BitArray(bits: expandedBits)
    }
    
    private func expandedBits(toWidth bitWidth: UInt8, withBit bit: Bit) -> [Bit] {
        guard bitWidth > self.bitWidth, bit == 0 || bit == 1 else { return bits }
        
        return bits.expanded(toCount: Int(bitWidth), repeatingElement: bit)
    }

    mutating func append(_ bit: Bit) {
        bits.append(bit)
    }
    
    mutating func append(contentsOf newBits: [Bit]) {
        bits.append(contentsOf: newBits)
    }
    
    mutating func prepend(_ bit: Bit) {
        bits.insert(bit, at: 0)
    }
    
    mutating func prepend(contentsOf newBits: [Bit]) {
        bits.insert(contentsOf: newBits, at: 0)
    }
    
    mutating func removeFirst() {
        guard !bits.isEmpty else { return }
        
        bits.removeFirst()
    }
    
    mutating func removeFirst(_ k: Int) {
        guard !bits.isEmpty else { return }
        
        let elementsCount = k > bits.count ? bits.count : k
        bits.removeFirst(elementsCount)
    }
    
    mutating func removeLast() {
        guard !bits.isEmpty else { return }
        
        bits.removeLast()
    }
    
    mutating func removeLast(_ k: Int) {
        guard !bits.isEmpty else { return }
        
        let elementsCount = k > bits.count ? bits.count : k
        bits.removeLast(elementsCount)
    }
    
    func addingReportingOverflow(_ other: BitArray) -> (partialValue: BitArray, overflow: Bool) {
        let resultBitWidth = max(self.bitWidth, other.bitWidth)
        var result = BitArray(resultBitWidth)
        
        let lhsBits = self.expandedBits(toWidth: resultBitWidth, withBit: 0)
        let rhsBits = other.expandedBits(toWidth: resultBitWidth, withBit: 0)

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
    
    static func += (lhs: inout BitArray, rhs: BitArray) {
        lhs = lhs + rhs
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
        
        let lhsBits = lhs.expandedBits(toWidth: resultBitWidth, withBit: 0)
        let rhsBits = rhs.expandedBits(toWidth: resultBitWidth, withBit: 0)
        
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
    
    subscript(bounds: Range<Int>) -> ArraySlice<Bit> {
        get {
            assert(isBoundsValid(bounds), "Bounds out of range")
            return bits[bounds]
        }
    }
    
    func isIndexValid(_ index: Int) -> Bool {
        return index >= 0 && index < bits.count
    }
    
    func isBoundsValid(_ bounds: Range<Int>) -> Bool {
        return isIndexValid(bounds.lowerBound) && isIndexValid(bounds.upperBound - 1)
    }
}

extension BitArray: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Bit
    
    init(arrayLiteral bits: Bit...) {
        self.bits = bits
    }
}

extension BitArray: CustomStringConvertible {
    var description: String { toString() }
    
    private func toString() -> String {
        return bits.reversed().map({ String($0) }).joined()
    }
}
