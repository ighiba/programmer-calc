//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcViewController: UIViewController {
    
    // ==========
    // Properties
    // ==========
    
    // Handlers
    let converterHandler: ConverterHandler = ConverterHandler()
    let calculationHandler: CalcMath = CalcMath()
    // views
    let calcView: PCalcView = PCalcView()
    lazy var mainLabel: UILabel = calcView.mainLabel
    lazy var converterLabel: UILabel = calcView.converterLabel
    // State for processign signed values
    private var processSigned = false // default value
    // State for calculating numbers
    private var mathState: CalcMath.MathState?
    // State for conversion systems
    var systemMain: String?
    var systemConverter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view from PCalcView
        self.view = calcView
        // get state from UserDefaults
        getCalcState()
        
        updateConversionState()
        handleConversion()
        
        // update layout (handle button state and etc)
        updateAllLayout()
        // update displaying of mainLabel
        let data = returnConversionSettings()
        handleDisplayingMainLabel(data: data)

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
        let data = returnCalcState()
        // apply data to view
        mainLabel.text = data.mainLabelState
        converterLabel.text = data.converterLabelState
        self.processSigned = data.processSigned
        
        // Update layout
        //updateAllLayout()
    }
    
    public func saveCalcState() {
        // TODO: Error handling
        let mainState = mainLabel.text ?? "0"
        let convertState = converterLabel.text ?? "0"
        let processSigned = self.processSigned
        
        // set data to UserDefaults
        SavedData.calcState = CalcState(mainState: mainState, convertState: convertState, processSigned: processSigned)
    }
    
    fileprivate func updateConversionState() {
        // get data from UserDefaults
        let data = returnConversionSettings()
        
        self.systemMain = data.systemMain
        self.systemConverter = data.systemConverter
    }
    
    // just return calcState data from UserDefauls
    private func returnCalcState() -> CalcState {
        if let data = SavedData.calcState {
            return data
        }  else {
            // if no settings
            print("no settings")
            // default values
            let newCalcState = CalcState(mainState: "0", convertState: "0", processSigned: false)
            SavedData.calcState = newCalcState
            
            return newCalcState
        }
    }
    
    // just return conversionSettings data from UserDefauls
    private func returnConversionSettings() -> ConversionSettingsModel {
        if let data = SavedData.conversionSettings {
            return data
        }  else {
            // if no settings
            print("no settings")
            // Save default settings
            let systems = ConversionModel.ConversionSystemsEnum.self
            // From DEC to BIN
            let newConversionSettings = ConversionSettingsModel(systMain: systems.dec.rawValue, systConverter: systems.bin.rawValue, number: 8.0)
            
            return newConversionSettings
        }
    }
    
    // Clear mainLabel and update value in converter label
    public func clearLabels() {
        mainLabel.text = "0"

        updateMainLabel()
        updateConverterLabel()
    }
    
    // Handle conversion issues
    public func handleConversion() {
        let labelText = mainLabel.text
        let systemMain = SavedData.conversionSettings?.systemMain ?? "Decimal" // default value
        let forbidden = ConversionValues().forbidden
        
        if forbidden[systemMain]!.contains(where: labelText!.contains) {
            print("Forbidden values at input")
            print("Reseting input")
            clearLabels()
        } else {
            // do nothing
        }
    }
    
    public func updateAllLayout() {
        // update button value
        updateIsSignedButton()
        // update main label
        updateMainLabel()
        // update converter label
        updateConverterLabel()
        // update plusminus button state
        changeStatePlusMinus()
        
    }
   
    public func updateConverterLabel() {
        // remove spaces mainLabel
        let labelText: String = {
            var buffStr = String()
            
            mainLabel.text!.forEach { (num) in
                if num != " " {
                    buffStr.append(num)
                }
            }
            
            return buffStr
        }()
        
        // TODO: Refator hadling for Hexadecimal values
        if Double(labelText) == nil {
            converterLabel.text = mainLabel.text
        } else {
            // Uptade converter label with converted number
            // TODO: Error handling
            converterLabel.text = converterHandler.convertValue(value: labelText, from: self.systemMain!, to: self.systemConverter!)
        }
    }
    
    public func updateMainLabel() {
        if self.systemMain == "Binary" {
            var binary = Binary(stringLiteral: mainLabel.text!)
             
             // divide binary by parts
            binary = binary.divideBinary(by: 4)
            
            mainLabel.text! = binary.value
        } else {
            // do nothing
        }
        

    }
    
    // add digit to end of main label
    // special formatting for binary
    private func addDigitToMainLabel( labelText: String, digit: String) -> String {
        
        if self.systemMain == "Binary" {
            //var buffStr = String()
            var buffStr = labelText
            
//            // delete spaces
//            labelText.forEach { (num) in
//                if num != " " {
//                    buffStr.append(num)
//                }
//            }
//            
//            // delete zeroes before
//            while buffStr.first == "0" {
//                buffStr.removeFirst()
//            }
//            
//            // add zero if .
//            if buffStr.first == "." {
//                buffStr = "0" + buffStr
//            }
            
            // append input digit
            buffStr.append(digit)
            
            var binary = Binary(stringLiteral: buffStr)
            
            // divide binary by parts
            binary = binary.divideBinary(by: 4)
            
            return binary.value
        } else {
            // if other systems
            return labelText + digit
        }
        
    }
    
    // Handle displaying of mainLabel
    public func handleDisplayingMainLabel( data: ConversionSettingsModel ) {
        let fontName = self.converterLabel.font.fontName
        
        // IF System == System then hide label
        if data.systemMain == data.systemConverter {
            // hide
            self.mainLabel.isHidden = true
            // bigger font for converterLabel +20
            self.converterLabel.font = UIFont(name: fontName, size: 72.0)
            self.converterLabel.numberOfLines = 4
        } else {
            // unhide
            self.mainLabel.isHidden = false
            // default font for converterLabel
            self.converterLabel.font = UIFont(name: fontName, size: 62.0)
            self.converterLabel.numberOfLines = 2
        }
    }
    
    // Update signed button
    private func updateIsSignedButton() {
        // get button by tag 102
        // TODO: Refactor hardcode
        let isSignedButton = self.view.viewWithTag(102) as! UIButton
        
        if self.processSigned {
            // if ON then disable
            // TODO: Localization
            isSignedButton.setTitle("Signed\nON", for: .normal)
        } else {
            // if OFF then enable
            isSignedButton.setTitle("Signed\nOFF", for: .normal)
        }
    }
    
    // Change state of plusminus button
    private func changeStatePlusMinus() {
        if let plusMinusButton = self.view.viewWithTag(101) as? UIButton {
            plusMinusButton.isEnabled = self.processSigned
        }
    }
    
