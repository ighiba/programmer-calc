//
//  Calculator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol CalculatorProtocol {
    var mainLabelRawValue: NumberSystemProtocol! { get set }
    // State for processign signed values
    var processSigned: Bool { get set }
    // State for calculating numbers
    var mathState: CalcMath.MathState? { get set }
    // State for conversion systems in labels
    var systemMain: ConversionSystemsEnum? { get set }
    var systemConverter: ConversionSystemsEnum? { get set }
    
}

class Calculator: CalculatorProtocol {
    
    // MARK: - Properties
    
    enum OverflowVariants {
        case input
        case negate
    }
    
    // Storages
    private let settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private let calcStateStorage: CalcStateStorageProtocol = CalcStateStorage()
    private let conversionStorage: ConversionStorageProtocol = ConversionStorage()
    private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    
    // Object "Converter"
    private let converter: Converter = Converter()
    
    private let calculationHandler: CalcMath = CalcMath()
    
    var mainLabelRawValue: NumberSystemProtocol! // TODO: Error handling
    var processSigned = false // default value
    var mathState: CalcMath.MathState?
    var systemMain: ConversionSystemsEnum?
    var systemConverter: ConversionSystemsEnum?
    
    // MARK: - Initialization
    
    
    // MARK: - Methods
    
    
    // Calculate result
    fileprivate func calculateBuffWith(_ inputValue: NumberSystemProtocol,_  operation: CalcMath.MathOperation) -> String {
        var resultStr = String()
        // chek if math statate == nil
        guard self.mathState != nil else {
            self.mathState = CalcMath.MathState(buffValue: self.mainLabelRawValue, operation: operation)
            return inputValue.value
            
        }
        
        // process claculation buff values and previous operations
        print("calculation")
        var result: NumberSystemProtocol?
        // Try calculate
        // And handle errors
        do {
            result = try calculationHandler.calculate(firstValue: self.mathState!.buffValue, operation: self.mathState!.operation, secondValue: inputValue, for: self.systemMain!)
        } catch MathErrors.divByZero {
            // if division by zero
            self.mathState = nil
            self.mainLabelRawValue = nil
            // return message in labels
            let error = MathErrors.divByZero.localizedDescription ?? NSLocalizedString("Cannot divide by zero", comment: "")
            return error
        } catch {
            // else
        }
        
        // if result not error and not nil
        if result != nil {
            self.mathState = nil
            self.mathState = CalcMath.MathState(buffValue: inputValue, operation: operation)
            self.mathState?.lastResult = result
            resultStr = result!.value
        }

        return resultStr
    }
    
    func calculateResult( inputValue: NumberSystemProtocol, operation: CalcMath.MathOperation) -> String {

        if operation == .shiftLeft || operation == .shiftRight {
            return calculateSoloBitwise(inputValue, operation)
        } else {
            return calculateBuffWith(inputValue, operation)
        }

    }
    
    fileprivate func calculateSoloBitwise(_ inputValue: NumberSystemProtocol, _ operation: CalcMath.MathOperation) -> String {
        return calculationHandler.shiftBits(value: inputValue, mainSystem: systemMain!, shiftOperation: operation, shiftCount: 1)!.value
    }
    
    // Convert operation name from button title to enum
    func getOperationBy(string: String) -> CalcMath.MathOperation? {
        switch string {
        case "÷":
            return.div
        case "×":
            return .mul
        case "-":
            return .sub
        case "+":
            return .add
        case "X<<Y":
            return .shiftLeftBy
        case "X>>Y":
            return .shiftRightBy
        case "<<":
            return .shiftLeft
        case ">>":
            return .shiftRight
        case "AND":
            return .and
        case "OR":
            return .or
        case "XOR":
            return .xor
        case "NOR":
            return .nor
        default:
            return nil
        }
    }
    
