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
                binaryStr = self.convertOctToBin(octNumStr: anyStr)
                break
            case "Decimal":
                // convert dec to binary
                binaryStr = self.convertDecToBinary(decNumStr: anyStr)
                break
            case "Hexadecimal":
                // convert hex to binary
                binaryStr = self.convertHexToBin(hexNumStr: anyStr)
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
                targetStr = self.convertBinToOctHex(binNumStr: binaryStr, targetSystem: .oct)
                break
            case "Decimal":
                // convert binary to dec
                targetStr = "0"
                targetStr = self.convertBinToDec(binNumStr: binaryStr)
                break
            case "Hexadecimal":
                // convert binary to hex
                targetStr = self.convertBinToOctHex(binNumStr: binaryStr, targetSystem: .hex)
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
        
        // remove all spaces
        let str = removeAllSpaces(str: binNumStr)
     
        // Dividing to int and fract parts
        let buffDividedStr = divideToDoubleInt(str: str)
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
            if let buffNum = Float("\(num)") {
                // 1 * 2^n
                let buffValue = Int(buffNum * pow(2, Float(counter)))
                
                buffInt += buffValue
                
                counter += 1
            }
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
    
    // Converter for number before the point
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
        
        // divide it by parts with 4 digits each
        if resultStr.count >= 1 && resultStr != "0" {
            resultStr = String(resultStr.reversed())
            resultStr = divideStr(str: resultStr, by: 4)
            resultStr = String(resultStr.reversed())
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
        
        resultStr = divideStr(str: resultStr, by: 4)
        
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
    
    // Divide number by parts
    fileprivate func divideStr( str: String, by partition: Int) -> String {
        var resultStr = str
        var buffStr = String()

        // if count of digits more than or equal to 1 AND number not 0
        if str.count >= 1 && str != "0" {
            var counter: Int = 0
       
            for char in resultStr {
                // check if already point
                if char == "." {
                    counter = 0
                    buffStr.append(char)
                    continue
                }
                // if ok
                if counter == partition-1 {
                    buffStr.append("\(char) ")
                    counter = 0
                } else {
                    buffStr.append(char)
                    counter += 1
                }
            }
            
            // add zeros after for filling the parts
            if counter > 0 {
                for _ in 0...partition-counter-1 {
                    buffStr.append("0")
                }
            }
            
            // delete space before and after .
            if buffStr.contains(".") {
                var pointPos = buffStr.firstIndex(of: ".")!
                
                var pointBuff = buffStr.index(before: pointPos)
                
                // delete space before if exists
                if buffStr[pointBuff] == " " {
                    buffStr.remove(at: pointBuff)
                }
                // update indexes
                pointPos = buffStr.firstIndex(of: ".")!
                pointBuff = buffStr.index(after: pointPos)
                
                // delete space after if exists
                if buffStr[pointBuff] == " " {
                    buffStr.remove(at: pointBuff)
                }
            }
            resultStr = buffStr
        }
        
        // remove first and last spaces
        if resultStr.first == " " {
            resultStr.remove(at: resultStr.startIndex)
        }
        if resultStr.last == " " {
            resultStr.remove(at: resultStr.index(before: resultStr.endIndex))
        }
        
        return resultStr
    }
    
    // remove all spaces
    fileprivate func removeAllSpaces(str: String) -> String{
        var buffStr = ""
        str.forEach { (char) in
            // if char != space then ok
            if char != " " {
                buffStr.append(char)
            }
        }
        return buffStr
    }
    
    // filling up number with zeros by num of zeros in 1 part
    fileprivate func fillUpParts(by fillNum: Int , _ str: String) -> String {
        // remove spaces
        var buffStr = removeAllSpaces(str: str)
        
        if Int(str) != 0 {
            // remove all zeros at beginning of string
            while buffStr.first == "0" {
                buffStr.removeFirst(1)
            }
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
    
    // Convert form oct or hex with table helper
    // Convert to oct or hex with table helper
    fileprivate func convertOctHexTable(str: String, system: ConversionModel.ConversionSystemsEnum, toBinary: Bool) -> String {
        // remove all spaces
        var buffStr = removeAllSpaces(str: str)
        var buffResultStr = String()
        
        let partition: Int
        
        // octal or hex table
        // from 0 to 7 or from 0 to 16
        var table = ["":""]
        
        if system == .hex {
            // partititon set to 4
            partition = 4
            // hex table
            table = [   "0000":"0",
                        "0001":"1",
                        "0010":"2",
                        "0011":"3",
                        "0100":"4",
                        "0101":"5",
                        "0110":"6",
                        "0111":"7",
                        "1000":"8",
                        "1001":"9",
                        "1010":"A",
                        "1011":"B",
                        "1100":"C",
                        "1101":"D",
                        "1110":"E",
                        "1111":"F",]
            
        } else {
            // partittion set to 3
            partition = 3
            // octal table
            table = [   "000":"0",
                        "001":"1",
                        "010":"2",
                        "011":"3",
                        "100":"4",
                        "101":"5",
                        "110":"6",
                        "111":"7",]
        }
        
        if toBinary {
            // from octal or hex to binary
            // process each number and form parts
            buffStr.forEach { (num) in
                if num != "." {
                    for (key, value) in table {
                        if "\(num)" == value {
                            // append balue from table
                            buffResultStr.append("\(key)")
                        }
                    }
                } else {
                    // append .
                    buffResultStr.append(num)
                }
            }
        } else {
            // from binary to octal or hex
            // divide by part
            let intParts = Int(buffStr.count / partition)
            // process each part
            // part is 3 or 4 digits
            for _ in 0..<intParts {
                var partCounter = 0
                var buffPart = String()
                // get first 3 chars
                while partCounter < partition {
                    buffPart.append(buffStr.first!)
                    // delete first char
                    buffStr.remove(at: buffStr.startIndex)
                    
                    partCounter += 1
                }
                // convert these part into Octal or Hexadeicaml by using table
                for (key, value) in table {
                    if buffPart == key {
                        // append index from table
                        buffResultStr.append(value)
                        break
                    }
                }
            }
        }
        return buffResultStr
    }
    
    // OCT -> BIN
    fileprivate func convertOctToBin( octNumStr: String) -> String {
        let str = convertOctHexTable(str: octNumStr, system: .oct, toBinary: true)
        
        return divideStr(str: str, by: 3)
    }
    
    // TODO: Refactor to table
    // BIN -> OCT/HEX
    fileprivate func convertBinToOctHex( binNumStr: String, targetSystem: ConversionModel.ConversionSystemsEnum) -> String {
        var resultStr: String
        
        // if zero
        guard binNumStr != "0" else {
            return "0"
        }
        
        // set partition
        let partition: Int = {
            if targetSystem == .hex {
                return 4
            } else {
                return 3
            }
        }()
     
        // Dividing to int and fract parts
        let buffDividedStr = divideToDoubleInt(str: binNumStr)
        var binIntStrBuff = buffDividedStr.0
        
        var resultIntStr = String()
        var resultFractStr = String()
        
       
        guard binIntStrBuff != nil else {
            return "Error"
        }
        
        // delete zeros from parts by 4 and filling up by 3
        binIntStrBuff = fillUpParts(by: partition, binIntStrBuff!)
        
        // First: converting int part
        // dont count if zero
        if binIntStrBuff == "0" {
            resultIntStr = "0"
        } else {
            // First: converting int part
            resultIntStr = convertOctHexTable(str: binIntStrBuff!, system: targetSystem, toBinary: false)
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
            strBuff = fillUpParts(by: partition, strBuff)
            // reverse back
            strBuff = String(strBuff.reversed())
            // add zeros to end
            resultFractStr = convertOctHexTable(str: strBuff, system: targetSystem, toBinary: false)
            
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
    
    // ===========
    // Hexadecimal
    // ===========
    
    // HEX -> BIN
    fileprivate func convertHexToBin(hexNumStr: String) -> String {
        let str = convertOctHexTable(str: hexNumStr, system: .hex, toBinary: true)
        
        return divideStr(str: str, by: 4)
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
                // TODO: Various sytems handling
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
        // initialize vc popover and nav vc
        let vc = SettingsViewController()
        let navigationController = UINavigationController()
        
        // present settings
        vc.modalPresentationStyle = .pageSheet
        
        navigationController.setViewControllers([vc], animated: false)
        self.present(navigationController, animated: true)
    }

}







