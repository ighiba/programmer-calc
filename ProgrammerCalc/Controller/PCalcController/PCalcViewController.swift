//
//  PCalcViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit


protocol PCalcViewControllerDelegate: AnyObject {
    func clearLabels()
    func unhighlightLabels()
    func updateAllLayout()
    func handleDisplayingMainLabel()
    func updateButtonsState()
    func updateSystemMain(with value: ConversionSystemsEnum)
    func updateSystemCoverter(with value: ConversionSystemsEnum)
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
    // input label
    lazy var mainLabel: CalcualtorLabel = calcView.mainLabel
    // output label
    lazy var converterLabel: CalcualtorLabel = calcView.converterLabel
    // array of pages with calc buttons
    private var arrayButtonsStack: [CalcButtonsPage] = [CalcButtonsAdditional(),
                                                        CalcButtonsMain()]
    
    // Device states
    private var isAllowedLandscape: Bool = false
    private var isDarkContentBackground: Bool = false
    
    // Style Factory
    private let styleFactory: StyleFactory = StyleFactory()
    // Object "Converter"
    private let converter: Converter = Converter()
    // Object "Calculator"
    let calculator: Calculator = Calculator()
    
    
    // Array of button pages controllers
    lazy var arrayCalcButtonsViewController: [CalcButtonsViewController] = {
       var buttonsVC = [CalcButtonsViewController]()
        for buttonsPage in arrayButtonsStack {
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
        
        // Set start vc for pages (CalcButtonsMain)
        setViewControllers([arrayCalcButtonsViewController[1]], direction: .forward, animated: false, completion: nil)
        
        // Lock rotatiton in portrait mode
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

        // Add swipe left for deleting last value in main label
        [mainLabel,converterLabel].forEach { label in
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightLabel))
            swipeRight.direction = .right
            label.addGestureRecognizer(swipeRight)
        }
        
        // Add handler for main label
        (mainLabel as UpdatableLabel).updateNumberValueHandler = { _ in
            // update label numberValue
            self.updateMainLabelNumberValue()
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
        updateButtonsState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // unlock rotatiton
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.allButUpsideDown, andRotateTo: UIInterfaceOrientation.portrait)
        isAllowedLandscape = true
        // update shadows for buttons page
        arrayCalcButtonsViewController.forEach { $0.view.layoutSubviews() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save state to UserDefaults
        saveCalcState()
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
    
    // Handle dismissing modal vc
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Update rotation settings
        // unlock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.allButUpsideDown, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        unhighlightLabels()
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
        // Handle error in labels
        for error in MathErrors.allCases {
            if  mainLabel.text == error.localizedDescription {
                // set default values
                let newState = CalcState(mainState: "0", convertState: "0", processSigned: calculator.processSigned)
                calcStateStorage.saveData(newState)
                return
            }
        }
        // process if no error
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
        calculator.systemMain = data.systemMain
        calculator.systemConverter = data.systemConverter
        // labels info update
        mainLabel.setInfoLabelValue(calculator.systemMain!)
        converterLabel.setInfoLabelValue(calculator.systemConverter!)
    }
    
