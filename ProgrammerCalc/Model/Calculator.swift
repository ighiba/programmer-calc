//
//  Calculator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorProtocol {
    var inputValue: NumberSystemProtocol! { get set }
    // State for calculating numbers
    var mathState: MathStateProtocol? { get set }
}

class Calculator: CalculatorProtocol {
    
    // MARK: - Properties
    
    // Object "Converter"
    private let converter: Converter = Converter()
    // Object "CalcMath"
    private let calculationHandler: CalcMath = CalcMath()
    // Factory for NumberSystem from String value
    let numberSystemFactory: NumberSystemFactory = NumberSystemFactory()
    
    var inputValue: NumberSystemProtocol!
    var mathState: MathStateProtocol?
    
    private let conversionSettings: ConversionSettings = ConversionSettings.shared
    private let calcState: CalcState = CalcState.shared
    private let wordSize: WordSize = WordSize.shared
    private let settings: Settings = Settings.shared
    
    // Taptic feedback generator for Errors
    private let errorGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Initialization
    
    init() {

        // update mainLabel numberValue (inputValue)
        if let numValue = numberSystemFactory.get(strValue: calcState.mainLabelState, currentSystem: conversionSettings.systemMain) {
            inputValue = numValue
        }
    }
    
    
    // MARK: - Methods
    
