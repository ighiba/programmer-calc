//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcViewController: UIPageViewController {
    
    // ==================
    // MARK: - Properties
    // ==================
    
    var arrayButtonsStack = [UIView]()
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
    
    // ======================
    // MARK: - Initialization
    // ======================
    
    // array of button pages
    lazy var arrayCalcButtonsViewController: [CalcButtonsViewController] = {
       var buttonsVC = [CalcButtonsViewController]()
        arrayButtonsStack.forEach { (buttonStack) in
            buttonsVC.append(CalcButtonsViewController(buttonsStack: buttonStack))
            
        }
        return buttonsVC
    }()
    

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)
        
        // TODO: Themes
        self.view.backgroundColor = .white

        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        
        self.delegate = self
        self.dataSource = self
        // allow interaction with content without delay
        self.delaysContentTouches = false
        
        // set start vc
        setViewControllers([arrayCalcButtonsViewController[1]], direction: .forward, animated: false, completion: nil)
        
        // Update states and layout
        updateConversionState()
        handleConversion()

        // update layout (handle button state and etc)
        updateAllLayout()
        // update displaying of mainLabel
        handleDisplayingMainLabel()
        // handle all buttons state for current conversion system
        handleButtonEnabledState()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ===================
    // MARK: - ViewDidLoad
    // ===================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let mainButtons = CalcButtonsMain(frame: CGRect())
        let additionalButtons = CalcButtonsAdditional(frame: CGRect())
        
        // apend StackViews to array
        arrayButtonsStack.append(additionalButtons)
        arrayButtonsStack.append(mainButtons)
        
        // add view from PCalcView
        self.view.addSubview(calcView)
        
        // get state from UserDefaults
        getCalcState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // set state to UserDefaults
        print("main dissapear")
        saveCalcState()
        
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Update conversion values
    fileprivate func getCalcState() {
        // get data from UserDefaults
        let data = returnCalcState()
        // apply data to view
        mainLabel.text = data.mainLabelState
        converterLabel.text = data.converterLabelState
        processSigned = data.processSigned
        
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
        
        systemMain = data.systemMain
        systemConverter = data.systemConverter
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
    
    // Handle button enabled state for various conversion systems
    public func handleButtonEnabledState() {
        let systemMain = self.systemMain ?? "Decimal" // default value
        let forbidden = ConversionValues().forbidden
        
        // loop buttons vc
        for vc in arrayCalcButtonsViewController {
            // loop all buttons in vc
            for buttonTag in 100...218 {
                if let button = vc.view.viewWithTag(buttonTag) as? CalculatorButton {
                    let buttonLabel = String((button.titleLabel?.text)!)
                    if forbidden[systemMain]!.contains(buttonLabel) {
                        print("Forbidden button \(buttonLabel)")
                        button.isEnabled = false
                    } else {
                        button.isEnabled = true
                    }
                }
            }
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
        if Double(labelText) == nil && ( self.systemMain != "Hexadecimal") {
            converterLabel.text = mainLabel.text
        } else {
            // Uptade converter label with converted number
            // TODO: Error handling
            converterLabel.text = converterHandler.convertValue(value: labelText, from: self.systemMain!, to: self.systemConverter!)
        }
    }
    
    public func updateMainLabel() {
        if systemMain == "Binary" {
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
        
        if digit == "." && !labelText.contains(".") {
            return labelText + digit
        } else if digit == "." && labelText.contains(".") {
            return labelText
        }
        
        if systemMain == "Binary" {
            var binary = Binary()
            
            binary.value = labelText
            
            // append input digit
            binary.appendDigit(digit)

            // divide binary by parts
            binary = binary.divideBinary(by: 4)
            
            return binary.value
        } else {
            // if other systems
            return labelText + digit
        }
        
    }
    
    // Handle displaying of mainLabel
    public func handleDisplayingMainLabel() {
        let fontName = mainLabel.font.fontName
        
        // IF System == System then hide label
        if systemMain == systemConverter {
            // hide
            mainLabel.isHidden = false
            converterLabel.isHidden = true
            // bigger font for converterLabel +20
            mainLabel.font = UIFont(name: fontName, size: 82.0)
            mainLabel.numberOfLines = 2
        } else {
            // unhide
            mainLabel.isHidden = false
            converterLabel.isHidden = false
            // default font for converterLabel
            mainLabel.font = UIFont(name: fontName, size: 72.0)
            
            // lines for binary
            if systemMain == "Binary" {
                mainLabel.numberOfLines = 2
            } else {
                mainLabel.numberOfLines = 1
            }
        }
    }
    
    // Update signed button
    private func updateIsSignedButton() {
        // get button by tag 102
        // TODO: Refactor hardcode
        let isSignedButton = self.view.viewWithTag(102) as? UIButton ?? UIButton()
        
        if processSigned {
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
            plusMinusButton.isEnabled = processSigned
        }
    }
    
    fileprivate func calculateResult( inputValue: String, operation: CalcMath.mathOperation) -> String {
        var resultStr = String()
        // process claculation buff values and previous operations
        if mathState != nil {
            print("calculation")
            if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: mainLabel.text!, for: SavedData.conversionSettings!.systemMain) {
                mathState = nil
                mathState = CalcMath.MathState(buffValue: mainLabel.text!, operation: operation)
                mathState?.lastResult = result
                resultStr = result
            }
        } else {
            mathState = CalcMath.MathState(buffValue: mainLabel.text!, operation: operation)
            resultStr = mainLabel.text!
        }
        
        return resultStr
    }

    // ===============
    // MARK: - Actions
    // ===============
    
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
                // update mainLabel
                updateMainLabel()
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
        //let convertLabel = converterLabel
        // tag for AC/C button
        //let acButton = self.view.viewWithTag(100) as! UIButton
        // tag for Signed ON/Off button
        
        print("Button \(buttonText) touched")
        
        // if error mesage in label
        // TODO: Better Error handling
//        if Double(label.text!) == nil {
//            label.text! = "0"
//            convertLabel.text! = "0"
//            acButton.setTitle("AC", for: .normal)
//            mathState = nil
//        }
        
        switch buttonText {
        // Clear buttons
        case "AC":
            clearLabels()
            mathState = nil
        case "C":
            clearLabels()
            button.setTitle("AC", for: .normal)
            mathState = nil
        // Invert button
        case "\u{00B1}":
            if label.text != "0" {
                // if number is already signed
                // TODO: Error handling
                // TODO: Various sytems handling
                if systemMain == "Binary" {
                    // change left bit 1 to 0, 0 to 1
                    if label.text!.first == "0" {
                        label.text!.removeFirst()
                        label.text = "1" + label.text!
                    } else {
                        label.text!.removeFirst()
                        label.text = "0" + label.text!
                    }
                } else {
                    // For other systems
                    if label.text!.contains("-") {
                        let minusIndex = label.text!.firstIndex(of: "-")
                        label.text!.remove(at: minusIndex!)
                    } else {
                        // just add minus
                        label.text = "-" + label.text!
                    }
                }
            }
            updateConverterLabel()
        // Subtraction button
        case "\u{00f7}":
            // calc results
            label.text = calculateResult(inputValue: label.text!, operation: .div)
        // Multiplication button
        case "X":
            // calc results
            label.text = calculateResult(inputValue: label.text!, operation: .mul)
        // Multiplication button
        case "-":
            // calc results
            label.text = calculateResult(inputValue: label.text!, operation: .sub)
        // Addition button
        case "+":
            // calc results
            label.text = calculateResult(inputValue: label.text!, operation: .add)
        case "=":
            if mathState != nil {
                print("calculation")
                if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: label.text!, for: SavedData.conversionSettings!.systemMain) {
                    label.text = result
                }
                // reset state
                mathState = nil
            } else {
                print("do nothing")
            }
        default:
            break
        }
        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }
    
    // Signed OFF/ON button
    @objc func toggleIsSigned( sender: UIButton) {
        // invert value
        processSigned = !processSigned
        // update value
        updateIsSignedButton()
        // TODO: Main label
        // save state to UserDefaults
        saveCalcState()
        print("Signed - \(processSigned)")
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
    
    // 1's or 2's button tapped
    @objc func complementButtonTapped( sender: UIButton) {
        let buttonLabel = sender.titleLabel?.text
        // switch complements
        switch buttonLabel {
        case "1's":
            // TODO: Error handling
            mainLabel.text = converterHandler.toOnesComplement(valueStr: mainLabel.text!, mainSystem: systemMain!)
        case "2's":
            // TODO: Error handling
            mainLabel.text = converterHandler.toTwosComplement(valueStr: mainLabel.text!, mainSystem: systemMain!)
        default:
            break
        }
        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }
    
    // Bitwise operations
    @objc func bitwiseButtonTapped( sender: UIButton) {
        let buttonLabel = sender.titleLabel?.text
        
        // if float then exit
        guard !mainLabel.text!.contains(".") else {return}
        
        // swtch binary operation cases
        switch buttonLabel {
        case "X<<Y":
            mainLabel.text = calculateResult(inputValue: mainLabel.text!, operation: .shiftLeft)
        case "X>>Y":
            mainLabel.text = calculateResult(inputValue: mainLabel.text!, operation: .shiftRight)
        case "<<":
            // TODO: Error handling
            mainLabel.text = converterHandler.shiftBits(value: mainLabel.text!, mainSystem: systemMain!, shiftOperation: <<, shiftCount: 1)
        case ">>":
            // TODO: Error handling
            mainLabel.text = converterHandler.shiftBits(value: mainLabel.text!, mainSystem: systemMain!, shiftOperation: >>, shiftCount: 1)
        case "AND":
            mainLabel.text = calculateResult(inputValue: mainLabel.text!, operation: .and)
        case "OR":
            mainLabel.text = calculateResult(inputValue: mainLabel.text!, operation: .or)
        case "XOR":
            mainLabel.text = calculateResult(inputValue: mainLabel.text!, operation: .xor)
        case "NOR":
            mainLabel.text = calculateResult(inputValue: mainLabel.text!, operation: .nor)
        default:
            break
        }
        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }
}



// =================
// MARK: - Extension
// =================

extension PCalcViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // load vc before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CalcButtonsViewController else {return nil}
        if let index = arrayCalcButtonsViewController.firstIndex(of: viewController) {
            if index > 0 {
                return arrayCalcButtonsViewController[index - 1]
            }
        }
        
        return nil
    }
    
    // load vc after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CalcButtonsViewController else {return nil}
        if let index = arrayCalcButtonsViewController.firstIndex(of: viewController) {
            if index < arrayButtonsStack.count - 1 {
                return arrayCalcButtonsViewController[index + 1]
            }
        }
        
        return nil
    }
    
    // how much pages will be
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayButtonsStack.count
    }
    
    // starting index for dots
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
 
}
