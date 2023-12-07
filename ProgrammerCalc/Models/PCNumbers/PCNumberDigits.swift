//
//  PCNumberDigits.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

typealias Digit = Character

protocol PCNumberDigits: PCNumber {
    var intDigits: DigitArray { get }
    var fractDigits: DigitArray { get }
    func formatted() -> String
    func formattedInput(bitWidth: UInt8) -> String
    func formattedOutput(bitWidth: UInt8, fractionalWidth: UInt8) -> String
    mutating func appendIntegerDigit(_ digit: Digit, bitWidth: UInt8, isSigned: Bool)
    mutating func appendFractionalDigit(_ digit: Digit, fractionalWidth: UInt8)
    mutating func removeLeastSignificantIntegerDigit()
    mutating func removeLeastSignificantFractionalDigit()
}

// MARK: - DigitArray

struct DigitArray {
    
    // MARK: - Properties

    private var digits: [Digit]
    
    var count: Int { digits.count }
    var isEmpty: Bool { digits.isEmpty }
    var hasOnlyOneZero: Bool { digits.count == 1 && digits[0] == "0" }
    var isAllZeros: Bool { !digits.contains(where: { $0 != "0" }) }
    var stringValue: String { toStringValue() }
    
    // MARK: - Init

    init() {
        self.digits = []
    }
    
    init(digits: [Digit]) {
        self.digits = digits
    }
    
    // MARK: - Methods

    private func toStringValue() -> String {
        return digits.reduce("") { partialValue, digit in
            return partialValue + "\(digit)"
        }
    }
    
    mutating func append(_ digit: Digit) {
        digits.append(digit)
    }
    
    mutating func prepend(_ digit: Digit) {
        digits.insert(digit, at: 0)
    }
    
    mutating func removeFirst() {
        guard !isEmpty else { return }
        
        digits.removeFirst()
    }
    
    mutating func removeFirst(_ k: Int) {
        guard !isEmpty else { return }
        
        let elementsCount = k > digits.count ? digits.count : k
        digits.removeFirst(elementsCount)
    }
    
    mutating func removeLast() {
        guard !isEmpty else { return }
        
        digits.removeLast()
    }
    
    mutating func removeLast(_ k: Int) {
        guard !isEmpty else { return }
        
        let elementsCount = k > digits.count ? digits.count : k
        digits.removeLast(elementsCount)
    }

    func removedTrailingZeroDigits() -> DigitArray {
        var appearedNonZeroDigit = false
        let newDigits: [Digit] = digits.reversed().compactMap({ digit in
            guard !appearedNonZeroDigit else { return digit }
            if digit != "0" {
                appearedNonZeroDigit = true
                return digit
            } else {
                return nil
            }
        }).reversed()
        
        return DigitArray(digits: newDigits)
    }
    
    subscript(_ index: Int) -> Digit {
        get {
            assert(isIndexValid(index), "Index out of range")
            return digits[index]
        }
        set {
            assert(isIndexValid(index), "Index out of range")
            digits[index] = newValue
        }
    }

    private func isIndexValid(_ index: Int) -> Bool {
        return index >= 0 && index < digits.count
    }
}

extension DigitArray: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Digit
    
    init(arrayLiteral elements: Digit...) {
        self.digits = elements
    }
}
