//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcViewController: UIViewController {
    
    var mathState: CalcMath.MathState?
    let calcView: PCalcView = PCalcView()
    lazy var mainLabel: UILabel = calcView.mainLabel
    lazy var converterLabel: UILabel = calcView.converterLabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view from PCalcView
        self.view = calcView
        // get state from UserDefaults
        getCalcState()
        handleConversion()
        //print(CalcMath().addBinary("1100.10111", "11011.11001"))
        //print(CalcMath.inverBinary(binary: "1100"))

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
    
    // Reset all labels after Conversion
    public func resetAllLabels() {
        mainLabel.text = "0"
        converterLabel.text = "0"
    }
    
    // Handle conversion issues
    public func handleConversion() {
        let labelText = mainLabel.text
        let systemMain = SavedData.conversionSettings?.systemMain ?? "Decimal" // default value
        let forbidden = ConversionValues().forbidden
        
        if forbidden[systemMain]!.contains(where: labelText!.contains) {
            print("Forbidden values at input")
            print("Reseting input")
            resetAllLabels()
        } else {
            // do nothing
        }
    }
   
    public func updateConverterLabel() {
        // TODO: Refator hadling for Hexadecimal values
        if Double(mainLabel.text!) == nil {
            converterLabel.text = mainLabel.text
        } else {
            // Uptade converter label with converted number
            // TODO: Error handling
            if let data = SavedData.conversionSettings {
                let fromSystem = data.systemMain
                let toSystem = data.systemConverter
                converterLabel.text = MainConverter().convertValue(value: mainLabel.text!, from: fromSystem, to: toSystem)
            }
        }
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
                if let result = CalcMath.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
                
                    //calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = CalcMath.MathState(buffValue: label.text!, operation: .div)
                    mathState?.lastResult = result
                }
            } else {
                mathState = CalcMath.MathState(buffValue: label.text!, operation: .div)
            }
            break
        // Multiplication button
        case "X":
            // calc results
            if mathState != nil {
                print("calculation")
                if let result = CalcMath.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
                //if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = CalcMath.MathState(buffValue: label.text!, operation: .mul)
                    mathState?.lastResult = result
                }
            } else {
                mathState = CalcMath.MathState(buffValue: label.text!, operation: .mul)
            }
            break
        // Multiplication button
        case "-":
            // calc results
            if mathState != nil {
                print("calculation")
                if let result = CalcMath.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
                //if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = CalcMath.MathState(buffValue: label.text!, operation: .sub)
                    mathState?.lastResult = result
                }
            } else {
                mathState = CalcMath.MathState(buffValue: label.text!, operation: .sub)
            }
            break
        // Addition button
        case "+":
            // calc results
            if mathState != nil {
                print("calculation")
                if let result = CalcMath.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
                //if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
                    label.text = result
                    updateConverterLabel()
                    mathState = nil
                    mathState = CalcMath.MathState(buffValue: label.text!, operation: .add)
                    mathState?.lastResult = result
                }
            } else {
                mathState = CalcMath.MathState(buffValue: label.text!, operation: .add)
            }
            break
        case "=":
            if mathState != nil {
                print("calculation")
                if let result = CalcMath.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
                //if let result = calculateDecNumbers(firstNum: mathState!.buffValue, secondNum: label.text!, operation: mathState!.operation) {
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
