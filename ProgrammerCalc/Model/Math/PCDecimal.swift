//
//  PCDecimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

class PCDecimal: CustomStringConvertible, Equatable {
    
    // MARK: - Properties
    var isSigned: Bool {
        return self.value < 0
    }

    private var value: Decimal {
        didSet {
            //print("PCDecimal new value: \(self)")
        }
    }

    var description: String {
        return String(describing: value)
    }
    
    init() {
        self.value = 0.0
    }
    
    init(value: Decimal) {
        self.value = value
    }
    
    init(_ uintValue: UInt64) {
        self.value = Decimal(uintValue)
    }

    // MARK: - Methods
    
    static func + (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        return PCDecimal(value: lhs.value + rhs.value)
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

        return  PCDecimal(lhsInt ^ rhsInt)
    }
    
    static func << (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart
        let rhsInt: UInt64 = rhs.value.intPart

        return  PCDecimal(lhsInt << rhsInt)
    }
    
    static func << (lhs: PCDecimal, rhs: Int) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart

        return  PCDecimal(lhsInt << rhs)
    }
    
    static func >> (lhs: PCDecimal, rhs: PCDecimal) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart
        let rhsInt: UInt64 = rhs.value.intPart

        return  PCDecimal(lhsInt >> rhsInt)
    }
    
    static func >> (lhs: PCDecimal, rhs: Int) -> PCDecimal {
        let lhsInt: UInt64 = lhs.value.intPart

        return  PCDecimal(lhsInt >> rhs)
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
    
    public func fixOverflow(bitWidth: Int, processSigned: Bool) {
        let maxValue = processSigned ? pow(Decimal(2), bitWidth-1) - 1 : pow(Decimal(2), bitWidth) - 1
        let minValue = processSigned ? pow(Decimal(-2), bitWidth-1) : 0
        
        if self.value > maxValue {
            var div = (self.value + maxValue + 1) / pow(Decimal(2), bitWidth)
            div = div.round(scale: 0, roundingModeMode: .down)
            self.value -= div * pow(Decimal(2), bitWidth)
            
            if !processSigned && self.value < minValue {
                self.value += pow(Decimal(2), bitWidth)
            }
        } else if self.value < minValue {
            var div = (self.value - minValue) / pow(Decimal(2), bitWidth)
            div = div.round(scale: 0, roundingModeMode: .down)
            self.value -= div * pow(Decimal(2), bitWidth)
            
            if !processSigned && self.value > maxValue {
                self.value -= pow(Decimal(2), bitWidth)
            }
        }
    }
    
    public func updateValue(_ newValue: Decimal) {
        self.value = newValue
    }
    
    public func getDecimal() -> Decimal {
        return self.value
    }
}
