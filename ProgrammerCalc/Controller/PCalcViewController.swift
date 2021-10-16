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
    
    // Storages
    private let settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private let calcStateStorage: CalcStateStorageProtocol = CalcStateStorage()
    private let conversionStorage: ConversionStorageProtocol = ConversionStorage()
    private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    
    // Views
    private let calcView: PCalcView = PCalcView()
    lazy var mainLabel: CalcualtorLabel = calcView.mainLabel
    lazy var converterLabel: CalcualtorLabel = calcView.converterLabel
    
    private var isAllowedLandscape: Bool = false
    
    private var arrayButtonsStack = [UIView]()
    
    // Taptic feedback generator
    private let generator = UIImpactFeedbackGenerator(style: .light)
    // haptic feedback setting
    private var hapticFeedback = false

    // Handlers
    private let converter: Converter = Converter()
    
    
    // Object "Calculator"
    let calculator: Calculator = Calculator()
    
    // ======================
    // MARK: - Initialization
    // ======================
    
    // Array of button pages
    lazy var arrayCalcButtonsViewController: [CalcButtonsViewController] = {
       var buttonsVC = [CalcButtonsViewController]()
        arrayButtonsStack.forEach { (buttonsPage) in
            buttonsVC.append(CalcButtonsViewController(buttonsPage: buttonsPage))
        }
        return buttonsVC
    }()
    

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)

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
        calcView.setViews()
        self.view.addSubview(calcView)
        self.view.layoutIfNeeded()
        calcView.layoutIfNeeded()
        
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
        
        // lock rotatiton
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

        // add swipe left for deleting last value in main label
        [mainLabel,converterLabel].forEach { (label) in
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightLabel))
            swipeRight.direction = .right
            label.addGestureRecognizer(swipeRight)
        }
        
        // add handler for main label
        (mainLabel as UpdatableLabel).updateRawValueHandler = { [self] _ in
            // update label rawValue
            updateMainLabelRawValue()
        }
        
        // get states from UserDefaults
        updateSettings()
        updateConversionState()
        updateCalcState()
        handleConversion()
        
        // update layout
        updateAllLayout()
        // update displaying of mainLabel
        handleDisplayingMainLabel()
        // handle all buttons state for current conversion system
        updateButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("loaded")
        // unlock rotatiton
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.portrait)
        self.isAllowedLandscape = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // set state to UserDefaults
        print("main dissapear")
        saveCalcState()
    }
    
    // Handle orientation change for constraints
    override func viewDidLayoutSubviews() {
        let isPortrait = UIDevice.current.orientation.isPortrait
        let isLandscape = UIDevice.current.orientation.isLandscape
        
        if isPortrait && !isLandscape {
            
            // unhide button pages
            for page in arrayCalcButtonsViewController {
                UIView.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseOut, animations: {
                    page.view.alpha = 1
                    page.view.isHidden = false
                }, completion: nil)
            }
            
            // change constraints
            NSLayoutConstraint.deactivate(calcView.landscape!)
            NSLayoutConstraint.activate(calcView.portrait!)
            // update label layouts
            mainLabel.sizeToFit()
            mainLabel.infoSubLabel.sizeToFit()
            converterLabel.infoSubLabel.sizeToFit()
            converterLabel.sizeToFit()
            // unhide pagecontrol
            self.setPageControl(visibile: true)
            // unhide word size button
            calcView.changeWordSizeButton.isHidden = false
            
            // set default calcView frame
            self.calcView.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.calcView.viewHeight())
            

        } else if isLandscape && !isPortrait && isAllowedLandscape {
            
            // hide word size button
            calcView.changeWordSizeButton.isHidden = true
            // hide button pages
            for page in arrayCalcButtonsViewController {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    page.view.alpha = 0
                    page.view.isHidden = true
                }, completion: nil)
            }
            
            // change constraints
            NSLayoutConstraint.deactivate(calcView.portrait!)
            NSLayoutConstraint.activate(calcView.landscape!)
            // hide pagecontrol
            self.setPageControl(visibile: false)
            // set landscape calcView frame
            self.calcView.frame = UIScreen.main.bounds

        }
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
    private func updateCalcState() {
        // get data from UserDefaults
        let data = calcStateStorage.safeGetData()
        // apply data to view
        mainLabel.text = data.mainLabelState
        converterLabel.text = data.converterLabelState
        calculator.processSigned = data.processSigned
    }
    
    public func saveCalcState() {
        // TODO: Error handling
        let mainState = mainLabel.text ?? "0"
        let convertState = converterLabel.text ?? "0"
        let processSigned = calculator.processSigned
        // set data to UserDefaults
        let newState = CalcState(mainState: mainState, convertState: convertState, processSigned: processSigned)
        calcStateStorage.saveData(newState)
    }
    
    private func updateConversionState() {
        // get data from UserDefaults
        let data = conversionStorage.safeGetData()
        // properties update
        calculator.systemMain = ConversionSystemsEnum(rawValue: data.systemMain)
        calculator.systemConverter = ConversionSystemsEnum(rawValue: data.systemConverter)
        // labels info update
        mainLabel.setInfoLabelValue(calculator.systemMain!)
        converterLabel.setInfoLabelValue(calculator.systemConverter!)
    }
    
    // Handle conversion issues
    public func handleConversion() {
        let labelText = mainLabel.text
        let conversionSettings = conversionStorage.safeGetData()
        let forbidden = ConversionValues().forbidden
        
        if forbidden[conversionSettings.systemMain]!.contains(where: labelText!.contains) {
            print("Forbidden values at input")
            print("Reseting input")
            clearLabels()
        }
    }
    
    private func updateSettings() {
        // get data from UserDefaults
        let data = settingsStorage.safeGetData()
        hapticFeedback = data.hapticFeedback
    }
    
    public func updateChangeWordSizeButton() {
        let wordSize = wordSizeStorage.safeGetData() as! WordSize
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
    
    // Make labels .clear color
    public func unhighlightLabels() {
        if mainLabel.layer.backgroundColor != UIColor.clear.cgColor { mainLabel.hideLabelMenu() }
        if converterLabel.layer.backgroundColor != UIColor.clear.cgColor { converterLabel.hideLabelMenu() }
    }
    
    // Clear mainLabel and update value in converter label
    public func clearLabels() {
        mainLabel.text = "0"
        updateMainLabel()
        updateConverterLabel()
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
    
    // Handle button enabled state for various conversion systems
    public func updateButtons() {
        let systemMain = calculator.systemMain ?? .dec // default value
        let forbidden = ConversionValues().forbidden
        // Update all buttons except signed and plusminus
        // loop buttons vc
        for vc in arrayCalcButtonsViewController {
            // loop all buttons in vc
            if let buttonsPage = vc.view as? CalcButtonPageProtocol {
                buttonsPage.allButtons.forEach { button in
                    let buttonLabel = String((button.titleLabel?.text)!)
                    if forbidden[systemMain.rawValue]!.contains(buttonLabel) && button.calcButtonType == .numeric {
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
    
    // Handle displaying of mainLabel
    public func handleDisplayingMainLabel() {
        let fontName = mainLabel.font.fontName
        
        // IF System == System then hide label
        if calculator.systemMain == calculator.systemConverter {
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
            if calculator.systemMain == .bin {
                mainLabel.numberOfLines = 2
            } else {
                mainLabel.numberOfLines = 1
            }
        }
    }
    
    // Update main label to current format settings
    public func updateMainLabel() {
        mainLabel.text = calculator.processStrInputToFormat(inputStr: mainLabel.text!)
    }
    
    private func updateMainLabelRawValue() {
        // update label rawValue
        switch calculator.systemMain {
        case .bin:
            var bin = Binary()
            bin.value = mainLabel.text!
            bin = converter.processBinaryToFormat(bin)
            mainLabel.setRawValue(value: bin)
        case .oct:
            mainLabel.setRawValue(value: Octal(stringLiteral: mainLabel.text!))
        case .dec:
            mainLabel.setRawValue(value: DecimalSystem(stringLiteral: mainLabel.text!))
        case .hex:
            mainLabel.setRawValue(value: Hexadecimal(stringLiteral: mainLabel.text!))
        case .none:
            break
        }

        // update calculator rawValue
        self.calculator.mainLabelRawValue = mainLabel.rawValue
    }
       
    public func updateConverterLabel() {
        // remove spaces mainLabel
        let labelText: String =  mainLabel.text!.removeAllSpaces() // remove spaces in mainLabel for converting
        
        // TODO: Refator hadling for Hexadecimal values
        if Double(labelText) == nil && ( calculator.systemMain != .hex) {
            converterLabel.text = mainLabel.text
        } else {
            // if last char is dot then append dot
            var lastDotIfExists: String = mainLabel.text?.last == "." ? "." : ""
            // Update converter label with converted number
            // TODO: Error handling
            updateConversionState()
            var newValue = converter.convertValue(value: calculator.mainLabelRawValue, from: calculator.systemMain!, to: calculator.systemConverter!)
            if let bin = newValue as? Binary {
                newValue = bin.divideBinary(by: 4)
            }
            lastDotIfExists = lastDotIfExists == "." && !(newValue?.value.contains("."))! ? "." : ""
            uptdateConverterLabel(with: newValue!.value + lastDotIfExists)
        }
    }
    
    // Updating converter label with optional string value
    private func uptdateConverterLabel(with value: String?) {
        if let newValue = value {
            converterLabel.text = newValue
        } else {
            // TODO: Refactor or delete
            //       Localization
            converterLabel.text = "Impossible to convert"
        }
    }
    
    // Add digit to end of main label
    private func addDigitToMainLabel( labelText: String, digit: String) -> String {
        var result = String()
        
        if digit == "." && !labelText.contains(".") {
            return labelText + digit
        } else if digit == "." && labelText.contains(".") {
            return labelText
        }
        
        // special formatting for binary
        if calculator.systemMain == .bin {
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
        let isOverflowed = calculator.isValueOverflowed(value: result, for: calculator.systemMain!, when: .input)
        guard !isOverflowed else { return labelText }
        
        return result
    }
        
    // Update signed button
    private func updateIsSignedButton() {
        // get button by tag 102
        let isSignedButton = self.view.viewWithTag(102) as? CalculatorButton ?? CalculatorButton()
        
        if calculator.processSigned {
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
            plusMinusButton.isEnabled = calculator.processSigned
        }
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
    
    // Haptic feedback action for all buttons
    @objc func hapticFeedback(_ sender: CalculatorButton) {
        if hapticFeedback {
            generator.prepare()
            // impact
            generator.impactOccurred()
        }
    }
    
    // Numeric buttons actions
    @objc func numericButtonTapped(_ sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        // tag for AC/C button
        let acButton = self.view.viewWithTag(100) as! UIButton
        acButton.setTitle("C", for: .normal)
        
        print("Button \(buttonText) touched")
        
        if calculator.mathState != nil {
            // if new value not inputed
            if !calculator.mathState!.inputStart {
                mainLabel.text = buttonText == "." ? "0." : buttonText
                calculator.mathState!.inputStart = true
                
            } else {  mainLabel.text! = addDigitToMainLabel(labelText: mainLabel.text!, digit: buttonText) }
        } else { mainLabel.text! = addDigitToMainLabel(labelText: mainLabel.text!, digit: buttonText) }
        
        updateMainLabel()
        updateConverterLabel()
    }
    
    // Sign buttons actions
    @objc func signButtonTapped(_ sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        
        // update conversion state
        updateConversionState()
        
        print("Button \(buttonText) touched")
        
        let operation = calculator.getOperationBy(string: buttonText)
        guard operation != nil else { return }
        
        // calculate
        mainLabel.text = calculator.calculateResult(inputValue: calculator.mainLabelRawValue, operation: operation!)

        // update all labels
        updateMainLabel()
        updateConverterLabel()
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
            mainLabel.text = converter.toOnesComplement(value: calculator.mainLabelRawValue, mainSystem: calculator.systemMain!).value
        case "2's":
            // TODO: Error handling
            mainLabel.text = converter.toTwosComplement(value: calculator.mainLabelRawValue, mainSystem: calculator.systemMain!).value
        default:
            break
        }
        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }

    // Bitwise operations
    @objc func bitwiseButtonTapped(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        
        // update conversion state
        updateConversionState()
        
        // if float then exit
        guard !mainLabel.text!.contains(".") else { return }
        
        let operation = calculator.getOperationBy(string: buttonText!)
        guard operation != nil else { return }
        
        mainLabel.text = calculator.calculateResult(inputValue: calculator.mainLabelRawValue, operation: operation!)

        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }
    
    // Signed OFF/ON button
    @objc func toggleIsSigned(_ sender: UIButton) {
        // negate value if number is negative and processsigned == on
        if calculator.mainLabelRawValue.isSigned && calculator.processSigned {
            mainLabel.text = calculator.negateValue(value: calculator.mainLabelRawValue, system: calculator.systemMain!)
        } else if calculator.isValueOverflowed(value: calculator.mainLabelRawValue.value, for: calculator.systemMain!, when: .negate) {
            clearLabels()
        }
        // invert value
        calculator.processSigned.toggle()
        print("Signed - \(calculator.processSigned)")
        
        // update value
        updateIsSignedButton()
        // save state processSigned
        saveCalcState()
        // update converter and main labels
        updateConverterLabel()
        updateMainLabel()
        // toggle plusminus button
        changeStatePlusMinus()
    }
    
    // AC/C button
    @objc func clearButtonTapped(_ sender: UIButton) {
        print("clear")
        // Clear buttons
        if sender.titleLabel?.text != "AC" && sender.tag == 100 {
            sender.setTitle("AC", for: .normal)
        }
        clearLabels()
        calculator.mathState = nil
    }
    
    // Calculate button =
    @objc func calculateButtonTapped(_ sender: UIButton) {
        print("=")
        if calculator.mathState != nil {
            // calculate
            mainLabel.text = calculator.calculateResult(inputValue: calculator.mainLabelRawValue, operation: calculator.mathState!.operation)
            // reset state
            calculator.mathState = nil
        } else {
            print("do nothing")
        }
        updateConverterLabel()
    }
    
    // Negate button
    @objc func negateButtonTapped(_ sender: UIButton) {
        let result = calculator.negateValue(value: calculator.mainLabelRawValue, system: calculator.systemMain!)
        // check for overflow
        let isOverflowed = calculator.isValueOverflowed(value: result, for: calculator.systemMain!, when: .negate)
        guard !isOverflowed else { return }
        mainLabel.text = result
        updateConverterLabel()
    }
    
    // Change conversion button action
    @objc func changeConversionButtonTapped(_ sender: UIButton) {
        print("Start changing conversion")
        // label higliglht handling
        touchHandleLabelHighlight()
        // initialize vc popover
        let vc = ConversionViewController()
        // present settings
        vc.modalPresentationStyle = .overFullScreen
        // show popover
        self.present(vc, animated: false, completion: nil)
    }
    
    // Change word size button action
    @objc func changeWordSizeButtonTapped( _ sender: UIButton) {
        print("changeWordSizeButtonTapped")
        touchHandleLabelHighlight()
        
        let vc = WordSizeViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.updaterHandler = {
            self.updateAllLayout()
        }
        // show popover
        self.present(vc, animated: false, completion: nil)
    }
    
    // Settings button action
    @objc func settingsButtonTapped(_ sender: UIButton) {
        print("Open settings")
        touchHandleLabelHighlight()
        
        let vc = SettingsViewController()
        let navigationController = UINavigationController()
        vc.modalPresentationStyle = .pageSheet
        vc.updaterHandler = {
            self.updateSettings()
        }
        navigationController.setViewControllers([vc], animated: false)
        self.present(navigationController, animated: true)
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
    
    // Load vc before
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
    
    // Load vc after
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
    
    // How much pages will be
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayButtonsStack.count
    }
    
    // Starting index for dots
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
 
}
