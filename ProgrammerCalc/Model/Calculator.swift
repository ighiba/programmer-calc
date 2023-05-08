//
//  Calculator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorProtocol {
    var currentValue: PCDecimal { get set }
    var operation: Calculator.CalcOperation? { get set }
}

class Calculator: CalculatorProtocol {
    
    class CalcOperation {
        var current: CalcMath.OperationType
        var previousValue: PCDecimal?
        var inputStart: Bool = false
        
        init(previousValue: PCDecimal, current: CalcMath.OperationType) {
            self.previousValue = previousValue
            self.current = current
        }
    }
    
    // MARK: - Properties
    
    var hasPendingOperation: Bool {
        if let operation = self.operation {
            return operation.current != .none
        } else {
            return false
        }
    }
    
    private let converter: Converter = Converter()
    private let calculationHandler: CalcMath = CalcMath()
    
    var mainLabelDelegate: CalculatorLabelDelegate!
    var converterLabelDelegate: CalculatorLabelDelegate!
    var pcalcViewControllerDelegate: PCalcViewControllerDelegate!

    let numberSystemFactory: NumberSystemFactory = NumberSystemFactory()
    let operationFactory: OperationFactory = OperationFactory()
    
    var currentValue: PCDecimal {
        didSet {
            print("PCDecimal new value: \(self.currentValue.getDecimal())")
            self.calcState.lastValue = self.currentValue
        }
    }
    
    var operation: CalcOperation?
    
    private let conversionSettings: ConversionSettings = ConversionSettings.shared
    private let calcState: CalcState = CalcState.shared
    private let wordSize: WordSize = WordSize.shared
    private let settings: Settings = Settings.shared

    private let errorGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Initialization
    
    init() {
        self.currentValue = calcState.lastValue
    }
    
    // MARK: - Methods
    
    public func getOperation(with buttonText: String) -> CalcMath.OperationType {
        return self.operationFactory.get(buttonLabel: buttonText)
    }
    
    public func setOperation(_ operationType: CalcMath.OperationType) {
        self.operation = CalcOperation(previousValue: PCDecimal(value: self.currentValue.getDecimal()) , current: operationType)
    }
    
    public func setOperation(with buttonText: String) {
        let operationType = getOperation(with: buttonText)
        self.setOperation(operationType)
    }
    
    public func calculate() {
        guard self.operation != nil else { return }
        
        do {
            var result = try self.calculateCurrentValue()
            result.fixOverflow(bitWidth: self.wordSize.value, processSigned: self.calcState.processSigned)
            self.operation?.previousValue = PCDecimal(value: result.getDecimal())
            self.operation?.inputStart = false
            self.currentValue = result
        } catch MathErrors.divByZero {
            self.resetCalculation()
            self.currentValue = PCDecimal(value: 0.0)
            self.setErrorInLabels(.divByZero)
            self.showErrorInLabels(.divByZero)
        } catch {
            
        }
    }
    
    private func showErrorInLabels(_ error: MathErrors) {
        self.mainLabelDelegate.showErrorInLabel(error.localizedDescription!)
        self.converterLabelDelegate.showErrorInLabel("NaN")
    }
    
    private func setErrorInLabels(_ error: MathErrors) {
        self.mainLabelDelegate.setError(error)
        self.converterLabelDelegate.setError(error)
    }
    
    func calculateCurrentValue() throws -> PCDecimal {
        guard let currentOperation = self.operation?.current else {
            return self.currentValue
        }

        // Unary operations
        switch currentOperation {
        case .oneS:
            return ~self.currentValue
        case .twoS:
            return ~self.currentValue + 1
        case .shiftLeft:
            return self.currentValue << 1
        case .shiftRight:
            return self.currentValue >> 1
        default:
            break
        }
        
        guard let previousValue = self.operation?.previousValue else {
            return self.currentValue
        }
        
        // Binary operations
        switch currentOperation {
        case .add:
            return previousValue + self.currentValue
        case .sub:
            return previousValue - self.currentValue
        case .mul:
            return previousValue * self.currentValue
        case .div:
            if self.currentValue != PCDecimal(0) {
                return previousValue / self.currentValue
            } else {
                throw MathErrors.divByZero
            }
        case .shiftLeftBy:
            return previousValue << self.currentValue
        case .shiftRightBy:
            return previousValue >> self.currentValue
        case .and:
            return previousValue & self.currentValue
        case .or:
            return previousValue | self.currentValue
        case .xor:
            return previousValue ^ self.currentValue
        case .nor:
            return ~(previousValue ^ self.currentValue)
        default:
            return self.currentValue
        }
    }
    
    public func negateCurrentValue() {
        self.currentValue = -self.currentValue
    }
    
    public func resetCurrentValue() {
        self.currentValue.updateValue(0.0)
    }
    
    public func updateCurrentValue(_ value: NumberSystemProtocol) {
        guard let decSystemValue = self.converter.convertValue(value: value, to: .dec, format: true) as? DecimalSystem else {
            return
        }
        self.currentValue.updateValue(decSystemValue.decimalValue)
    }
    
    public func getMainLabelValue() -> NumberSystemProtocol? {
        return converter.convertValue(value: self.currentValue, to: self.conversionSettings.systemMain, format: true)
    }
    