    // Check if given number more than current settings allows
    func isValueOverflowed(value: String, for system: ConversionSystemsEnum, when variant: OverflowVariants) -> Bool {
        let buffValue: NumberSystemProtocol
        var binaryValue: Binary?
        // TODO: Refactor Create NumberSystem by factory?
        switch system {
        case .bin:
            let dummyBin = Binary()
            dummyBin.value = value
            binaryValue = Binary(dummyBin)
            break
        case .oct:
            buffValue = Octal(stringLiteral: value)
            binaryValue = Binary(buffValue as! Octal)
            break
        case .dec:
            buffValue = DecimalSystem(stringLiteral: value)
            binaryValue = Binary(buffValue as! DecimalSystem)
            break
        case .hex:
            buffValue = Hexadecimal(stringLiteral: value)
            binaryValue = Binary(buffValue as! Hexadecimal)
            break
        }

        if let bin = binaryValue {
            let wordSizeValue = wordSizeStorage.getWordSizeValue()
            bin.value = bin.value.removeAllSpaces()
            // check for binary lenght for int part and fract part
            if !value.contains(".") {
                var testStr = String()
                
                // check if signed
                if calcStateStorage.safeGetData().processSigned {
                    if bin.value.count >= wordSizeValue {
                        let numIsSigned = bin.value.first! == "1" ? true : false
                        if numIsSigned {
                            let buffBin = Binary()
                            buffBin.value = bin.value
                            buffBin.twosComplement()
                            // remove first bit
                            buffBin.value.removeFirst(1)
                            testStr = buffBin.removeZerosBefore(str: buffBin.value)
                        }
                    }
                }
                // for unsigned
                if testStr == "" { testStr = bin.removeZerosBefore(str: bin.value) }
                   
                if system == .dec {
                    let oldValue = mainLabelRawValue as? DecimalSystem ?? DecimalSystem(0)
                    bin.updateSignedState()
                    let newValue = converter.convertValue(value: bin, from: .bin, to: system) as! DecimalSystem
                    
                    if oldValue.isSigned != newValue.isSigned && variant != .negate {
                        return true
                    } else if variant == .negate && !bin.isSigned {
                        return testStr.count >= wordSizeValue ? true : false
                    }
                }

                return testStr.count <= wordSizeValue ? false : true
            // for binary with floating point
            } else {
                // input allowed if last symol is "."
                guard value.last != "." else { return false }

                // check if fract part fits in numbersAfterPoint setting
                let testStr = value.removeAllSpaces()
                let numbersAfterPoint = Int(conversionStorage.safeGetData().numbersAfterPoint)
                let fractPartCount = testStr.getPartAfter(divider: ".").count
                // compare values
                return fractPartCount <= numbersAfterPoint ? false : true
                  
            }
        }
        return false
    }
    
