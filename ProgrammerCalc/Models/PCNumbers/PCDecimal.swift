//
//  PCDecimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

struct PCDecimal: PCNumber, PCNumberDigits, Equatable, Codable {

    enum CodingKeys: String, CodingKey {
        case value
    }

    // MARK: - Properties
    
    static let zero: PCDecimal = 0
    
    var description: String { String(describing: value) }

    var pcDecimalValue: PCDecimal { self }

    var isNegative: Bool { value < 0 }
    
    private(set) var value: Decimal = 0

    private var intPart: UInt64 { value.intPart }
    
    private(set) var intDigits: DigitArray = []
    private(set) var fractDigits: DigitArray = []
    
    // MARK: - Initialization
    
    init() {
        self.setupFrom(value: 0)
    }

    init(pcDecimal: PCDecimal) {
        let value = pcDecimal.value
        self.setupFrom(value: value)
    }
    
    init(pcDecimal: PCDecimal, bitWidth: UInt8, isSigned: Bool) {
        let value = pcDecimal.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned).value
        self.setupFrom(value: value)
    }
    
    init(value: Decimal) {
        self.setupFrom(value: value)
    }
    
    init(_ uintValue: UInt64) {
        self.setupFrom(value: Decimal(uintValue))
    }
    
    init(_ int64Value: Int64) {
        self.setupFrom(value: Decimal(int64Value))
    }
    
    init?(string: String) {
        if let value = Decimal(string: string) {
            self.setupFrom(value: value)
        } else {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(Decimal.self, forKey: .value)
        self.setupFrom(value: value)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.value, forKey: .value)
    }

    // MARK: - Methods
    
    mutating private func setupFrom(value: Decimal) {
        self.value = value
        self.intDigits = extractIntegerDigits(from: value)
        self.fractDigits = extractFractionalDigits(from: value)
    }
    
    mutating func reset() {
        setupFrom(value: 0)
    }

    func formatted() -> String {
        let integerString = intDigits.stringValue.reversedString()
        let fractionalString = fractDigits.stringValue

        return composeDecimalString(integerString: integerString, fractionalString: fractionalString, isNegative: isNegative)
    }
    
    func formattedInput(bitWidth: UInt8) -> String {
        return formatted()
    }
    
    func formattedOutput(bitWidth: UInt8, fractionalWidth: UInt8) -> String {
        return formatted()
    }
    
    private func extractIntegerDigits(from decimal: Decimal) -> DigitArray {
        let roundedDecimal = abs(decimal).rounded(.down)
        let stringDecimal = String(describing: roundedDecimal)
        let digits: [Digit] = stringDecimal.reversed().map { $0 }
        
        return DigitArray(digits: digits)
    }
    
    private func extractFractionalDigits(from decimal: Decimal) -> DigitArray {
        let floatPart = decimal.floatPart
        let stringFloatPart = String(describing: floatPart).replacingOccurrences(of: "0.", with: "")
        let digits: [Digit] = stringFloatPart.map { $0 }
        
        return DigitArray(digits: digits).removedTrailingZeroDigits()
    }
    
    mutating func appendIntegerDigit(_ digit: Digit, bitWidth: UInt8, isSigned: Bool) {
        guard canAppendIntegerDigit(digit, bitWidth: bitWidth, isSigned: isSigned) else { return }
        
        let integerString = intDigits.stringValue.reversedString() + "\(digit)"
        let fractionalString = fractDigits.stringValue

        let newStringDecimal = composeDecimalString(integerString: integerString, fractionalString: fractionalString, isNegative: isNegative)

        if let newDecimal = Decimal(string: newStringDecimal) {
            value = newDecimal
            if intDigits.isAllZeros {
                intDigits = [digit]
            } else {
                intDigits.prepend(digit)
            }
        }
    }
    
    mutating func appendFractionalDigit(_ digit: Digit, fractionalWidth: UInt8) {
        guard canAppendFractionalDigit(digit, fractionalWidth: fractionalWidth) else { return }
        
        let integerString = intDigits.stringValue.reversedString()
        let fractionalString = fractDigits.stringValue + "\(digit)"

        let newStringDecimal = composeDecimalString(integerString: integerString, fractionalString: fractionalString, isNegative: isNegative)

        if let newDecimal = Decimal(string: newStringDecimal) {
            value = newDecimal
            fractDigits.append(digit)
        }
    }
    
    private func canAppendIntegerDigit(_ digit: Digit, bitWidth: UInt8, isSigned: Bool) -> Bool {
        guard digit.isDecDigit else { return false }
        
        let bitWidth = Int(bitWidth)
        let minValue = isSigned ? pow(-2, bitWidth - 1) : 0
        let maxValue = isSigned ? pow(2, bitWidth - 1) - 1 : pow(2, bitWidth) - 1

        let sign = isNegative ? "-" : ""
        let integerString = sign + intDigits.stringValue.reversedString() + "\(digit)"
      
        if let newIntegerDecimalValue = Decimal(string: integerString) {
            return newIntegerDecimalValue >= minValue && newIntegerDecimalValue <= maxValue
        }

        return false
    }
    
    private func canAppendFractionalDigit(_ digit: Digit, fractionalWidth: UInt8) -> Bool {
        return digit.isDecDigit && fractDigits.count < fractionalWidth
    }
    
    mutating func removeLeastSignificantIntegerDigit() {
        guard !intDigits.hasOnlyOneZero else { return }
        
        intDigits.removeFirst()

        var integerString = intDigits.stringValue.reversedString()
        if integerString.isEmpty {
            integerString = "0"
            intDigits.prepend("0")
        }
        
        let fractionalString = fractDigits.stringValue

        let newStringDecimal = composeDecimalString(integerString: integerString, fractionalString: fractionalString, isNegative: isNegative)

        if let newDecimal = Decimal(string: newStringDecimal) {
            value = newDecimal
        }
    }
    
    mutating func removeLeastSignificantFractionalDigit() {
        guard !fractDigits.isEmpty else { return }
        
        fractDigits.removeLast()
        
        let integerString = intDigits.stringValue.reversedString()
        let fractionalString = fractDigits.stringValue
        
        let newStringDecimal = composeDecimalString(integerString: integerString, fractionalString: fractionalString, isNegative: isNegative)

        if let newDecimal = Decimal(string: newStringDecimal) {
            value = newDecimal
        }
    }
    
    private func composeDecimalString(integerString: String, fractionalString: String, isNegative: Bool) -> String {
        let sign = isNegative ? "-" : ""
        
        if fractionalString.isEmpty {
            return "\(sign)\(integerString)"
        } else {
            return "\(sign)\(integerString).\(fractionalString)"
        }
    }

    static func + (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value + rhs.value)
    }
    
    static func + (lhs: PCDecimal, rhsInt: Int) -> PCDecimal {
        return PCDecimal(value: lhs.value + Decimal(rhsInt))
    }
    
    static func - (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value - rhs.value)
    }
    
    static func - (lhs: PCDecimal, rhsInt: Int) -> PCDecimal {
        return PCDecimal(value: lhs.value - Decimal(rhsInt))
    }
    
    static func * (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value * rhs.value)
    }
    
    static func / (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value / rhs.value)
    }
    
    static func & (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(lhs.intPart & rhs.intPart)
    }
    
    static func | (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(lhs.intPart | rhs.intPart)
    }
    
    static func ^ (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(lhs.intPart ^ rhs.intPart)
    }
    
    static func << (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(lhs.intPart << rhs.intPart)
    }
    
    static func << (lhs: PCDecimal, rhsInt: Int) -> PCDecimal {
        return PCDecimal(lhs.intPart << rhsInt)
    }
    
    static func >> (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(lhs.intPart >> rhs.intPart)
    }
    
    static func >> (lhs: PCDecimal, rhsInt: Int) -> PCDecimal {
        return PCDecimal(lhs.intPart >> rhsInt)
    }
    
    static prefix func ~ (number: PCDecimal) -> PCDecimal {
        return PCDecimal(~number.intPart)
    }
    
    static prefix func - (number: PCDecimal) -> PCDecimal {
        return PCDecimal(value: number.value * -1)
    }
    
    static func == (lhs: PCDecimal, rhs: PCDecimal) -> Bool {
        return lhs.value == rhs.value
    }
    
    static func != (lhs: PCDecimal, rhs: PCDecimal) -> Bool {
        return lhs.value != rhs.value
    }
    
    static func > (lhs: PCDecimal, rhs: PCDecimal) -> Bool {
        return lhs.value > rhs.value
    }
    
    static func < (lhs: PCDecimal, rhs: PCDecimal) -> Bool {
        return lhs.value < rhs.value
    }
    
    mutating func fixOverflow(bitWidth: UInt8, isSigned: Bool) {
        value = fixDecimalOverflow(for: value, bitWidth: bitWidth, isSigned: isSigned)
    }
    
    public func fixedOverflow(bitWidth: UInt8, isSigned: Bool) -> PCDecimal {
        let fixedValue = fixDecimalOverflow(for: value, bitWidth: bitWidth, isSigned: isSigned)
        
        return PCDecimal(value: fixedValue)
    }
    
    private func fixDecimalOverflow(for decimalValue: Decimal, bitWidth: UInt8, isSigned: Bool) -> Decimal {
        let bitWidth = Int(bitWidth)
        let maxValue = isSigned ? pow(2, bitWidth - 1) - 1 : pow(2, bitWidth) - 1
        let minValue = isSigned ? pow(-2, bitWidth - 1) : 0
        
        guard decimalValue < minValue || decimalValue > maxValue else { return decimalValue }
        
        var valueToFix = decimalValue
        
        if valueToFix > maxValue {
            var div = (valueToFix + maxValue + 1) / pow(2, bitWidth)
            div = div.rounded(.down)
            valueToFix -= div * pow(2, bitWidth)
            
            if !isSigned && valueToFix < minValue {
                valueToFix += pow(2, bitWidth)
            }
        } else if valueToFix < minValue {
            var div = (valueToFix - minValue) / pow(2, bitWidth)
            div = div.rounded(.down)
            valueToFix -= div * pow(2, bitWidth)
            
            if !isSigned && valueToFix > maxValue {
                valueToFix -= pow(2, bitWidth)
            }
        }
        
        return valueToFix
    }
    
    public mutating func updateValue(_ value: Decimal) {
        self.value = value
    }
}

extension PCDecimal: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int64
    
    init(integerLiteral value: Int64) {
        self.init(value: Decimal(value))
    }
}
