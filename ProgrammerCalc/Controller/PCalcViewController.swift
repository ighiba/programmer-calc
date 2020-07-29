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
    let calcView: PCalcView = PCalcView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    lazy var mainLabel: UILabel = calcView.mainLabel
    lazy var converterLabel: UILabel = calcView.converterLabel
    
    var mainLabelBuffer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(calcView.allViews)

    }
    
    
    
    // =======
    // Methods
    // =======
    
    func updateConverterLabel() {
        // Uptade converter label with converted number
        converterLabel.text = convertToBinary(decNumStr: mainLabel.text!)
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
            let splittedDouble: (Int, Int) = divideToFloatInt(str: decNumStrBuff)!
            binaryStr = convertDoubleToBinary(number: splittedDouble)
            
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
    
    func convertIntToBinary(number: Int) -> String {
        var divisible: Int = number
        var reminder: Int = 0
        var resultStr: String = String()
        
        // divide by 2
        while divisible != 0 && divisible != 1 {
            reminder = divisible % 2
            divisible = divisible / 2
            resultStr.append(contentsOf: String(reminder))
        }
        
        //if no divide
        if divisible == 0 || divisible == 1 {
            resultStr.append(contentsOf: String(divisible))
            resultStr = String(resultStr.reversed())
        }

        return resultStr
    }
    
    func convertFractToBinary(number: Int) -> String {
        var buffDouble: Double
        var buffStr: String = "0."
        let counter: Int = 8
        var resultStr: String = String()
        
       
        // if 0 then dont calculate
        if number == 0 {
            resultStr = "0"
        } else {
            // form double string
            buffStr.append(String(number))
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
            while resultStr[resultStr.index(before: resultStr.endIndex)] == "0" {
                resultStr.remove(at: resultStr.index(before: resultStr.endIndex))
            }
        }
        
        
        return resultStr
    }
    
    // Combine to parts to double string
    func convertDoubleToBinary(number: (Int,Int)) -> String {
        return "\(convertIntToBinary(number: number.0)).\(convertFractToBinary(number: number.1))"
    }
    
    // Dividing string variable and converting it to double without loss of precision
    func divideToFloatInt(str: String) -> (Int, Int)? {
           var numberInt: Int = 0
           var numberFract: Int = 0
           var pointPos: String.Index
           var counter: Int = 0
           var iterator: Int = 0
           var multiplier: Int = 1
    
           // check for floating point
           guard str.contains(".") else {
               return nil
           }
           
           // search index of floating pos
           pointPos = str.firstIndex(of: ".")!
           
           // fill numberInt
           counter = str.distance(from: str.startIndex, to: pointPos)
           multiplier = 1
           iterator = -1
           while counter > 0 {
               
               // TODO Erorr handling
               let newIndex: String.Index = str.index(pointPos, offsetBy: iterator)
               let strCharInt: String = String(str[newIndex])
               let num: Int = Int(strCharInt)!
               numberInt += num  * multiplier
               multiplier *= 10
               counter -= 1
               iterator -= 1
           }
           
           // fill numberFract
           counter = str.distance(from: str.endIndex, to: pointPos)
           counter = abs(counter)
           multiplier = 1
           iterator = counter - 1
           while counter > 1 {
               
               // TODO Erorr handling
               let newIndex: String.Index = str.index(pointPos, offsetBy: iterator)
               let strCharInt: String = String(str[newIndex])
               let num: Int = Int(strCharInt)!
               numberFract += num  * multiplier
               multiplier *= 10
               counter -= 1
               iterator -= 1
           }
           
           
           print(" \(numberInt)...\(numberFract)")
           return (numberInt, numberFract)
    }
    
    // Calculation of 2 decimal numbers by .operation
    func calculateDecNumbers(firstNum: String, secondNum: String, operation: CalcState.mathOperation) -> String? {
        var resultStr: String?
        
        switch operation {
        // Addition
        case .add:
            if let firstInt = Int(firstNum), let secondNum = Int(secondNum) {
                // addition for ints
                resultStr = String( firstInt + secondNum )
            } else if firstNum.contains(".") || secondNum.contains(".") {
                // addition for floats
                let firstFloat = Double(firstNum)
                let secondFloat = Double(secondNum)
                
                resultStr = String( round((firstFloat! + secondFloat!) * 1000)/1000 )
                // TODO: float number addition
            }
            break
            
        // Subtraction
        case .sub:
             if let firstInt = Int(firstNum), let secondNum = Int(secondNum) {
                           // subtraction for ints
                           resultStr = String( firstInt - secondNum )
                       } else if firstNum.contains(".") || secondNum.contains(".") {
                           // subtraction for floats
                           let firstFloat = Double(firstNum)
                           let secondFloat = Double(secondNum)
                           
                           resultStr = String( round((firstFloat! - secondFloat!) * 1000)/1000 )
                           // TODO: float number subtraction
                       }
                       break
    
        }
        
        return resultStr
    }
    
    // =======
    // Actions
    // =======
    
    @objc func toucUpOutsideAction(sender: UIButton) {
        //print("touchUpOutside")
        //sender.backgroundColor = .red
        //sender.isHighlighted = false
    }
    
    // Numeric buttons actions
    
    @objc func numericButtonTapped(sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        let convertLabel = converterLabel
        // tag for AC/C button
        let acButton = self.view.viewWithTag(100) as! UIButton
        //print(acButton)
        
        
        print("Button \(buttonText) touched")
        
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
    
    @objc func signButtonTapped(sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        let convertLabel = converterLabel
        
        print("Button \(buttonText) touched")
        
        switch buttonText {
        // clear buttons
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
        // invert button
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
        // minus button
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
        
        print(calcState)
    }

}





