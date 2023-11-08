//
//  PCDecimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

struct PCDecimal: CustomStringConvertible, Equatable, Decodable, Encodable {

    // MARK: - Properties
    
    static let zero: PCDecimal = PCDecimal(0)
    
    var isSigned: Bool { value < 0 }
    var hasFloatingPoint: Bool { value.description.contains(".") }
    var isSignedAndFloat: Bool { isSigned && hasFloatingPoint }
    
    private var value: Decimal

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
    
    static func + (lhs: PCDecimal, rhs: Int) -> PCDecimal {
        return PCDecimal(value: lhs.value + Decimal(rhs))
    }
    
    static func - (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value - rhs.value)
    }
    
    static func * (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value * rhs.value)
    }
    
    static func / (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value / rhs.value)
    }
    
    static func & (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart
        let rhsInt: UInt64 = rhs.value.intPart
        
        return PCDecimal(lhsInt & rhsInt)
    }
    
    static func | (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart
        let rhsInt: UInt64 = rhs.value.intPart
        
        return PCDecimal(lhsInt | rhsInt)
    }
    
    static func ^ (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart
        let rhsInt: UInt64 = rhs.value.intPart

        return PCDecimal(lhsInt ^ rhsInt)
    }
    
    static func << (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart
        let rhsInt: UInt64 = rhs.value.intPart

        return PCDecimal(lhsInt << rhsInt)
    }
    
    static func << (lhs: PCDecimal, rhs: Int) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart

        return PCDecimal(lhsInt << rhs)
    }
    
    static func >> (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart
        let rhsInt: UInt64 = rhs.value.intPart

        return PCDecimal(lhsInt >> rhsInt)
    }
    
    static func >> (lhs: PCDecimal, rhs: Int) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart

        return PCDecimal(lhsInt >> rhs)
    }
    
    static prefix func ~ (number: PCDecimal) -> PCDecimal {
        let numberInt: UInt64 = number.value.intPart
 
        return PCDecimal(~numberInt)
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
        let maxValue = processSigned ? pow(Decimal(2), bitWidth-1) - 1 : pow(Decimal(2), bitWidth) - 1
        let minValue = processSigned ? pow(Decimal(-2), bitWidth-1) : 0
        
        if value > maxValue {
            var div = (value + maxValue + 1) / pow(Decimal(2), bitWidth)
            div = div.round(scale: 0, roundingModeMode: .down)
            value -= div * pow(Decimal(2), bitWidth)
            
            if !processSigned && value < minValue {
                value += pow(Decimal(2), bitWidth)
            }
        } else if value < minValue {
            var div = (value - minValue) / pow(Decimal(2), bitWidth)
            div = div.round(scale: 0, roundingModeMode: .down)
            value -= div * pow(Decimal(2), bitWidth)
            
            if !processSigned && value > maxValue {
                value -= pow(Decimal(2), bitWidth)
            }
        }
    }
    
    public mutating func updateValue(_ value: Decimal) {
        self.value = value
    }
    
    public func getDecimal() -> Decimal {
        return value
    }
}
