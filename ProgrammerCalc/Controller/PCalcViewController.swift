//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcViewController: UIViewController {
    
    var mathState: MathState?
    let calcView: PCalcView = PCalcView()
    lazy var mainLabel: UILabel = calcView.mainLabel
    lazy var converterLabel: UILabel = calcView.converterLabel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view from PCalcView
        self.view = calcView
        // get state from UserDefaults
        getCalcState()

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // set state to UserDefaults
        print("main dissapear")
        saveCalcState()
    }
    
    // =======
    // Methods
    // =======
    
    // Update conversion values
    fileprivate func getCalcState() {
        // get data from UserDefaults
        if let data = SavedData.calcState {
            // TODO: Error handling
            mainLabel.text = data.mainLabelState
            converterLabel.text = data.converterLabelState

        }  else {
            print("no settings")
            // Save default settings (all zero)
            SavedData.calcState = CalcState(mainState: "0", convertState: "0")
        }
    }
    
    public func saveCalcState() {
        // TODO: Error handling
        let mainState = mainLabel.text ?? "0"
        let convertState = converterLabel.text ?? "0"
        
        // set data to UserDefaults
        SavedData.calcState = CalcState(mainState: mainState, convertState: convertState)
    }
    
    fileprivate func updateConverterLabel() {
        // TODO: Refator hadling for Hexadecimal values
        if Double(mainLabel.text!) == nil {
            converterLabel.text = mainLabel.text
        } else {
            // Uptade converter label with converted number
            // TODO: Error handling
            if let settings = SavedData.conversionSettings {
                let fromSystem = settings.systemMain
                let toSystem = settings.systemConverter
                converterLabel.text = convertValue(value: mainLabel.text!, from: fromSystem, to: toSystem)
            }
        }
    }
    
    // Main function for conversion values
    fileprivate func convertValue(value valueStr: String, from mainSystem: String, to converterSystem: String) -> String? {
        // exit if systems are equal
        guard mainSystem != converterSystem else {
            return valueStr
        }
        
        // =======================================
        // First step: convert any value to binary
        // =======================================
        let binaryStr = convertAnyToBinary(anyStr: valueStr, anySystem: mainSystem)
        
        // ==================================================
        // Second step: convert binary value to needed system
        // ==================================================
        
        let resultStr = convertBinaryToAny(binaryStr: binaryStr, targetSystem: converterSystem)
        
        return resultStr
    }
    
    // Converter from any to binary system
    fileprivate func convertAnyToBinary( anyStr: String, anySystem: String) -> String {
        var binaryStr: String
        
            switch anySystem {
            case "Binary":
                // if already binary
                binaryStr = anyStr
                break
            case "Octal":
                // convert oct to binary
                binaryStr = self.convertOctToBinary(octNumStr: anyStr)
                break
            case "Decimal":
                // convert dec to binary
                binaryStr = self.convertDecToBinary(decNumStr: anyStr)
                break
            case "Hexadecimal":
                // convert hex to binary
                binaryStr = "0"
                break
            default:
                // do nothing
                // TODO: Error handling
                binaryStr = "0"
                break
            }

        return binaryStr
    }
    
    // Converter from binary to any system
    fileprivate func convertBinaryToAny( binaryStr: String, targetSystem: String) -> String {
        var targetStr: String
        
            switch targetSystem {
            case "Binary":
                // convert binary to binary
                targetStr = binaryStr
                break
            case "Octal":
                // convert binary to oct
                targetStr = self.convertBinToOct(binNumStr: binaryStr)
                break
            case "Decimal":
                // convert binary to dec
                targetStr = "0"
                targetStr = self.convertBinToDec(binNumStr: binaryStr)
                break
            case "Hexadecimal":
                // convert binary to hex
                targetStr = "Hexadecimal"
                break
            default:
                // do nothing
                // TODO: Error handling
                targetStr = "err"
                break
            }
        
        return targetStr
    }
    
    // ======
    // Binary
    // ======
    
    // BIN -> DEC
    fileprivate func convertBinToDec( binNumStr: String) -> String {
        var resultStr: String
        
        // if zero
        guard binNumStr != "0" else {
            return "0"
        }
     
        // Dividing to int and fract parts
        let buffDividedStr = divideToDoubleInt(str: binNumStr)
        var binIntStrBuff = buffDividedStr.0
        
        var buffInt = 0
        var buffDecimal: Decimal = 0.0
        var counter = 0
       
        guard binIntStrBuff != nil else {
            return "Error"
        }
        
        binIntStrBuff = String((binIntStrBuff?.reversed())!)
        
        // First: converting int part
        // constructing decimal
        binIntStrBuff?.forEach { (num) in
            // TODO: Error handling
            let buffNum = Float(String(num))!
            // 1 * 2^n
            let buffValue = Int(buffNum * pow(2, Float(counter)))
            
            buffInt += buffValue
            
            counter += 1
        }
        
        // Second: converting fract part
        if let binFractStrBuff = buffDividedStr.1 {
            // if fract == 0 then dont calc it
            guard Int(binFractStrBuff) != 0 else {
                resultStr = "\(buffInt).0"
                return resultStr
            }
            
            counter = 1
            
            binFractStrBuff.forEach { (num) in
                // TODO: Error handling
                let buffInt = Int("\(num)")!
                let buffIntDecimal = Decimal(integerLiteral: buffInt)
                // 1 * 2^-n
                let buffValue: Decimal = buffIntDecimal *  ( 1.0 / pow(2 as Decimal, counter))
                
                buffDecimal += buffValue
                
                counter += 1
            }
            // return decimal if second value after dividing is nil
            resultStr = "\(Decimal(buffInt) + buffDecimal)"
            return resultStr
            
        } else {
            // return int
            resultStr = "\(buffInt)"
            return resultStr
        }
    }
    
    // DEC -> BIN
    fileprivate func convertDecToBinary( decNumStr: String) -> String {
        var decNumStrBuff = decNumStr
        var isSigned: Bool = false
        var binaryStr: String
        
        
        // if number is signed
        if decNumStr.contains("-") {
            let minusIndex = decNumStr.firstIndex(of: "-")
            decNumStrBuff.remove(at: minusIndex!)
            isSigned = true
        }
        
        if let decNumInt: Int = Int(decNumStrBuff) {
            binaryStr = convertIntToBinary(number: decNumInt)
        } else {
            // TODO   Error handling
            let splittedDoubleStr: (String?, String?) = divideToDoubleInt(str: decNumStrBuff)
            binaryStr = convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            
        }
        
        // handle minus sign and invert value
        if isSigned {
            // reverse 1 and 0 values
            var binaryStrBuff: String = String()
            binaryStr.forEach { (char) in
                switch char {
                case "0":
                    binaryStrBuff.append("1")
                    break
                case "1":
                    binaryStrBuff.append("0")
                    break
                default:
                    binaryStrBuff.append(char)
                    break
                }
            }
            
            // add 1 to beginning and replace binaryStr
            binaryStrBuff = "1" + binaryStrBuff
            binaryStr = binaryStrBuff
            
            // TODO: Delete end zeros for float binary nums
        }
        
        
        print(binaryStr)
        
        return binaryStr
    }
    
    // converter for number before the point
    
    fileprivate func convertIntToBinary( number: Int) -> String {
        var divisible: Int = number
        var reminder: Int = 0
        var resultStr: String = String()
        
        // divide by 2
        while divisible != 0 && divisible != 1 {
            reminder = divisible % 2
            divisible = divisible / 2
            resultStr.append(contentsOf: String(reminder))
        }
        
        // if no divide
        if divisible == 0 || divisible == 1 {
            resultStr.append(contentsOf: String(divisible))
            resultStr = String(resultStr.reversed())
        }
        
        // Divide number by parts
        // if count of digits more than or equal to 1 AND number not 0
        if resultStr.count >= 1 && resultStr != "0" {
            var counter: Int = 0
            var buffStr: String = String()
            
            resultStr = String(resultStr.reversed())
            
            resultStr.forEach { (char) in
                if counter == 3 {
                    buffStr.append("\(char) ")
                    counter = 0
                } else {
                    buffStr.append(char)
                    counter += 1
                }
            }
            // add zeros before for filling th parts
            if counter > 0 {
                for _ in 0...3-counter {
                    buffStr.append("0")
                }
            }
            resultStr = String(buffStr.reversed())
        }
        return resultStr
    }
    
    fileprivate func convertFractToBinary( numberStr: String, precision: Int) -> String {
        var buffDouble: Double
        var buffStr: String = "0."
        var resultStr: String = String()
       
        // if 0 then dont calculate
        if Int(numberStr) == 0 {
            resultStr = "0"
        } else {
            // number of digits after point
            let counter: Int = precision
            // form double string
            buffStr.append(numberStr)
            buffDouble = Double(buffStr)!
                   
            // convert fract part of number
            // multiply by 2, if bigger then 1 then = 1, else 0
            for _ in 0..<counter {
                buffDouble = buffDouble * 2
                if buffDouble >= 1 {
                    resultStr.append("1")
                    buffDouble = buffDouble - 1
                } else {
                    resultStr.append("0")
                }
             }
            // remove ending zeros
//            while resultStr[resultStr.index(before: resultStr.endIndex)] == "0" && resultStr.count > 1 {
//                resultStr.remove(at: resultStr.index(before: resultStr.endIndex))
//            }
        }
        
        // Divide number by parts
        // if count of digits more than or equal to 1 AND number not 0
        if resultStr.count >= 1 && resultStr != "0" {
            var counter: Int = 0
            buffStr = String()
            
            resultStr.forEach { (char) in
                if counter == 3 {
                    buffStr.append("\(char) ")
                    counter = 0
                } else {
                    buffStr.append(char)
                    counter += 1
                }
            }
            
            // add zeros after for filling th parts
            if counter > 0 {
                for _ in 0...3-counter {
                    buffStr.append("0")
                }
            }
            resultStr = buffStr
        }
        
        
        print(resultStr)
        return resultStr
    }
    
    // Combine to parts to double string
    fileprivate func convertDoubleToBinaryStr( numberStr: (String?, String?)) -> String {
        // Error handling
        guard numberStr.0 != nil else {
            return "Error"
        }
        guard numberStr.1 != nil else {
            return "Error"
        }
        let intNumber = Int(numberStr.0!)!
        

        return "\(convertIntToBinary(number: intNumber)).\(convertFractToBinary(numberStr: numberStr.1!, precision: Int(SavedData.conversionSettings?.numbersAfterPoint ?? 8)))"
    }
    
    // Dividing string variable and converting it to double without loss of precision
    fileprivate func divideToDoubleInt( str: String) -> (String?, String?) {
        
        var strInt: String
        var strFract: String

        // check for floating point
//        guard str.contains(".") else {
//            return nil
//        }
           
        // search index of floating pos
        if let pointPos = str.firstIndex(of: ".") {
            // fill strInt
            strInt = String(str[str.startIndex..<pointPos])
               
            // fill strFract
            strFract = String(str[pointPos..<str.endIndex])
            // delete .
            strFract.remove(at: strFract.startIndex)
            
            print(" \(strInt)...\(strFract)")
            return (strInt, strFract)
 
        } else {
            // if is int
            print("no float, return int and nil")
            return (str, nil)
        }

    }
    
    // filling up number with zeros by num of zeros in 1 part
    fileprivate func fillUpParts(by fillNum: Int , _ str: String) -> String {
        
        if str == "0" {
            return str
        }
        // remove all spaces
        var buffStr = ""
        str.forEach { (char) in
            // if char != space then ok
            if char != " " {
                buffStr.append(char)
            }
        }
        
        // remove all zeros at beginning of string
        while buffStr.first == "0" {
            buffStr.removeFirst(1)
        }
        
        var counter = 0
        // count how much 0 is need for filling
        buffStr.forEach({ (num) in
            if counter == fillNum - 1 {
                    counter = 0
                } else {
                    counter += 1
                }
            })
        
        // reverse string
        buffStr = String(buffStr.reversed())
        // add zeros after for filling th parts
        if counter > 0 {
            for _ in 0...fillNum-counter-1 {
                buffStr.append("0")
            }
        }
        // reverse again for result
        buffStr = String(buffStr.reversed())
        
        return buffStr
    }
    
    // =====
    // Octal
    // =====
    
    // Convert form oct with table helper
    // Convert to oct with table helper
    fileprivate func convertOctTable(str: String, toBinary: Bool) -> String {
        var buffStr = str
        var buffResultStr = String()
        
        // octal table
        // from 0 to 7
        let table = ["000", "001", "010", "011", "100", "101", "110", "111"]
        
        if toBinary {
            // from octal to binary
            // process each number and form parts
            buffStr.forEach { (num) in
                if num != "." {
                    for (index, value) in table.enumerated() {
                        if Int("\(num)") == index {
                            // append balue from table
                            buffResultStr.append(value)
                        }
                    }
                } else {
                    // append .
                    buffResultStr.append(num)
                }
            }
        } else {
            // from binary to octal
            let intParts = Int(buffStr.count / 3)
            // process each part
            // part is 3 digits
            for _ in 0..<intParts {
                var partCounter = 0
                var buffPart = String()
                // get first 3 chars
                while partCounter < 3 {
                    buffPart.append(buffStr.first!)
                    // delete first char
                    buffStr.remove(at: buffStr.startIndex)
                    
                    partCounter += 1
                }
                // convert these 3 chars (part) into Octal by using table
                for (index, value) in table.enumerated() {
                    if buffPart == value {
                        // append index from table
                        buffResultStr.append(String(index))
                        break
                    }
                }
            }
        }
        return buffResultStr
    }
    
    // OCT -> BIN
    fileprivate func convertOctToBinary(octNumStr: String) -> String {
        return convertOctTable(str: octNumStr, toBinary: true)
    }
    
    // TODO: Refactor to table
    // BIN -> OCT
    fileprivate func convertBinToOct( binNumStr: String) -> String {
        var resultStr: String
        
        // if zero
        guard binNumStr != "0" else {
            return "0"
        }
     
        // Dividing to int and fract parts
        let buffDividedStr = divideToDoubleInt(str: binNumStr)
        var binIntStrBuff = buffDividedStr.0
        
        var resultIntStr = String()
        var resultFractStr = String()
        
       
        guard binIntStrBuff != nil else {
            return "Error"
        }
        
        // delete zeros from parts by 4 and filling up by 3
        binIntStrBuff = fillUpParts(by: 3, binIntStrBuff!)
        
        // First: converting int part
        // dont count if zero
        if binIntStrBuff == "0" {
            resultIntStr = "0"
        } else {
            // First: converting int part
           resultIntStr = convertOctTable(str: binIntStrBuff!, toBinary: true)
        }
        
        
        
        // Second: converting fract part
        if let binFractStrBuff = buffDividedStr.1 {
            // Check for zero in fract
            guard binFractStrBuff != "0" else {
                return "\(resultIntStr).\(binFractStrBuff)"
            }
            
            var strBuff = binFractStrBuff
            // reverse for conversion
            strBuff = String(strBuff.reversed())
            // delete zeros from parts by 4 and filling up by 3
            strBuff = fillUpParts(by: 3, strBuff)
            // reverse back
            strBuff = String(strBuff.reversed())
            // add zeros to end
            resultFractStr = convertOctTable(str: strBuff, toBinary: true)
            
            // if low precise
            // TODO: Make advice to slider with number of digits
            if resultFractStr == "" {
                resultFractStr = "0"
            }
            
            resultStr = "\(resultIntStr).\(resultFractStr)"
            return resultStr
            
        } else {
            // return int
            resultStr = "\(resultIntStr)"
            return resultStr
        }
    }
    
    // Calculation of 2 decimal numbers by .operation
    // TODO: Make error handling for overflow
    fileprivate func calculateDecNumbers( firstNum: String, secondNum: String, operation: MathState.mathOperation) -> String? {
        var resultStr: String = String()
        
        let firstDecimal = Decimal(string: firstNum)
        let secondDecimal = Decimal(string: secondNum)
        
        switch operation {
        // Addition
        case .add:
            resultStr = "\(firstDecimal! + secondDecimal!)"
            break
        // Subtraction
        case .sub:
            resultStr = "\(firstDecimal! - secondDecimal!)"
            break
        // Multiplication
        case .mul:
            resultStr = "\(firstDecimal! * secondDecimal!)"
            break
        // Division
        case .div:
            // if dvision by zero
            guard secondDecimal != 0 else {
                // TODO Make error code and replace hardcode
                return "Division by zero"
            }
            resultStr = "\(firstDecimal! / secondDecimal!)"
            break
    
        }
        
        return resultStr
    }
    
    // =======
    // Actions
    // =======
    
    @objc func toucUpOutsideAction( sender: UIButton) {
        //print("touchUpOutside")
        //sender.backgroundColor = .red
        //sender.isHighlighted = false
    }
    
    // Numeric buttons actions
    
    @objc func numericButtonTapped( sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        let convertLabel = converterLabel
        // tag for AC/C button
        let acButton = self.view.viewWithTag(100) as! UIButton
        
        print("Button \(buttonText) touched")
        
        // if error mesage in label
        // TODO: Better Error handling
        if Double(label.text!) == nil {
            if buttonText == "." {
                label.text = "0."
            } else {
                label.text = buttonText
            }
            updateConverterLabel()
            return
        }
        
        // bool calculates overflowing of mainLabel number for int and float value
        let isOverflowed: Bool = {
            let str = label.text!
            // handle for ints
            if Int(str) != nil {
                if str.count > 11 {
                    // if already overflowing, but point button is touched
                    guard buttonText != "." else {return false}
                    return true
                }
            // handle for floats
            } else if str.contains(".") {
                // search index of floating pos
                let pointPos: String.Index = str.firstIndex(of: ".")!
                let numsAfterPoint: Int = str.distance(from: str.endIndex, to: pointPos)
                
                if abs(numsAfterPoint) > 12 {
                    return true
                }
            }
            return false
        }()
        
        if mathState != nil {
            // if new value not inputed
            if !mathState!.inputStart {
                
                switch buttonText {
                case ".":
                    label.text = "0."
                    break
                default:
                    label.text = buttonText
                    break
                }
                mathState!.inputStart = true
            } else {
                // handle for number of digits in mainLabel
                if isOverflowed {
                    print("too much digits")
                    return
                }
                switch label.text! {
                case "0":
                    if buttonText.contains(".") {
                        label.text! += buttonText
                        convertLabel.text! += buttonText
                        acButton.setTitle("C", for: .normal)
                    } else if buttonText != "0" {
                         // if 0 pressed then do nothing
                        label.text! = buttonText
                        acButton.setTitle("C", for: .normal)
                    }
                    break
                default:
                    if label.text!.contains(".") && buttonText == "." {
                        break
                    } else {
                        label.text! += buttonText
                        convertLabel.text! += buttonText
                    }
                    acButton.setTitle("C", for: .normal)
                    break
                }
            }
            
        } else {

            if isOverflowed {
                print("too much digits")
                return
            }
            switch label.text! {
            case "0":
                if buttonText.contains(".") {
                    label.text! += buttonText
                    convertLabel.text! += buttonText
                    acButton.setTitle("C", for: .normal)
                } else if buttonText != "0" {
                     // if 0 pressed then do nothing
                    label.text! = buttonText
                    acButton.setTitle("C", for: .normal)
                }
                break
            default:
                if label.text!.contains(".") && buttonText == "." {
                    break
                } else {
                    label.text! += buttonText
                    convertLabel.text! += buttonText
                }
                acButton.setTitle("C", for: .normal)
                break
            }
        }
        
        
        // Update value in converter label
        
        if buttonText != "." {
            updateConverterLabel()
        }
        
    }
    
    // Sign buttons actions
    
    @objc func signButtonTapped( sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        let convertLabel = converterLabel
        // tag for AC/C button
        let acButton = self.view.viewWithTag(100) as! UIButton
        
        print("Button \(buttonText) touched")
        
        // if error mesage in label
        // TODO: Better Error handling
        if Double(label.text!) == nil {
            label.text! = "0"
            convertLabel.text! = "0"
            acButton.setTitle("AC", for: .normal)
            mathState = nil
        }
        
        switch buttonText {
        // Clear buttons
        case "AC":
            label.text! = "0"
            convertLabel.text! = "0"
            mathState = nil
            break
        case "C":
            label.text! = "0"
            convertLabel.text! = "0"
            button.setTitle("AC", for: .normal)
            mathState = nil
            break
        // Invert button
        case "\u{00B1}":
            if label.text != "0" {
                // if number is already signed
                // TODO: Error handling
                if label.text!.contains("-") {
                    let minusIndex = label.text!.firstIndex(of: "-")
                    label.text!.remove(at: minusIndex!)
                } else {
                    // just add minus
                    label.text = "-" + label.text!
                }
            }
            updateConverterLabel()
            break
        // Subtraction button
        case "\u{00f7}":
            // calc results
            if mathState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = MathState(buffValue: label.text!, operation: .div)
                    mathState?.lastResult = result
                }
            } else {
                mathState = MathState(buffValue: label.text!, operation: .div)
            }
            break
        // Multiplication button
        case "X":
            // calc results
            if mathState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = MathState(buffValue: label.text!, operation: .mul)
                    mathState?.lastResult = result
                }
            } else {
                mathState = MathState(buffValue: label.text!, operation: .mul)
            }
            break
        // Multiplication button
        case "-":
            // calc results
            if mathState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = MathState(buffValue: label.text!, operation: .sub)
                    mathState?.lastResult = result
                }
            } else {
                mathState = MathState(buffValue: label.text!, operation: .sub)
            }
            break
        // Addition button
        case "+":
            // calc results
            if mathState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = MathState(buffValue: label.text!, operation: .add)
                    mathState?.lastResult = result
                }
            } else {
                mathState = MathState(buffValue: label.text!, operation: .add)
            }
            break
        case "=":
            if mathState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                }
                // reset state
                mathState = nil
            } else {
                print("do nothing")
            }
            break
        default:
            break
        }
        
    }
    
    // Change conversion button tapped
    @objc func changeButtonTapped( sender: UIButton) {
        print("Start changing conversion")
        // initialize vc popover
        let vc = ConversionViewController()
        
        // present settings
        //vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        
        // show popover
        self.present(vc, animated: false, completion: nil)
    }
    
    // Settings button tapped
    @objc func settingsButtonTapped( sender: UIButton) {
        print("Open settings")
        // initialize vc popover
        let vc = SettingsViewController()
        
        //vc.navigationController?.show(vc, sender: self)
        // present settings
        vc.modalPresentationStyle = .pageSheet
        //self.present(vc, animated: true, completion: nil)
        
        let navigationController = UINavigationController()
        navigationController.setViewControllers([vc], animated: false)
        //navigationController.navigationBar.setItems([], animated: false)
        self.present(navigationController, animated: true)
    }

}