    public func getConvertedLabelValue() -> NumberSystemProtocol? {
        return converter.convertValue(value: self.currentValue, to: self.conversionSettings.systemConverter, format: true)
    }
    
    public func resetCalculation() {
        self.operation = nil
    }
    
    public func mainLabelUpdate() {
        let mainLabelValue = self.getMainLabelValue()?.value ?? "0"
        let formattedText = self.processStrInputToFormat(inputStr: mainLabelValue, for: self.conversionSettings.systemMain)
        self.mainLabelDelegate.setText(formattedText)
    }
    
    public func converterLabelUpdate() {
        let converterLabelValue = self.getConvertedLabelValue()?.value ?? "0"
        var formattedText = self.processStrInputToFormat(inputStr: converterLabelValue, for: self.conversionSettings.systemConverter)
        let mainLabelLastDigitIsDot = self.mainLabelDelegate.getText(deleteSpaces: true).last == "."
        
        if mainLabelLastDigitIsDot && !formattedText.contains(".")  {
            formattedText.append(".")
        }
        self.converterLabelDelegate.setText(formattedText)
    }
    
    public func mainLabelRemoveTrailing() {
        var mainLabelText: String = mainLabelDelegate.getText(deleteSpaces: false)
        
        if mainLabelText.count > 1 {
            mainLabelText.removeLast()
            if mainLabelText == "-" {
                mainLabelText = "0"
                self.pcalcViewControllerDelegate.updateClearButton(hasInput: false)
            } else if mainLabelText.last == " " {
                mainLabelText.removeLast()
            }
        } else {
            mainLabelText = "0"
            self.pcalcViewControllerDelegate.updateClearButton(hasInput: false)
        }

        if let numValue = numberSystemFactory.get(strValue: mainLabelText, currentSystem: conversionSettings.systemMain) {
            self.updateCurrentValue(numValue)
        }
        
        if mainLabelText.contains(".") {
            self.mainLabelDelegate.setText(mainLabelText)
        } else {
            self.mainLabelUpdate()
        }
        self.converterLabelUpdate()
    }
    
    public func mainLabelAdd(digit: String, inputStart: Bool = false) {
        let labelText = self.mainLabelDelegate.getText(deleteSpaces: false)
        var newValue: String
        
        if self.mainLabelDelegate.hasErrorMessage || inputStart {
            newValue = digit
        } else {
            newValue = self.addDigitToMainLabel(labelText: labelText, digit: digit)
        }
        
        let formattedText = self.processStrInputToFormat(inputStr: newValue, for: self.conversionSettings.systemMain)
        let newNumber = self.numberSystemFactory.get(strValue: formattedText, currentSystem: self.conversionSettings.systemMain)
        
        self.updateCurrentValue(newNumber!)
        self.mainLabelDelegate.setText(formattedText)
    }
    
    // Add digit to end of main label
    private func addDigitToMainLabel(labelText: String, digit: String) -> String {
        var result = String()

        if digit == "." && !labelText.contains(".") {
            // forbid float input when negative number
            if self.currentValue.isSigned {
                return labelText
            }
            return labelText + digit
        } else if digit == "." && labelText.contains(".") {
            return labelText
        }
        
        // special formatting for binary
        if conversionSettings.systemMain == .bin {
            var binary = Binary()
            binary.value = labelText
            // append input digit
            binary.appendDigit(digit)
            // divide binary by parts
            binary = binary.divideBinary(by: 4)
            result = binary.value
        } else {
            // if other systems
            result =  labelText + digit
        }
        
        // check if can add more digits
        let isOverflowed = self.isInputOverflowed(value: result, for: conversionSettings.systemMain)
        guard !isOverflowed else { return labelText }

        return result
    }
    
    
    // For updating input main label
    public func processStrInputToFormat(inputStr: String, for system: ConversionSystemsEnum) -> String {
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
            processedStr = converter.processDecFloatStrToFormat(decStr: inputStr, lastDotIfExists: lastSymbolsIfExists)
        } else {
            // Convert value in binary
            // process binary raw string input in new binary with current settings: processSigned, wordSize etc.
            // convert back in systemMain value and set new value in mainLabel
            let value = self.numberSystemFactory.get(strValue: inputStr, currentSystem: system)!
            let bin = self.converter.convertValue(value: value, to: .bin, format: true) as! Binary
            let updatedValue = self.converter.convertValue(value: bin, to: system, format: true)
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
    
    // Check if given number more than current settings allows
    public func isInputOverflowed(value: String, for system: ConversionSystemsEnum) -> Bool {
        if hasFloatingPoint(value) {
            return isFloatInputOverflowed(value)
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
    
    private func isFloatInputOverflowed(_ value: String) -> Bool {
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
        let oldValue = DecimalSystem(self.currentValue)
        bin.updateSignedState()
        let newValue = converter.convertValue(value: bin, to: .dec, format: true) as? DecimalSystem ?? DecimalSystem(0)
        // compare old value and new value
        // overflow if signs don't match
        if oldValue.isSigned != newValue.isSigned {
            return true
        }
        return false
    }
    
}
