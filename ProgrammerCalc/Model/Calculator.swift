//
//  Calculator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorProtocol {
    var mainLabelRawValue: NumberSystemProtocol! { get set }
    // State for processign signed values
    var processSigned: Bool { get set }
    // State for calculating numbers
    var mathState: MathStateProtocol? { get set }
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
    // Factory for NumberSystem from String value
    let numberSystemFactory: NumberSystemFactory = NumberSystemFactory()
    
    var mainLabelRawValue: NumberSystemProtocol!
    var processSigned = false // default value
    var mathState: MathStateProtocol?
    var systemMain: ConversionSystemsEnum?
    var systemConverter: ConversionSystemsEnum?
    
    // Taptic feedback generator for Errors
    private let errorGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Initialization
    
    init() {
        // Load from storage
        let calcState = calcStateStorage.safeGetData()
        let conversionSettings = conversionStorage.safeGetData()
        // Set states
        processSigned = calcState.processSigned
        systemMain = conversionSettings.systemMain
        systemConverter = conversionSettings.systemConverter
        // update mainLabel rawValue
        if let numValue = numberSystemFactory.get(strValue: calcState.mainLabelState, currentSystem: systemMain!) {
            mainLabelRawValue = numValue
        }
    }
    
    
    // MARK: - Methods
    
    // Calculate result
    fileprivate func calculateBuffWith(_ inputValue: NumberSystemProtocol, _  operation: CalcMath.Operation) -> String {
        var resultStr = String()
        // chek if math statate != nil
        guard self.mathState != nil else {
            self.mathState = MathState(buffValue: self.mainLabelRawValue, operation: operation)
            return inputValue.value
        }
        
        var result: NumberSystemProtocol?
        // Try calculate
        // And handle errors
        do {
            // process claculation buff values and previous operations
            result = try calculationHandler.calculate(firstValue: self.mathState!.buffValue, operation: self.mathState!.operation, secondValue: inputValue, for: self.systemMain!)
        } catch MathErrors.divByZero {
            // if division by zero
            self.mathState = nil
            self.mainLabelRawValue = nil
            // return message in labels
            let errorStr = MathErrors.divByZero.localizedDescription ?? NSLocalizedString("Cannot divide by zero", comment: "")
            // haptic feedback
            if settingsStorage.safeGetData().hapticFeedback {
                errorGenerator.notificationOccurred(.error)
            }
            
            return errorStr
        } catch {
            // else
        }
        
        // if result not error and not nil
        if let res = result {
            self.mathState = nil
            self.mathState = MathState(buffValue: inputValue, operation: operation)
            self.mathState?.lastResult = res
            resultStr = res.value
        }

        return resultStr
    }
    
    func calculateResult( inputValue: NumberSystemProtocol, operation: CalcMath.Operation) -> String {

        if operation == .shiftLeft || operation == .shiftRight {
            return calculateSoloBitwise(inputValue, operation)
        } else {
            return calculateBuffWith(inputValue, operation)
        }

    }
    
    fileprivate func calculateSoloBitwise(_ inputValue: NumberSystemProtocol, _ operation: CalcMath.Operation) -> String {
        return calculationHandler.shiftBits(value: inputValue, mainSystem: systemMain!, shiftOperation: operation, shiftCount: 1)!.value
    }
    
    // Convert operation name from button title to enum
    func getOperationBy(string: String) -> CalcMath.Operation? {
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

        // Get number by string input
        buffValue = numberSystemFactory.get(strValue: value, currentSystem: system)!
        // Convert number to Binary without formatting
        binaryValue = converter.convertValue(value: buffValue, from: system, to: .bin, format: false) as? Binary

        if let bin = binaryValue {
            let wordSizeValue = wordSizeStorage.getWordSizeValue()
            bin.value = bin.value.removeAllSpaces()
            // check for binary lenght for int part and fract part
            if !value.contains(".") {
                var testStr = String()
                
                // check if signed
                if calcStateStorage.safeGetData().processSigned && bin.value.count >= wordSizeValue {
                    let numIsSigned = bin.value.first! == "1" ? true : false
                    if numIsSigned {
                        let buffBin = Binary()
                        buffBin.value = bin.value
                        buffBin.twosComplement()
                        // remove first bit
                        buffBin.value.removeFirst(1)
                        testStr = buffBin.removeZerosBefore(str: buffBin.value)
                        // if == 0 then overflowed (min signed)
                        guard testStr != "0" else { return true }
                    }
                }
                // for unsigned
                if testStr == "" { testStr = bin.removeZerosBefore(str: bin.value) }
                   
                if system == .dec {
                    let oldValue = mainLabelRawValue as? DecimalSystem ?? DecimalSystem(0)
                    bin.updateSignedState()
                    let newValue = converter.convertValue(value: bin, from: .bin, to: system, format: true) as! DecimalSystem
                    // compare old value and new input value
                    // overflow if signs don't match
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
        
        // ==================
        // Process fract part
        // ==================
        
        // if last char is dot then append dot
        var lastSymbolsIfExists: String = inputStr.last == "." ? "." : ""
        // get str fract part
        var testLabelStr = inputStr.removeAllSpaces()
        let fractPartStr = testLabelStr.getPartAfter(divider: ".")

        let numbersAfterPoint = Int(conversionStorage.safeGetData().numbersAfterPoint)
        // cut fract part if more then numbersAfterPoint
        if fractPartStr.count > numbersAfterPoint && testLabelStr.contains(".") {
            testLabelStr = cutFractPart(strValue: testLabelStr, by: numbersAfterPoint)
        }
        
        // check if value contains .0
        if testLabelStr.contains(".0") {
            // check if fract == 0, or 00, 000 etc.
            if let fractPartInt = Int(fractPartStr.replacingOccurrences(of: ".", with: "")) {
                // replace lastSymbolsIfExists with old value of fract without updating it
                lastSymbolsIfExists = fractPartInt == 0 ? "." + fractPartStr : lastSymbolsIfExists
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
        
        // =======================
        // Process value by system
        // =======================
        
        if system == .bin {
            // get dummy bin without formatiing
            var bin: Binary = {
                let dummyBin = Binary()
                dummyBin.value = testLabelStr
                return dummyBin
            }()
            
            bin = converter.convertValue(value: bin, from: .bin, to: .bin, format: true) as! Binary
            
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
                // fill zeros to word size
                str = bin.fillUpZeros(str: intPart, to: wordSizeStorage.getWordSizeValue())
                str = str + "." + fractPart
                bin.value = str
            }
            // divide binary by parts
            bin = bin.divideBinary(by: 4)
            processedStr = bin.value
        } else if system == .dec && testLabelStr.contains(".") {
            // Updating dec for values with floating point
            processedStr = converter.processDecFloatStrToFormat(decStr: mainLabelRawValue.value, lastDotIfExists: lastSymbolsIfExists)
        } else if mainLabelRawValue != nil {
            // Convert value in binary
            // process binary raw string input in new binary with current settings: processSigned, wordSize etc.
            // convert back in systemMain value and set new value in mainLabel
            let bin = converter.convertValue(value: mainLabelRawValue, from: system, to: .bin, format: true) as! Binary
            let updatedValue = converter.convertValue(value: bin, from: .bin, to: system, format: true)
            processedStr = updatedValue!.value
            
            // compose new str value if exists
            processedStr = composePartsFrom(intPartFrom: processedStr, fractPartFrom: testLabelStr)
        }
        
        // ====================================
        // Check if value is float and negative
        // ====================================
        
        let testProcessed: NumberSystemProtocol? = numberSystemFactory.get(strValue: processedStr, currentSystem: system)
        
        if let testDec = converter.convertValue(value: testProcessed!, from: system, to: .dec, format: true) as? DecimalSystem {
            // check if is negative float value
            if testDec.value.contains(".") && testDec.decimalValue < 0 {
                // remove fract part from str
                processedStr = processedStr.getPartBefore(divider: ".")
                // if negative value is from 0.* then set it to zero
                if testDec.decimalValue > -1 && testDec.decimalValue < 0 { processedStr = "0" }
            }
        }
        
        return processedStr != "" ? processedStr : testLabelStr
    }
    
    private func composePartsFrom(intPartFrom: String, fractPartFrom: String) -> String {
        if intPartFrom.contains(".") && fractPartFrom.last != "." {
            let intPart = intPartFrom.getPartBefore(divider: ".")
            let fractPart = fractPartFrom.getPartAfter(divider: ".")
            return intPart + "." + fractPart
        } else {
            return intPartFrom
        }
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
