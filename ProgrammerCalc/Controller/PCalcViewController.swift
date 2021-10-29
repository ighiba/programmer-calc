//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit


protocol PCalcViewControllerDelegate {
    func clearLabels()
    func unhighlightLabels()
    func updateAllLayout()
    func handleDisplayingMainLabel()
    func updateButtons()
    func updateSystemMain(with rawValue: String)
    func updateSystemCoverter(with rawValue: String)
}

class PCalcViewController: UIPageViewController, PCalcViewControllerDelegate, UIAdaptivePresentationControllerDelegate {

    // ==================
    // MARK: - Properties
    // ==================
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkContentBackground {
            return .lightContent
        } else {
            return .darkContent
        }
    }
    
    // Storages
    private let settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private let calcStateStorage: CalcStateStorageProtocol = CalcStateStorage()
    private let conversionStorage: ConversionStorageProtocol = ConversionStorage()
    private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    private let styleStorage: StyleStorageProtocol = StyleStorage()
    
    // Views
    let calcView: PCalcView = PCalcView()
    lazy var mainLabel: CalcualtorLabel = calcView.mainLabel
    lazy var converterLabel: CalcualtorLabel = calcView.converterLabel
    // Device state vars
    private var isAllowedLandscape: Bool = false
    private var isDarkContentBackground: Bool = false
    
    private var arrayButtonsStack = [UIView]()
    
    // Style Factory
    private let styleFactory: StyleFactory = StyleFactory()
    
    // Handlers
    private let converter: Converter = Converter()
    
    
    // Object "Calculator"
    let calculator: Calculator = Calculator()
    
    
    // Array of button pages
    lazy var arrayCalcButtonsViewController: [CalcButtonsViewController] = {
       var buttonsVC = [CalcButtonsViewController]()
        arrayButtonsStack.forEach { (buttonsPage) in
            let vc = CalcButtonsViewController(buttonsPage: buttonsPage)
            vc.delegate = self
            buttonsVC.append(vc)
        }
        return buttonsVC
    }()
    
    // ======================
    // MARK: - Initialization
    // ======================
    

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
        // Delegates
        self.delegate = self
        self.dataSource = self
        
        // Add pages of buttons
        let mainButtons = CalcButtonsMain(frame: CGRect())
        let additionalButtons = CalcButtonsAdditional(frame: CGRect())
        // Apend pages to array
        arrayButtonsStack.append(additionalButtons)
        arrayButtonsStack.append(mainButtons)
        // Add view from PCalcView
        calcView.setViews()
        self.view.addSubview(calcView)
        self.view.layoutIfNeeded()
        calcView.layoutIfNeeded()
        // Constraints
        NSLayoutConstraint.deactivate(calcView.landscape!)
        NSLayoutConstraint.activate(calcView.portrait!)
        // Add page control
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.currentPageIndicatorTintColor = .systemGray
        
        // Allow interaction with content without delay
        delaysContentTouches = false
        
        // Set start vc for pages
        setViewControllers([arrayCalcButtonsViewController[1]], direction: .forward, animated: false, completion: nil)
        
        // Lock rotatiton
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

        // Add swipe left for deleting last value in main label
        [mainLabel,converterLabel].forEach { (label) in
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightLabel))
            swipeRight.direction = .right
            label.addGestureRecognizer(swipeRight)
        }
        
        // Add handler for main label
        (mainLabel as UpdatableLabel).updateRawValueHandler = { _ in
            // update label rawValue
            self.updateMainLabelRawValue()
        }
        
        // Get data from UserDefaults
        updateSettings()
        updateConversionState()
        updateCalcState()
        handleConversion()
        
        // Update layout
        updateAllLayout()
        // Update displaying of mainLabel
        handleDisplayingMainLabel()
        // Handle all buttons state for current conversion system
        updateButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("loaded")
        // unlock rotatiton
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.allButUpsideDown, andRotateTo: UIInterfaceOrientation.portrait)
        isAllowedLandscape = true
        // update shadows for buttons page
        for page in arrayCalcButtonsViewController {
            page.view.layoutSubviews()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save state to UserDefaults
        print("main dissapear")
        saveCalcState()
    }
    
    // Handle dismissing modal vc
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Update rotation settings
        // unlock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.allButUpsideDown, andRotateTo: UIInterfaceOrientation.portrait)
    }

    // Handle orientation change for constraints
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateStyle()
        // get current device orientation
        let isPortrait = UIDevice.current.orientation.isPortrait
        let isLandscape = UIDevice.current.orientation.isLandscape
        
        if isPortrait && !isLandscape {
            // unhide button pages
            for page in arrayCalcButtonsViewController {
                page.view.layoutSubviews()
                UIView.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseOut, animations: {
                    page.view.alpha = 1
                    page.view.isHidden = false
                }, completion: nil )
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
            setPageControl(visibile: true)
            // unhide word size button
            calcView.changeWordSizeButton.isHidden = false
            // set default calcView frame
            calcView.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.calcView.viewHeight())
            
        } else if isLandscape && !isPortrait && isAllowedLandscape {
            // hide word size button
            calcView.changeWordSizeButton.isHidden = true
            // hide button pages
            for page in arrayCalcButtonsViewController {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    page.view.alpha = 0
                    page.view.isHidden = true
                }, completion: nil )
            }
            // change constraints
            NSLayoutConstraint.deactivate(calcView.portrait!)
            NSLayoutConstraint.activate(calcView.landscape!)
            // hide pagecontrol
            setPageControl(visibile: false)
            // set landscape calcView frame
            calcView.frame = UIScreen.main.bounds

        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        unhighlightLabels()
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
        var hasInput = true
        if let mainValue = Int(data.mainLabelState.removeAllSpaces()) {
            if mainValue == 0 {
                hasInput = false
            }
        }
        updateClearButton(hasInput: hasInput)
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
        let forbidden = ConversionValues.getForbiddenValues()
        let systemMainFromEnum = ConversionSystemsEnum(rawValue: conversionSettings.systemMain)!
        
        if forbidden[systemMainFromEnum]!.contains(where: labelText!.contains) {
            print("Forbidden values at input")
            print("Reseting input")
            clearLabels()
        }
    }
    
    private func updateSettings() {
        // get data from UserDefaults
        let data = settingsStorage.safeGetData()
        // update vc of buttons
        for vc in arrayCalcButtonsViewController {
            vc.hapticFeedback = data.hapticFeedback
            vc.tappingSounds = data.tappingSounds
        }
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
            return (calcView.changeWordSizeButton.titleLabel?.text)!
        }()
        
        // change button title
        calcView.changeWordSizeButton.setTitle(newTitle, for: .normal)
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
    
    func updateStyle() {
        // Apply style
        let styleState = styleStorage.safeGetSystemStyle()
        var styleName = styleStorage.safeGetStyleData()
        
        let interfaceStyle: UIUserInterfaceStyle
        // change style depends on state
        if styleState {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                // light mode detected
                styleStorage.saveData(.light)
            case .dark:
                // dark mode detected
                styleStorage.saveData(.dark)
            @unknown default:
                // light mode if unknown
                styleStorage.saveData(.light)
            }
            view.window?.overrideUserInterfaceStyle = .unspecified
            styleName = styleStorage.safeGetStyleData()

        } else {
            if styleName == .light {
                interfaceStyle = .light
            } else {
                interfaceStyle = .dark
            }
            view.window?.overrideUserInterfaceStyle = interfaceStyle
        }
        
        let style = styleFactory.get(style: styleName)
        self.view.backgroundColor = style.backgroundColor
        isDarkContentBackground = styleName == .light ? false : true
        self.setNeedsStatusBarAppearanceUpdate()
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
        let forbidden = ConversionValues.getForbiddenValues()
        // Update all buttons except signed and plusminus
        // loop buttons vc
        for vc in arrayCalcButtonsViewController {
            // loop all buttons in vc
            if let buttonsPage = vc.view as? CalcButtonPageProtocol {
                buttonsPage.allButtons.forEach { button in
                    let buttonLabel = String((button.titleLabel?.text)!)
                    if forbidden[systemMain]!.contains(buttonLabel) && button.calcButtonType == .numeric {
                        // disable and set transparent
                        button.isEnabled = false
                        button.alpha = 0.5
                    } else {
                        // enable button ans set normal opacity
                        button.isEnabled = true
                        button.alpha = 1
                    }
                }
            }
        }

        // update signed button value
        updateIsSignedButton()
        // update plusminus button state
        changeStatePlusMinus()
    }
    
    // Change clear button title
    private func updateClearButton(hasInput state: Bool) {
        if let clearButton = self.view.viewWithTag(100) as? CalculatorButton {
            if state {
                guard clearButton.titleLabel?.text != "C" else {
                    return
                }
                clearButton.setTitle("C", for: .normal)
            } else {
                guard clearButton.titleLabel?.text != "AC" else {
                    return
                }
                clearButton.setTitle("AC", for: .normal)
            }
        }
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
        mainLabel.text = calculator.processStrInputToFormat(inputStr: mainLabel.text!, for: calculator.systemMain!)
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
    
    func updateSystemMain(with rawValue: String) {
        calculator.systemMain = ConversionSystemsEnum(rawValue: rawValue)
    }
    
    func updateSystemCoverter(with rawValue: String) {
        calculator.systemConverter = ConversionSystemsEnum(rawValue: rawValue)
    }
    
    // Add digit to end of main label
    private func addDigitToMainLabel( labelText: String, digit: String) -> String {
        var result = String()
        
        if digit == "." && !labelText.contains(".") {
            // forbid float input when negative number
            if let dec = converter.convertValue(value: calculator.mainLabelRawValue, from: calculator.systemMain!, to: .dec) as? DecimalSystem {
                if dec.decimalValue < 0 {
                    return labelText
                }
            }
            
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
        if let isSignedButton = self.view.viewWithTag(102) as? CalculatorButton {
            if calculator.processSigned {
                // if ON then disable
                // TODO: Localization ?
                isSignedButton.setTitle("Signed\nON", for: .normal)
            } else {
                // if OFF then enable
                isSignedButton.setTitle("Signed\nOFF", for: .normal)
            }
        }
    }
    
    // Change state of plusminus button
    private func changeStatePlusMinus() {
        if let plusMinusButton = self.view.viewWithTag(101) as? CalculatorButton {
            plusMinusButton.isEnabled = calculator.processSigned
            if plusMinusButton.isEnabled {
                plusMinusButton.alpha = 1.0
            } else {
                plusMinusButton.alpha = 0.5
            }
        }
    }
    
    // ===============
    // MARK: - Actions
    // ===============

    @objc func touchHandleLabelHighlight() {
        unhighlightLabels()
    }
    
    
    // Numeric buttons actions
    @objc func numericButtonTapped(_ sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        // update AC/C button
        if buttonText != "0" && buttonText != "00" { updateClearButton(hasInput: true) }
 
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
        // if float then exit
        guard !mainLabel.text!.contains(".") else { return }
        // localization for 1's and 2's
        let oneS = NSLocalizedString("1's", comment: "")
        let twoS = NSLocalizedString("2's", comment: "")
        // switch complements
        switch buttonLabel {
        case oneS:
            // TODO: Error handling
            mainLabel.text = converter.toOnesComplement(value: calculator.mainLabelRawValue, mainSystem: calculator.systemMain!).value
        case twoS:
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
        updateClearButton(hasInput: false)
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
        // if float then exit
        guard !mainLabel.text!.contains(".") else { return }
        // calculate result
        let result = calculator.negateValue(value: calculator.mainLabelRawValue, system: calculator.systemMain!)
        // check for overflow
        let isOverflowed = calculator.isValueOverflowed(value: result, for: calculator.systemMain!, when: .negate)
        guard !isOverflowed else { return }
        mainLabel.text = result
        updateMainLabel()
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
        // set delegate
        vc.delegate = self
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
        navigationController.presentationController?.delegate = self
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

// MARK: - DataSource


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