//    private func invertLabelsValue() {
//        let mainLabelText = mainLabel.text!
//        let convertLabelText = converterLabel.text!
//        let mainSystem = SavedData.conversionSettings?.systemMain ?? "Decimal"
//        
//        switch mainSystem {
//        case "Binary":
//            break
//        case "Decimal":
//            break
//        case "Octal":
//            break
//        case "Hexadecimal":
//            break
//        default:
//            break
//        }
//        
//    }

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
//        if Double(label.text!) == nil {
//            if buttonText == "." {
//                label.text = "0."
//            } else {
//                label.text = buttonText
//            }
//
//            // update converter label
//            updateConverterLabel()
//            return
//        }
        
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
                
                if abs(numsAfterPoint) > 12 {return true}
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
                        //label.text! += buttonText
                        label.text! = addDigitToMainLabel(labelText: label.text!, digit: buttonText)
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
                        //label.text! += buttonText
                        label.text! = addDigitToMainLabel(labelText: label.text!, digit: buttonText)
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
                    //label.text! += buttonText
                    label.text! = addDigitToMainLabel(labelText: label.text!, digit: buttonText)
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
                    //label.text! += buttonText
                    label.text! = addDigitToMainLabel(labelText: label.text!, digit: buttonText)
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
        // tag for Signed ON/Off button
        
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
            clearLabels()
            mathState = nil
            break
        case "C":
            clearLabels()
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
                if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
                
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
                if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
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
                if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
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
                if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
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
                if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
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
    
    // Signed OFF/ON button
    @objc func toggleIsSigned( sender: UIButton) {
        // invert value
        self.processSigned = !self.processSigned
        // update value
        updateIsSignedButton()
        // TODO: Main label
        // save state to UserDefaults
        saveCalcState()
        print("Signed - \(self.processSigned)")
        // update converter and main labels
        updateConverterLabel()
        updateMainLabel()
        // toggle plusminus button
        changeStatePlusMinus()
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