    // Handle conversion issues
    public func handleConversion() {
        let labelText = mainLabel.text
        let conversionSettings = conversionStorage.safeGetData()
        let forbidden = ConversionValues.getForbiddenValues()
        let systemMainFromEnum = conversionSettings.systemMain
        
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
            for item in WordSize.wordsDictionary {
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
        updateMainLabelNumberValue()
        // update converter label
        updateConverterLabel()
    }
    
    // Handle button enabled state for various conversion systems
    public func updateButtonsState() {
        let systemMain = calculator.systemMain ?? .dec // default value
        let forbidden: Set<String> = ConversionValues.getForbiddenValues()[systemMain]!
        // Update all numeric buttons
        // loop buttons vc
        for vc in arrayCalcButtonsViewController {
            // update all numeric buttons state in vc
            if let buttonsPage = vc.view as? CalcButtonPageProtocol {
                buttonsPage.updateButtonIsEnabled(by: forbidden)
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
                guard clearButton.titleLabel?.text != "C" else { return }
                clearButton.setTitle("C", for: .normal)
            } else {
                guard clearButton.titleLabel?.text != "AC" else { return }
                clearButton.setTitle("AC", for: .normal)
            }
        }
    }
    
    // Handle displaying of mainLabel
    public func handleDisplayingMainLabel() {
        // IF System == System then hide label
        if calculator.systemMain == calculator.systemConverter {
            // hide
            calcView.hideConverterLabel()
        } else {
            // unhide
            calcView.unhideConverterLabel()
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
    
    private func updateMainLabelNumberValue() {
        // update label numberValue
        let numValue = calculator.numberSystemFactory.get(strValue: mainLabel.text!, currentSystem: calculator.systemMain!)
        guard numValue != nil else {
            return
        }
        // set value to main label
        mainLabel.setNumberValue(numValue!)
        // update calculator inputValue (main label number value)
        calculator.inputValue = numValue!
    }
       
    public func updateConverterLabel() {
        // remove spaces mainLabel
        let labelText: String =  mainLabel.text!.removeAllSpaces() // remove spaces in mainLabel for converting

        // Check if error message in main label
        for error in MathErrors.allCases {
            if  mainLabel.text == error.localizedDescription {
                // set converter to NaN if error in label
                converterLabel.text = "NaN"
                return
            }
        }
        
        // Check if input is invalid (not allowed values in main label)
        let isInvalidInput: Bool = {
            let systemMain = calculator.systemMain ?? .dec // default value
            let allowed: Set<String> = ConversionValues.getAllowedValues()[systemMain]!
            let labelSet = Set<String>(labelText.map({ String($0) }))
            return labelSet.subtracting(allowed).isEmpty ? false : true
        }()

        if isInvalidInput {
            converterLabel.text = mainLabel.text
        } else {
            // if last char is dot then append dot
            var lastDotIfExists: String = mainLabel.text?.last == "." ? "." : ""
            // Update converter label with converted number
            updateConversionState()
            var newValue = converter.convertValue(value: calculator.inputValue, to: calculator.systemConverter!, format: true)
            guard newValue != nil else { return }
            if let bin = newValue as? Binary {
                // divide binary by parts
                newValue = bin.divideBinary(by: 4)
            }
            lastDotIfExists = lastDotIfExists == "." && !(newValue?.value.contains("."))! ? "." : ""
            converterLabel.text = newValue!.value + lastDotIfExists
        }
    }
    
    func updateSystemMain(with value: ConversionSystemsEnum) {
        calculator.systemMain = value
    }
    
    func updateSystemCoverter(with value: ConversionSystemsEnum) {
        calculator.systemConverter = value
    }
    
    // Add digit to end of main label
    private func addDigitToMainLabel( labelText: String, digit: String) -> String {
        var result = String()
        
        // Check if error message in main label
        for error in MathErrors.allCases where error.localizedDescription == mainLabel.text {
            // return digit
            return digit
        }

        if digit == "." && !labelText.contains(".") {
            // forbid float input when negative number
            if let dec = converter.convertValue(value: calculator.inputValue, to: .dec, format: true) as? DecimalSystem {
                if dec.decimalValue < 0 { return labelText }
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
        
        if calculator.mathState != nil && !calculator.mathState!.inputStart {
            mainLabel.text = buttonText == "." ? "0." : buttonText
            calculator.mathState!.inputStart = true
        } else {
            mainLabel.text! = addDigitToMainLabel(labelText: mainLabel.text!, digit: buttonText)
        }
        
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
        
        // Check if error message in main label
        for error in MathErrors.allCases where error.localizedDescription == mainLabel.text {
            // clear labels
            clearLabels()
        }
        
        // calculate
        mainLabel.text = calculator.calculateResult(inputValue: calculator.inputValue, operation: operation!)

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
        // Check if error message in main label
        for error in MathErrors.allCases where error.localizedDescription == mainLabel.text {
            // clear labels
            clearLabels()
        }
        // localization for 1's and 2's
        let oneS = NSLocalizedString("1's", comment: "")
        let twoS = NSLocalizedString("2's", comment: "")
        // switch complements
        switch buttonLabel {
        case oneS:
            mainLabel.text = converter.toOnesComplement(value: calculator.inputValue, mainSystem: calculator.systemMain!).value
        case twoS:
            mainLabel.text = converter.toTwosComplement(value: calculator.inputValue, mainSystem: calculator.systemMain!).value
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
        
        mainLabel.text = calculator.calculateResult(inputValue: calculator.inputValue, operation: operation!)

        // update all labels
        updateMainLabel()
        updateConverterLabel()
    }
    
    // Signed OFF/ON button
    @objc func toggleIsSigned(_ sender: UIButton) {
        // negate value if number is negative and processsigned == on
        if calculator.inputValue.isSigned && calculator.processSigned {
            mainLabel.text = calculator.negateValue(value: calculator.inputValue, system: calculator.systemMain!)
        } else if calculator.isValueOverflowed(value: calculator.inputValue.value, for: calculator.systemMain!, when: .negate) {
            clearLabels()
        }
        // invert value
        calculator.processSigned.toggle()
        print("Signed - \(calculator.processSigned)")
        
        // update value
        updateIsSignedButton()
        // save state processSigned
        saveCalcState()
        // update labels
        updateMainLabel()
        updateConverterLabel()
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
            mainLabel.text = calculator.calculateResult(inputValue: calculator.inputValue, operation: calculator.mathState!.operation)
            // reset state
            calculator.mathState = nil
            // update converter label
            updateConverterLabel()
        }
        // else do nothing
    }
    
    // Negate button
    @objc func negateButtonTapped(_ sender: UIButton) {
        // if float then exit
        guard !mainLabel.text!.contains(".") else { return }
        // calculate result
        let result = calculator.negateValue(value: calculator.inputValue, system: calculator.systemMain!)
        // check for overflow
        let isOverflowed = calculator.isValueOverflowed(value: result, for: calculator.systemMain!, when: .negate)
        guard !isOverflowed else { return }
        mainLabel.text = result
        updateMainLabel()
        updateConverterLabel()
    }
    
    // Change conversion button action
    @objc func changeConversionButtonTapped(_ sender: UIButton) {
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