    func negateValue(value: NumberSystemProtocol, system: ConversionSystemsEnum) -> String {
        return calculationHandler.negate(value: value, system: system).value
    }
    
    
    // For updating input main label
    func processStrInputToFormat(inputStr: String, for system: ConversionSystemsEnum) -> String {
        var processedStr = String()
        
        // Process fract part
        // if last char is dot then append dot
        var lastSymbolsIfExists: String = inputStr.last == "." ? "." : ""
        // get str fract part
        var testLabelStr = inputStr.removeAllSpaces()
        let fractPartStr: String = testLabelStr.getPartAfter(divider: ".")

        let numbersAfterPoint = Int(conversionStorage.safeGetData().numbersAfterPoint)
        // cut fract part if more then numbersAfterPoint
        if fractPartStr.count > numbersAfterPoint && testLabelStr.contains(".") {
            testLabelStr = cutFractPart(strValue: testLabelStr, by: numbersAfterPoint)
        }
        
        
        // check if value .0
        if testLabelStr.contains(".0") {
            // check if fract == 0, or 00, 000 etc.
            if Int(fractPartStr.replacingOccurrences(of: ".", with: ""))! == 0 {
                // replace lastSymbolsIfExists with old value of fract without updating it
                lastSymbolsIfExists = "." + fractPartStr
            }
            // continue to process as normal
        } else if testLabelStr.last == "0" && testLabelStr.contains(".") {
            // count how much zeros in back
            let buffFract = String(fractPartStr.reversed())
            lastSymbolsIfExists = ""
            for digit in buffFract {
                if digit == "0" {
                    lastSymbolsIfExists.append(digit)
                } else {
                    break
                }
            }
            
        }
        
        // Process values by system
        
        if system == .bin {
            
            var bin: Binary = {
                let dummyBin = Binary()
                dummyBin.value = testLabelStr
                return dummyBin
            }()
            bin = converter.convertValue(value: bin, from: .bin, to: .bin) as! Binary
            
            // delete trailing zeros if contains .
            if bin.value.contains(".") {
                var str = bin.value.removeAllSpaces()
                let splittedBinary = bin.divideIntFract(value: str)
                // remove zeros in intpart
                var intPart = splittedBinary.0!
                intPart = intPart.removeLeading(characters: ["0"])
                if intPart == "" { intPart = "0" }
                // remove zeros in fract part
                let fractPart = testLabelStr.removeAllSpaces().getPartAfter(divider: ".")
                
                str = bin.fillUpZeros(str: intPart, to: wordSizeStorage.getWordSizeValue())
                str = str + "." + fractPart
                
                bin.value = str
            }
            
            // divide binary by parts
            bin = bin.divideBinary(by: 4)
            
            processedStr = bin.value
            // updating dec for values with floating point
        } else if system == .dec && testLabelStr.contains(".") {
            
            processedStr = converter.processDecFloatStrToFormat(decStr: self.mainLabelRawValue.value, lastDotIfExists: lastSymbolsIfExists)
            
        } else {
            // TODO: Refactor
            // Convert any non-float value in binary
            // process binary raw string input in new binary with current settings: processSigned, wordSize etc.
            // convert back in systemMain value and set new value in mainLabel
            if self.mainLabelRawValue != nil {
                let bin = converter.convertValue(value: self.mainLabelRawValue, from: system, to: .bin) as! Binary
                //let updatedBin = Binary(stringLiteral: bin!.value)
                let updatedValue = converter.convertValue(value: bin, from: .bin, to: system)
                processedStr = updatedValue!.value
                
                if processedStr.contains(".") && testLabelStr.last != "." {
                    let intPart = processedStr.getPartBefore(divider: ".")
                    let fractPart = testLabelStr.getPartAfter(divider: ".")
                    processedStr = intPart + "." + fractPart
                }
                
                
            }
        }
        
        // Check if float and negative
        // TODO: Refactor to factory
        let testProcessed: NumberSystemProtocol? = getNumberBy(strValue: processedStr, currentSystem: system)
        
        if let testDec = converter.convertValue(value: testProcessed!, from: system, to: .dec) as? DecimalSystem {
            if testDec.value.contains(".") && testDec.decimalValue < 0 {
                print("negative and float")
                // remove fract part from str
                print(processedStr)
                processedStr = processedStr.getPartBefore(divider: ".")
                print(processedStr)
                if testDec.decimalValue > -1 && testDec.decimalValue < 0 {
                    processedStr = "0"
                }
            }
        }
        
        return processedStr != "" ? processedStr : testLabelStr
    }
    
    func getNumberBy(strValue value: String, currentSystem system: ConversionSystemsEnum) -> NumberSystemProtocol? {
        var buffValue: NumberSystemProtocol?
        
        switch system {
        case .bin:
            let dummyBin = Binary()
            dummyBin.value = value
            buffValue = Binary(dummyBin)
            break
        case .oct:
            buffValue = Octal(stringLiteral: value)
            break
        case .dec:
            buffValue = DecimalSystem(stringLiteral: value)
            break
        case .hex:
            buffValue = Hexadecimal(stringLiteral: value)
            break
        }
        
        return buffValue
        
    }
    
    // Cutting fract part of float number by max number of digits after .
    private func cutFractPart(strValue: String, by count: Int) -> String {
        var result = strValue
        var fractPartStr: String = strValue.getPartAfter(divider: ".")
        while fractPartStr.count > count {
            fractPartStr.removeLast(1)
            if fractPartStr.count == count {
                // create new inputStr
                let intPart = strValue.getPartBefore(divider: ".")
                result = intPart + "." + fractPartStr
                break
            }
        }
        return result
    }
}
