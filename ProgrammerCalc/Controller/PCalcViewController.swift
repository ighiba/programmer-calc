//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

// Temporary workaround for changing word size
// TODO: Load from storage
var wordSize_Global: Int = 8

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
    lazy var mainLabel: CalcualtorLabel = calcView.mainLabel
    lazy var converterLabel: CalcualtorLabel = calcView.converterLabel
    // State for raw value in main label
    var mainLabelRawValue: NumberSystemProtocol! // TODO: Error handling
    // State for processign signed values
    private var processSigned = false // default value
    // State for calculating numbers
    private var mathState: CalcMath.MathState?
    // State for conversion systems
    var systemMain: ConversionSystemsEnum?
    var systemConverter: ConversionSystemsEnum?
    
    
    // Storages
    let settingsStorage: SettingsStorageProtocol = SettingsStorage()
    let calcStateStorage: CalcStateStorageProtocol = CalcStateStorage()
    let conversionStorage: ConversionStorageProtocol = ConversionStorage()
    let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    
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

        // update layout
        updateAllLayout()
        // update displaying of mainLabel
        handleDisplayingMainLabel()
        // handle all buttons state for current conversion system
        updateButtons()
        
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
        updateCalcState()

        // add swipe left for deleting last value in main label
        [mainLabel,converterLabel].forEach { (label) in
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightLabel))
            swipeRight.direction = .right
            label.addGestureRecognizer(swipeRight)
            
        }

        // add handler
        (mainLabel as UpdatableLabel).updateRawValueHandler = { [self] _ in
            // update label rawValue
            updateMainLabelRawValue()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // set state to UserDefaults
        print("main dissapear")
        saveCalcState()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.unhighlightLabels()
        
        print("touched began")
    }

    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Update conversion values
    fileprivate func updateCalcState() {
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
        let newState = CalcState(mainState: mainState, convertState: convertState, processSigned: processSigned)
        calcStateStorage.saveData(newState)
    }
    
    fileprivate func updateConversionState() {
        // get data from UserDefaults
        let data = returnConversionSettings()
        
        systemMain = ConversionSystemsEnum(rawValue: data.systemMain)
        systemConverter = ConversionSystemsEnum(rawValue: data.systemConverter)
    }
    
    // just return calcState data from UserDefauls
    private func returnCalcState() -> CalcStateProtocol {
        if let state = calcStateStorage.loadData() {
            return state
        }  else {
            // if no settings
            print("no settings")
            // default values
            let newState = CalcState(mainState: "0", convertState: "0", processSigned: false)
            calcStateStorage.saveData(newState)
            
            return newState
        }
    }
    
    // just return conversionSettings data from UserDefauls
    private func returnConversionSettings() -> ConversionSettingsProtocol {
        if let conversionSettings = conversionStorage.loadData() {
            return conversionSettings
        }  else {
            // if no settings
            print("no settings")
            // Save default settings
            let systems = ConversionSystemsEnum.self
            // From DEC to BIN
            let newConversionSettings = ConversionSettings(systMain: systems.dec.rawValue, systConverter: systems.bin.rawValue, number: 8.0)
            conversionStorage.saveData(newConversionSettings)
            
            return newConversionSettings
        }
    }
    
    // make labels .clear color
    func unhighlightLabels() {
        if mainLabel.layer.backgroundColor != UIColor.clear.cgColor {
            mainLabel.hideLabelMenu()
        }
        if converterLabel.layer.backgroundColor != UIColor.clear.cgColor {
            converterLabel.hideLabelMenu()
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
        let conversionSettings = conversionStorage.loadData()
        let systemMain = conversionSettings?.systemMain ?? "Decimal" // default value
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
    public func updateButtons() {
        let systemMain = self.systemMain ?? .dec // default value
        let forbidden = ConversionValues().forbidden
        
        // Update all buttons except signed and plusminus
        // loop buttons vc
        for vc in arrayCalcButtonsViewController {
            // loop all buttons in vc
            for buttonTag in 100...218 {
                if let button = vc.view.viewWithTag(buttonTag) as? CalculatorButton {
                    let buttonLabel = String((button.titleLabel?.text)!)
                    if forbidden[systemMain.rawValue]!.contains(buttonLabel) && button.calcButtonType == .numeric {
                        //print("Forbidden button \(buttonLabel)")
                        button.isEnabled = false
                    } else {
                        // just enable button
                        button.isEnabled = true
                    }
                }
            }
        }

        // update signed button value
        updateIsSignedButton()
        // update plusminus button state
        changeStatePlusMinus()
    }
    
    public func updateChangeWordSizeButton() {
        let wordSize: WordSize
        // get data from UserDefaults
        if let size = wordSizeStorage.loadData() {
            wordSize = size as! WordSize
        }  else {
            print("no wordSize")
            // Save default settings
            wordSize = WordSize(64)
            wordSizeStorage.saveData(wordSize)
        }
        
        // prepare title
        let newTitle: String = {
            for item in wordSize.wordsDictionary {
                if item.first?.value == wordSize.value {
                    return item.first!.key
                }
            }
            return (self.calcView.changeWordSizeButton.titleLabel?.text)!
        }()
        
        // change button title
        self.calcView.changeWordSizeButton.setTitle(newTitle, for: .normal)
    }
    
    public func updateAllLayout() {
        // update change word size button
        updateChangeWordSizeButton()
        // update button value
        updateIsSignedButton()
        // update plusminus button state
        changeStatePlusMinus()
        // update main label
        updateMainLabel()
        updateMainLabelRawValue()
        // update converter label
        updateConverterLabel()
    }
   
    public func updateConverterLabel() {
        // remove spaces mainLabel
        let labelText: String = {
            // remove spaces in mainLabel for converting
            return mainLabel.text!.removeAllSpaces()
        }()
        
        // TODO: Refator hadling for Hexadecimal values
        if Double(labelText) == nil && ( self.systemMain != .hex) {
            converterLabel.text = mainLabel.text
        } else {
            // Uptade converter label with converted number
            // TODO: Error handling
            updateConversionState()
            let newValue = converterHandler.convertValue(value: mainLabelRawValue, from: systemMain!, to: systemConverter!)?.value
            uptdateConverterLabelWith(newValue)
        }
    }
    
    public func updateMainLabel() {
        if systemMain == .bin {
            var binary = Binary(stringLiteral: mainLabel.text!)
             
             // divide binary by parts
            binary = binary.divideBinary(by: 4)
            
            mainLabel.text! = binary.value
        } else {
            // do nothing
        }
    }
    
    private func updateMainLabelRawValue() {
        // update label rawValue
        switch systemMain {
        case .bin:
            mainLabel.setRawValue(value: Binary(stringLiteral: mainLabel.text!))
        case .oct:
            mainLabel.setRawValue(value: Octal(stringLiteral: mainLabel.text!))
        case .dec:
            mainLabel.setRawValue(value: DecimalSystem(stringLiteral: mainLabel.text!))
        case .hex:
            mainLabel.setRawValue(value: Hexadecimal(stringLiteral: mainLabel.text!))
        case .none:
            break
        }
        
        // update VC rawValue
        self.mainLabelRawValue = mainLabel.rawValue
    }
    
    // add digit to end of main label
    // special formatting for binary
    private func addDigitToMainLabel( labelText: String, digit: String) -> String {
        var result = String()
        
        if digit == "." && !labelText.contains(".") {
            return labelText + digit
        } else if digit == "." && labelText.contains(".") {
            return labelText
        }
        
        if systemMain == .bin {
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
        
        // process overflow
        let newResult = precessStrInputOverflow(input: result, for: systemMain!)
        
        return newResult
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
            if systemMain == .bin {
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
        let isSignedButton = self.view.viewWithTag(102) as? CalculatorButton ?? CalculatorButton()
        
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
        if let plusMinusButton = self.view.viewWithTag(101) as? CalculatorButton {
            plusMinusButton.isEnabled = processSigned
        }
    }
    
    // Updating converter label with optional string value
    private func uptdateConverterLabelWith(_ value: String?) {
        if let newValue = value {
            converterLabel.text = newValue
        } else {
            // TODO: Refactor or delete
            //       Localization
            converterLabel.text = "Impossible to convert"
        }
    }
    
    private func precessStrInputOverflow(input: String, for system: ConversionSystemsEnum) -> String {
        var result = String()
        let buffValue: NumberSystemProtocol
        
        // TODO: Refactor Create NumberSystem by factory?
        switch system {
        case .bin:
            buffValue = Binary(stringLiteral: input)
            break
        case .oct:
            buffValue = Octal(stringLiteral: input)
            break
        case .dec:
            buffValue = DecimalSystem(stringLiteral: input)
            break
        case .hex:
            buffValue = Hexadecimal(stringLiteral: input)
            break
        }
        
        if let dec = converterHandler.convertValue(value: buffValue, from: system, to: .dec) as? DecimalSystem {
            // calculate max/min decSigned/Unsigned values with current wordSize value
            let max = Decimal().decPow(Decimal(2), Decimal(wordSize_Global)) - Decimal(1)
            let maxSigned = Decimal().decPow(Decimal(2), Decimal(wordSize_Global-1)) - Decimal(1)
            let minSigned = Decimal().decPow(Decimal(2), Decimal(wordSize_Global-1)) * Decimal(-1)
            
            let decValueOld = dec.decimalValue
            var decResult = dec.decimalValue
            if processSigned && dec.decimalValue > maxSigned+1 {
                print("input overflow signed +")
                decResult = maxSigned
            } else if processSigned && dec.decimalValue < minSigned-1 {
                print("input overflow signed -")
                decResult = minSigned
            } else if !processSigned && dec.decimalValue > max+1 {
                print("input overflow unsigned +")
                decResult = max
            }
            
            // change dec with new value
            dec.setNewDecimal(with: decResult)
            
            // compare results
            // if different then return result else return buffValue
            if decValueOld != dec.decimalValue {
                result = converterHandler.convertValue(value: dec, from: .dec, to: system)!.value
            } else {
                result = buffValue.value
            }

        }
        return result
    }
    
    fileprivate func calculateResult( inputValue: NumberSystemProtocol, operation: CalcMath.mathOperation) -> String {
        var resultStr = String()
        // process claculation buff values and previous operations
        if mathState != nil {
            print("calculation")

            // update systemMain
            updateConversionState()
            // calculate
            if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: mainLabelRawValue, for: systemMain!) {
                mathState = nil
                mathState = CalcMath.MathState(buffValue: mainLabelRawValue, operation: operation)
                mathState?.lastResult = result
                resultStr = result.value
            }
        } else {
            mathState = CalcMath.MathState(buffValue: mainLabelRawValue, operation: operation)
            resultStr = mainLabel.text!
        }
        
        return resultStr
    }

    // ===============
    // MARK: - Actions
    // ===============
    
    @objc func toucUpOutsideAction(_ sender: UIButton) {
        //print("touchUpOutside")
        //sender.backgroundColor = .red
        //sender.isHighlighted = false
    }
    
    @objc func touchHandleLabelHighlight() {
        // TODO: Refactor
        unhighlightLabels()
    }
    
    // Numeric buttons actions
    @objc func numericButtonTapped(_ sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        let convertLabel = converterLabel
        // tag for AC/C button
        let acButton = self.view.viewWithTag(100) as! UIButton
        
        print("Button \(buttonText) touched")
        
//        var test = isInputOverflowed(for: systemMain!)
//        // check if . button is touched and number is int
//        if buttonText == "." && !label.text!.contains(".") {
//            test = false
//        }
//
//        print(test)
        
        // bool calculates overflowing of mainLabel number for int and float value
//        let isOverflowed: Bool = {
//            let str = label.text!
//
//            // check if . button is touched and number is int
//            if buttonText == "." && !str.contains(".") {return false}
//            // handle fract state
//            if  str.contains(".") {
//                // search index of floating pos
//                let pointPos: String.Index = str.firstIndex(of: ".")!
//                let numsAfterPoint: Int = str.distance(from: str.endIndex, to: pointPos)
//
//                if abs(numsAfterPoint) > 12 {return true} else {return false}
//            }
//
//            // if number is int
////            let state  = calcStateStorage.loadData()
////            if state!.processSigned {
////                // signed
////                let strCount = str.contains("-") ? 19 : 18
////                return str.count > strCount ? true : false
////            } else {
////                // unsigned
////                return str.count >= 20 ? true : false
////            }
//            return false
//        }()
        
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
//                if isOverflowed {
//                    //print("too much digits")
//                    return
//                }
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

//            if isOverflowed {
//                print("too much digits")
//                return
//            }
            switch label.text! {
            case "0":
                if buttonText.contains(".") {
                    //label.text! += buttonText
                    label.text! = addDigitToMainLabel(labelText: label.text!, digit: buttonText)
                    convertLabel.text! += buttonText
                    acButton.setTitle("C", for: .normal)
                } else if buttonText != "0" && buttonText != "00" {
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
        
        updateMainLabel()
        // Update value in converter label
        if buttonText != "." {
            updateConverterLabel()
        }
        
    }
    
    // Sign buttons actions
    @objc func signButtonTapped(_ sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        
        // update conversion state
        updateConversionState()
        
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
                // TODO: Error handling
                //updateMainLabelRawValue()
                let test = calculationHandler.negate(value: mainLabelRawValue, system: systemMain!).value
                
                label.text = test
            }
            updateConverterLabel()
        // Subtraction button
        case "\u{00f7}":
            // calc results
            label.text = calculateResult(inputValue: mainLabelRawValue, operation: .div)
        // Multiplication button
        case "X":
            // calc results
            label.text = calculateResult(inputValue: mainLabelRawValue, operation: .mul)
        // Multiplication button
        case "-":
            // calc results
            label.text = calculateResult(inputValue: mainLabelRawValue, operation: .sub)
        // Addition button
        case "+":
            // calc results
            label.text = calculateResult(inputValue: mainLabelRawValue, operation: .add)
        case "=":
            if mathState != nil {
                print("calculation")
                // calculate
                if let result = calculationHandler.calculate(firstValue: mathState!.buffValue, operation: mathState!.operation, secondValue: mainLabelRawValue, for: systemMain!) {
                    label.text = result.value
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
    @objc func toggleIsSigned(_ sender: UIButton) {
        // negate value if number is negative and processsigned == on
        if mainLabelRawValue.isSigned && processSigned {
            mainLabel.text = calculationHandler.negate(value: mainLabelRawValue, system: systemMain!).value
        }
        // invert value
        processSigned.toggle()
        
        // update value
        updateIsSignedButton()
        // TODO: Main label
        // save state to UserDefaults
        saveCalcState()
        print("Signed - \(processSigned)")
        // update converter and main labels
        updateConverterLabel()
        
        // TODO Refactor
        // clear main label if overflow
//        if let converterNum = Int(converterLabel.text!.removeAllSpaces()) {
//            mainLabel.text = converterNum == 0 ? "0" : mainLabel.text
//        }
        updateMainLabel()
        // toggle plusminus button
        changeStatePlusMinus()
    }
    
    // Change conversion button action
    @objc func changeConversionButtonTapped(_ sender: UIButton) {
        print("Start changing conversion")
        
        // label higliglht handling
        touchHandleLabelHighlight()
        
        // initialize vc popover
        let vc = ConversionViewController()
        
        // present settings
        //vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        
        // show popover
        self.present(vc, animated: false, completion: nil)
    }
    
    // Change word size button action
    @objc func changeWordSizeButtonTapped( _ sender: UIButton) {
        print("changeWordSizeButtonTapped")
        
        // label higliglht handling
        touchHandleLabelHighlight()
        
        // initialize vc popover
        let vc = WordSizeViewController()
        
        // present settings
        //vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        
        // add updaterHandler
        vc.updaterHandler = {
            self.updateAllLayout()
        }
        
        // show popover
        self.present(vc, animated: false, completion: nil)
    }
    
    // Settings button action
    @objc func settingsButtonTapped(_ sender: UIButton) {
        print("Open settings")
        
        // label higliglht handling
        touchHandleLabelHighlight()
        
        // initialize vc popover and nav vc
        let vc = SettingsViewController()
        let navigationController = UINavigationController()
        
        // present settings
        vc.modalPresentationStyle = .pageSheet
        
        navigationController.setViewControllers([vc], animated: false)
        self.present(navigationController, animated: true)
    }
    
    // 1's or 2's button tapped
    @objc func complementButtonTapped(_ sender: UIButton) {
        let buttonLabel = sender.titleLabel?.text
        // update conversion state
        updateConversionState()
        // switch complements
        switch buttonLabel {
        case "1's":
            // TODO: Error handling
            mainLabel.text = converterHandler.toOnesComplement(value: mainLabelRawValue, mainSystem: systemMain!).value
        case "2's":
            // TODO: Error handling
            mainLabel.text = converterHandler.toTwosComplement(value: mainLabelRawValue, mainSystem: systemMain!).value
        default:
            break
        }
        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }
    
    // Bitwise operations
    @objc func bitwiseButtonTapped(_ sender: UIButton) {
        let buttonLabel = sender.titleLabel?.text
        
        // update conversion state
        updateConversionState()
        
        // if float then exit
        guard !mainLabel.text!.contains(".") else {return}
        
        // swtch binary operation cases
        switch buttonLabel {
        case "X<<Y":
            mainLabel.text = calculateResult(inputValue: mainLabelRawValue, operation: .shiftLeft)
        case "X>>Y":
            mainLabel.text = calculateResult(inputValue: mainLabelRawValue, operation: .shiftRight)
        case "<<":
            // TODO: Error handling
            if let result = calculationHandler.shiftBits(value: mainLabelRawValue, mainSystem: systemMain!, shiftOperation: .shiftLeft, shiftCount: 1) {
                mainLabel.text = result.value
            } else {
                // do nothing
                return
            }
        case ">>":
            // TODO: Error handling
            if let result = calculationHandler.shiftBits(value: mainLabelRawValue, mainSystem: systemMain!, shiftOperation: .shiftRight, shiftCount: 1) {
                mainLabel.text = result.value
            } else {
                // do nothing
                return
            }
        case "AND":
            mainLabel.text = calculateResult(inputValue: mainLabelRawValue, operation: .and)
        case "OR":
            mainLabel.text = calculateResult(inputValue: mainLabelRawValue, operation: .or)
        case "XOR":
            mainLabel.text = calculateResult(inputValue: mainLabelRawValue, operation: .xor)
        case "NOR":
            mainLabel.text = calculateResult(inputValue: mainLabelRawValue, operation: .nor)
        default:
            break
        }
        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }
     
    @objc func swipeRightLabel(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            if mainLabel.text!.count > 1 {
                // delete last symbol in main label
                mainLabel.text?.removeLast()
                // check if "-" is only one symbol
                if mainLabel.text == "-" {
                    mainLabel.text = "0"
                }
            } else {
                // if only one digit in label (or 0) then replace it to "0"
                mainLabel.text = "0"
            }
            // update labels
            updateMainLabel()
            updateConverterLabel()
        }
    }
    
}



// =================
// MARK: - Extension
// =================

extension PCalcViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // load vc before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // handle highlighting of labels when page changes
        touchHandleLabelHighlight()
        
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
        // handle highlighting of labels when page changes
        touchHandleLabelHighlight()
        
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