    // Calculate result
    fileprivate func calculateBuffWith(_ inputValue: NumberSystemProtocol, _  operation: CalcMath.Operation) -> String {
        var resultStr = String()
        // chek if math statate != nil
        guard self.mathState != nil else {
            self.mathState = MathState(buffValue: self.inputValue, operation: operation)
            return inputValue.value
        }
        
        var result: NumberSystemProtocol?
        // Try calculate
        // And handle errors
        do {
            // process claculation buff values and previous operations
            result = try calculationHandler.calculate(firstValue: self.mathState!.buffValue, operation: self.mathState!.operation, secondValue: inputValue, for: conversionSettings.systemMain)
        } catch MathErrors.divByZero {
            // if division by zero
            self.mathState = nil
            self.inputValue = nil
            // return message in labels
            let errorStr = MathErrors.divByZero.localizedDescription ?? NSLocalizedString("Cannot divide by zero", comment: "")
            // haptic feedback
            if settings.hapticFeedback {
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
    
    public func calculateResult( inputValue: NumberSystemProtocol, operation: CalcMath.Operation) -> String {
        if isBitwiseOperation(operation) {
            return calculateSoloBitwise(inputValue, operation)
        } else {
            return calculateBuffWith(inputValue, operation)
        }
    }
    
    private func isBitwiseOperation(_ operation: CalcMath.Operation) -> Bool {
        return operation == .shiftLeft || operation == .shiftRight
    }
    
    fileprivate func calculateSoloBitwise(_ inputValue: NumberSystemProtocol, _ operation: CalcMath.Operation) -> String {
        return calculationHandler.shiftBits(number: inputValue, mainSystem: conversionSettings.systemMain, shiftOperation: operation, shiftCount: DecimalSystem(1))!.value
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
    public func isValueOverflowed(value: String, for system: ConversionSystemsEnum) -> Bool {
        if hasFloatingPoint(value) {
            return isFloatValueOverflowed(value)
        } else {
            let buffValue = numberSystemFactory.get(strValue: value, currentSystem: system)
            guard buffValue != nil else { return true }
            // Convert number to Binary without formatting
            let bin = buffValue!.toBinary()
            bin.value = bin.value.removeAllSpaces()
            
            return isNonFloatBinOverflowed(bin)
        }
    }
    
    private func hasFloatingPoint(_ value: String) -> Bool {
        return value.contains(".")
    }
    
    private func isFloatValueOverflowed(_ value: String) -> Bool {
        // input allowed if last symol is "."
        guard value.last != "." else { return false }
        // check if fract part fits in numbersAfterPoint setting
        let testStr = value.removeAllSpaces()
        let numbersAfterPoint = Int(conversionSettings.numbersAfterPoint)
        let fractPartCount = testStr.getPartAfter(separator: ".").count
        // compare values
        return fractPartCount <= numbersAfterPoint ? false : true
    }
    
    private func isNonFloatBinOverflowed(_ bin: Binary) -> Bool {
        // check if binary has minimal possible signed value with current wordsize
        // if true, then is overflowed
        if checkIfMinSigned(bin) {
            return true
        }
        
        // check decimal overflowing
        if conversionSettings.systemMain == .dec && decChangedSign(bin) {
            return true
        }
        
        var testStr = bin.removeZerosBefore(str: bin.value)
        
        if bin.isSigned {
            bin.twosComplement() // convert to positive value
            testStr = bin.removeZerosBefore(str: bin.value)
        }
        
        return testStr.count <= wordSize.value ? false : true
    }
    
    private func checkIfMinSigned(_ bin: Binary) -> Bool {
        if calcState.processSigned && bin.value.count >= wordSize.value && binIsSigned(bin) {
            var testStr = String()
            let binBuff = Binary(bin)
            binBuff.twosComplement()
            // remove first signed bit
            binBuff.value.removeFirst(1)
            testStr = binBuff.removeZerosBefore(str: binBuff.value)
            // if == 0 then overflowed (min signed)
            guard testStr != "0" else { return true }
        }
        return false
    }
    
    private func binIsSigned(_ bin: Binary) -> Bool {
        return bin.value.first! == "1" ? true : false
    }
    
    private func decChangedSign(_ bin: Binary) -> Bool {
        let oldValue = inputValue as? DecimalSystem ?? DecimalSystem(0)
        bin.updateSignedState()
        let newValue = converter.convertValue(value: bin, to: .dec, format: true) as? DecimalSystem ?? DecimalSystem(0)
        // compare old value and new value
        // overflow if signs don't match
        if oldValue.isSigned != newValue.isSigned {
            return true
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
        let fractPartStr = testLabelStr.getPartAfter(separator: ".")

        let numbersAfterPoint = Int(conversionSettings.numbersAfterPoint)
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
            
            bin = converter.convertValue(value: bin, to: .bin, format: true) as! Binary
            
            // delete trailing zeros if contains .
            if bin.value.contains(".") {
                var str = bin.value.removeAllSpaces()
                let splittedBinary = bin.divideIntFract(value: str)
                // remove zeros in intpart
                var intPart = splittedBinary.0!
                intPart = intPart.removeLeading(characters: ["0"])
                if intPart == "" { intPart = "0" }
                // remove zeros in fract part
                let fractPart = testLabelStr.removeAllSpaces().getPartAfter(separator: ".")
                // fill zeros to word size
                str = bin.fillUpZeros(str: intPart, to: wordSize.value)
                str = str + "." + fractPart
                bin.value = str
            }
            // divide binary by parts
            bin = bin.divideBinary(by: 4)
            processedStr = bin.value
        } else if system == .dec && testLabelStr.contains(".") {
            // Updating dec for values with floating point
            processedStr = converter.processDecFloatStrToFormat(decStr: inputValue.value, lastDotIfExists: lastSymbolsIfExists)
        } else if inputValue != nil {
            // Convert value in binary
            // process binary raw string input in new binary with current settings: processSigned, wordSize etc.
            // convert back in systemMain value and set new value in mainLabel
            let bin = converter.convertValue(value: inputValue, to: .bin, format: true) as! Binary
            let updatedValue = converter.convertValue(value: bin, to: system, format: true)
            processedStr = updatedValue!.value
            
            // compose new str value if exists
            processedStr = composePartsFrom(intPartFrom: processedStr, fractPartFrom: testLabelStr)
        }
        
        // ====================================
        // Check if value is float and negative
        // ====================================
        
        let testProcessed: NumberSystemProtocol? = numberSystemFactory.get(strValue: processedStr, currentSystem: system)
        
        if let testDec = converter.convertValue(value: testProcessed!, to: .dec, format: true) as? DecimalSystem {
            // check if is negative float value
            if testDec.value.contains(".") && testDec.decimalValue < 0 {
                // remove fract part from str
                processedStr = processedStr.getPartBefore(separator: ".")
                // if negative value is from 0.* then set it to zero
                if testDec.decimalValue > -1 && testDec.decimalValue < 0 { processedStr = "0" }
            }
        }
        
        return processedStr != "" ? processedStr : testLabelStr
    }
    
    private func composePartsFrom(intPartFrom: String, fractPartFrom: String) -> String {
        if intPartFrom.contains(".") && fractPartFrom.last != "." {
            let intPart = intPartFrom.getPartBefore(separator: ".")
            let fractPart = fractPartFrom.getPartAfter(separator: ".")
            return intPart + "." + fractPart
        } else {
            return intPartFrom
        }
    }
    
    // Cutting fract part of float number by max number of digits after .
    private func cutFractPart(strValue: String, by count: Int) -> String {
        var result = strValue
        var fractPartStr: String = strValue.getPartAfter(separator: ".")
        while fractPartStr.count > count {
            fractPartStr.removeLast(1)
            if fractPartStr.count == count {
                // create new inputStr
                let intPart = strValue.getPartBefore(separator: ".")
                result = intPart + "." + fractPartStr
                break
            }
        }
        return result
    }
}
