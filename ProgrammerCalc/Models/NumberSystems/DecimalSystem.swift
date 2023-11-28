//
//  DecimalSystem.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 30.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

final class DecimalSystem: NumberSystemProtocol {

    // MARK: - Properties

    var decimalValue: Decimal
    
    var value: String
    var isSigned: Bool = false

    // MARK: - Init
    
    /// Creates an instance initialized to the String
    required init(stringLiteral: String) {
        self.value = stringLiteral
        self.decimalValue = Decimal(string: stringLiteral) ?? Decimal(0)
        self.updateIsSignedState()
    }

    /// Creates an instance initialized to the Decimal value
    init(_ decimal: Decimal) {
        self.decimalValue = decimal
        self.value = "\(self.decimalValue)"
        self.updateIsSignedState()
    }
    
    /// Creates an instance initialized to the Int  value
    init(_ int: Int) {
        self.decimalValue = Decimal(int)
        self.value = "\(self.decimalValue)"
        self.updateIsSignedState()
    }
    
    /// Creates an instance initialized to the Binary value
    init(_ binary: Binary) {
        self.decimalValue = binary.convertBinaryToDec()
        self.value = "\(self.decimalValue)"
        self.updateIsSignedState()
    }
    
    /// Creates an instance initialized to the DecimalSystem value
    init(_ decimalSystem: DecimalSystem) {
        self.decimalValue = decimalSystem.decimalValue
        self.value = "\(self.decimalValue)"
        self.isSigned = decimalSystem.isSigned
    }
    
    /// Creates an instance initialized to the PCDecimal value
    init(_ pcDecimal: PCDecimal) {
        self.decimalValue = pcDecimal.getDecimal()
        self.value = "\(self.decimalValue)"
        self.updateIsSignedState()
    }
    
    // MARK: - Methods
    
    private func updateIsSignedState() {
        if decimalValue < 0 {
            isSigned = true
        } else {
            isSigned = false
        }
    }
    
    func toBinary() -> Binary {
        // if value is signed then remove minus for converting
        updateIsSignedState()
        if isSigned {
            decimalValue = abs(decimalValue)
        }
        
        let decimalValueStr = "\(decimalValue)"
        var binary = Binary()
        
        let binaryStr: String = {
            if decimalValueStr.contains(".") {
                let splittedDoubleStr = divideIntFract(str: decimalValueStr)
                return binary.convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            } else {
                return binary.convertDecToBinary(decimalValue)
            }
        }()
        
        binary = Binary(stringLiteral: binaryStr)
        
        // return minus to decimal if isSigned
        if isSigned {
            decimalValue *= -1
        }
        
        let splittedBinaryStr = divideIntFract(str: binary.value)
        
        if let intPart = splittedBinaryStr.intPart {
            binary = processBinaryIntPart(binary, intPart: intPart)
        }
        
        if let fractPart = splittedBinaryStr.fractPart {
            binary = processBinaryFractPart(binary, fractPart: fractPart)
        }

        return binary
    }
    
    private func processBinaryIntPart(_ binary: Binary, intPart: IntPart) -> Binary {
        binary.value = binary.removeZerosBefore(str: intPart)
        binary.isSigned = isSigned
        binary.fillUpToMaxBitsCount()

        if isSigned {
            binary.twosComplement()
        }
        
        return binary
    }
    
    private func processBinaryFractPart(_ binary: Binary, fractPart: FractPart) -> Binary {
        var resultFractPart = fractPart
        
        if isSigned {
            let invertedFractPart = fractPart.swap(first: "1", second: "0")
            resultFractPart = "\(invertedFractPart)"
        }
        
        binary.value = "\(binary.value).\(resultFractPart)"
        
        return binary
    }

    func removeFractPart() -> Decimal {
        let roundedDecimal: Decimal
        
        if decimalValue > 0 {
            roundedDecimal = decimalValue.rounded(.down)
        } else {
            roundedDecimal = decimalValue.rounded(.up)
        }
        
        let fractPart = decimalValue - roundedDecimal

        setNewDecimal(with: roundedDecimal)

        return fractPart
    }
    
    func setNewDecimal(with newDecimalValue: Decimal) {
        decimalValue = newDecimalValue
        value = "\(newDecimalValue)"
        updateIsSignedState()
    }
}
