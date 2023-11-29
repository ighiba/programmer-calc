//
//  PCDecimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

struct PCDecimal: CustomStringConvertible, Equatable, Codable {

    // MARK: - Properties
    
    static let zero: PCDecimal = 0
    
    var isSigned: Bool { value < 0 }
    var hasFloatingPoint: Bool { value.description.contains(".") }
    var isSignedAndFloat: Bool { isSigned && hasFloatingPoint }
    
    private var value: Decimal
    public var decimalValue: Decimal { value }
    fileprivate var intPart: UInt64 { value.intPart }

    var description: String { String(describing: value) }
    
    // MARK: - Initialization
    
    init() {
        self.value = 0.0
    }
    
    init(value: Decimal) {
        self.value = value
    }
    
    init(_ uintValue: UInt64) {
        self.value = Decimal(uintValue)
    }
    
    init(_ int64Value: Int64) {
        self.value = Decimal(int64Value)
    }
    
    init?(string: String) {
        if let value = Decimal(string: string) {
            self.value = value
        } else {
            return nil
        }
    }

    // MARK: - Methods
    
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
    
    public mutating func fixOverflow(bitWidth: Int, processSigned: Bool) {
        let maxValue = processSigned ? pow(Decimal(2), bitWidth - 1) - 1 : pow(Decimal(2), bitWidth) - 1
        let minValue = processSigned ? pow(Decimal(-2), bitWidth - 1) : 0
        
        if value > maxValue {
            var div = (value + maxValue + 1) / pow(Decimal(2), bitWidth)
            div = div.rounded(.down)
            value -= div * pow(Decimal(2), bitWidth)
            
            if !processSigned && value < minValue {
                value += pow(Decimal(2), bitWidth)
            }
        } else if value < minValue {
            var div = (value - minValue) / pow(Decimal(2), bitWidth)
            div = div.rounded(.down)
            value -= div * pow(Decimal(2), bitWidth)
            
            if !processSigned && value > maxValue {
                value -= pow(Decimal(2), bitWidth)
            }
        }
    }
    
    public mutating func updateValue(_ value: Decimal) {
        self.value = value
    }
}

extension PCDecimal: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int64
    
    init(integerLiteral value: Int64) {
        self.value = Decimal(value)
    }
}
