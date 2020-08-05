//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcViewController: UIViewController {
    
    var calcState: CalcState?
    let calcView: PCalcView = PCalcView()
    lazy var mainLabel: UILabel = calcView.mainLabel
    lazy var converterLabel: UILabel = calcView.converterLabel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view from PCalcView
        self.view = calcView

    }
    
    
    
    // =======
    // Methods
    // =======
    
    func updateConverterLabel() {
        if Double(mainLabel.text!) == nil {
            converterLabel.text = mainLabel.text
        } else {
            // Uptade converter label with converted number
            converterLabel.text = convertToBinary(decNumStr: mainLabel.text!)
        }
    }
    
    func convertToBinary( decNumStr: String) -> String {
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
            let splittedDoubleStr: (String, String) = divideToDoubleInt(str: decNumStrBuff)!
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
    
    func convertIntToBinary( number: Int) -> String {
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
        
        // Divide number by discharges
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
            
            // add zeroes before for filling th discharges
            if counter > 0 {
                for _ in 0...3-counter {
                    buffStr.append("0")
                }
            }
            resultStr = String(buffStr.reversed())
        }

        return resultStr
    }
    
    func convertFractToBinary( numberStr: String) -> String {
        var buffDouble: Double
        var buffStr: String = "0."
        var resultStr: String = String()
        
       
        // if 0 then dont calculate
        if Int(numberStr) == 0 {
            resultStr = "0"
        } else {
            let counter: Int = 8
            // form double string
            buffStr.append(numberStr)
            buffDouble = Double(buffStr)!
                   
            // convert fract part of number
            // multiply by 2, if bigger then 1 then = 1, else 0
            for _ in 0..<counter {
                buffDouble = buffDouble * 2
                if buffDouble > 1 {
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
        
        // Divide number by discharges
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
            
            // add zeroes after for filling th discharges
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
    func convertDoubleToBinaryStr( numberStr: (String,String)) -> String {
        let intNumber = Int(numberStr.0)!
        
        return "\(convertIntToBinary(number: intNumber)).\(convertFractToBinary(numberStr: numberStr.1))"
    }
    
    // Dividing string variable and converting it to double without loss of precision
    func divideToDoubleInt( str: String) -> (String, String)? {
        
        var strInt: String
        var strFract: String
        var pointPos: String.Index

        // check for floating point
        guard str.contains(".") else {
            return nil
        }
           
        // search index of floating pos
        pointPos = str.firstIndex(of: ".")!
           
        // fill strInt
        strInt = String(str[str.startIndex..<pointPos])
           
        // fill strFract
        strFract = String(str[pointPos..<str.endIndex])
        // delete .
        strFract.remove(at: strFract.startIndex)
           
           
        print(" \(strInt)...\(strFract)")
        return (strInt, strFract)
    }
    
    // Calculation of 2 decimal numbers by .operation
    // TODO: Make error handling for overflow
    func calculateDecNumbers( firstNum: String, secondNum: String, operation: CalcState.mathOperation) -> String? {
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
        
        if calcState != nil {
            // if new value not inputed
            if !calcState!.inputStart {
                
                switch buttonText {
                case ".":
                    label.text = "0."
                    break
                default:
                    label.text = buttonText
                    break
                }
                calcState!.inputStart = true
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
            calcState = nil
        }
        
        switch buttonText {
        // Clear buttons
        case "AC":
            label.text! = "0"
            convertLabel.text! = "0"
            calcState = nil
            break
        case "C":
            label.text! = "0"
            convertLabel.text! = "0"
            button.setTitle("AC", for: .normal)
            calcState = nil
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
            if calcState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: calcState!.buffValue, secondNum: label.text!, operation: calcState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    calcState = nil
                    calcState = CalcState(buffValue: label.text!, operation: .div)
                    calcState?.lastResult = result
                }
            } else {
                calcState = CalcState(buffValue: label.text!, operation: .div)
            }
            break
        // Multiplication button
        case "X":
            // calc results
            if calcState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: calcState!.buffValue, secondNum: label.text!, operation: calcState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    calcState = nil
                    calcState = CalcState(buffValue: label.text!, operation: .mul)
                    calcState?.lastResult = result
                }
            } else {
                calcState = CalcState(buffValue: label.text!, operation: .mul)
            }
            break
        // Multiplication button
        case "-":
            // calc results
            if calcState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: calcState!.buffValue, secondNum: label.text!, operation: calcState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    calcState = nil
                    calcState = CalcState(buffValue: label.text!, operation: .sub)
                    calcState?.lastResult = result
                }
            } else {
                calcState = CalcState(buffValue: label.text!, operation: .sub)
            }
            break
        // Addition button
        case "+":
            // calc results
            if calcState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: calcState!.buffValue, secondNum: label.text!, operation: calcState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    calcState = nil
                    calcState = CalcState(buffValue: label.text!, operation: .add)
                    calcState?.lastResult = result
                }
            } else {
                calcState = CalcState(buffValue: label.text!, operation: .add)
            }
            break
        case "=":
            if calcState != nil {
                print("calculation")
                if let result = calculateDecNumbers(firstNum: calcState!.buffValue, secondNum: label.text!, operation: calcState!.operation) {
                    label.text = result
                    updateConverterLabel()
                }
                // reset state
                calcState = nil
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
        
        // present settings
        //vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        
        // show popover
        self.present(vc, animated: false, completion: nil)
    }

}





