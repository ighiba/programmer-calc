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
    func updateClearButton(hasInput: Bool)
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
    private let styleStorage: StyleStorageProtocol = StyleStorage()
    // Shared instances
    private let conversionSettings: ConversionSettings = ConversionSettings.shared
    private let calcState: CalcState = CalcState.shared
    
    // Views
    let calcView: PCalcView = PCalcView()
    // input label
    lazy var mainLabel: CalculatorLabel = calcView.mainLabel
    // output label
    lazy var converterLabel: CalculatorLabel = calcView.converterLabel
    // array of pages with calc buttons
    private var arrayButtonsStack: [CalcButtonsPage] = [ CalcButtonsAdditional(), CalcButtonsMain() ]
    // additional bitwise keypad for input
    private var bitwiseKeypad: BitwiseKeypadController?
    
    // Device states
    private var isAllowedLandscape: Bool = false
    private var isDarkContentBackground: Bool = false
    
    // Style Factory
    private let styleFactory: StyleFactory = StyleFactory()
    // Object "Converter"
    private let converter: Converter = Converter()
    // Object "Calculator"
    private let calculator: Calculator = Calculator()
    
    // Array of button pages controllers
    lazy var calcButtonsViewControllers: [CalcButtonsViewController] = {
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
        self.delegate = self
        self.dataSource = self
        
        // Locks screen rotatiton in portrait mode while loading, unlocks in viewDidAppear
        AppDelegate.AppUtility.lockPortraitOrientation()

        // Add view from PCalcView
        calcView.setViews()
        self.view.addSubview(calcView)
        self.view.layoutIfNeeded()
        calcView.layoutIfNeeded()
        // Constraints
        NSLayoutConstraint.deactivate(calcView.landscape!)
        NSLayoutConstraint.activate(calcView.portrait!)
        // Setup page control
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.currentPageIndicatorTintColor = .systemGray
        
        // Allow interaction with content(buttons) without delay
        delaysContentTouches = false
        
        // Set start vc for pages (CalcButtonsMain)
        setViewControllers([calcButtonsViewControllers[1]], direction: .forward, animated: false, completion: nil)

        // Add swipe left for deleting last value in main label
        [mainLabel,converterLabel].forEach { label in
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(labelSwipeRight))
            swipeRight.direction = .right
            label.addGestureRecognizer(swipeRight)
        }
        
        calculator.mainLabelDelegate = self.mainLabel
        calculator.converterLabelDelegate = self.converterLabel
        calculator.pcalcViewControllerDelegate = self
        
        addLabelsUpdateHandlers()
        
        updateInfoSubLabels()
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
        AppDelegate.AppUtility.unlockPortraitOrientation()
        
        if #available(iOS 16.0, *) {
            setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        
        isAllowedLandscape = true
        // update shadows for buttons page
        calcButtonsViewControllers.forEach { $0.view.layoutSubviews() }
    }

    // Handle orientation change for constraints
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateStyle()
        // get current device orientation
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let isPortrait = windowScene?.interfaceOrientation.isPortrait ?? UIDevice.current.orientation.isPortrait
        let isLandscape = windowScene?.interfaceOrientation.isLandscape ?? UIDevice.current.orientation.isLandscape
        
        if isPortrait && !isLandscape {
            // show button pages
            for page in calcButtonsViewControllers {
                page.showWithAnimation()
            }
            // change constraints
            calcView.showNavigationBar()
            NSLayoutConstraint.deactivate(calcView.landscape!)
            NSLayoutConstraint.deactivate(calcView.landscapeWithBitKeypad!)
            NSLayoutConstraint.activate(calcView.portrait!)

            // update label layouts
            handleDisplayingMainLabel()
            mainLabel.sizeToFit()
            mainLabel.infoSubLabel.sizeToFit()
            converterLabel.infoSubLabel.sizeToFit()
            converterLabel.sizeToFit()
            // show pagecontrol
            setPageControl(visibile: true)
            // show word size button
            calcView.changeWordSizeButton.isHidden = false
            // set default calcView frame
            calcView.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: calcView.getViewHeight())
            
        } else if isLandscape && !isPortrait && isAllowedLandscape {
            // hide word size button
            calcView.changeWordSizeButton.isHidden = true
            // hide button pages
            for page in calcButtonsViewControllers {
                page.hideWithAnimation()
            }
            // change constraints
            NSLayoutConstraint.deactivate(calcView.portrait!)
            calcView.hideNavigationBar()
            // landscape constraints by existing bitwiseKeypad
            if bitwiseKeypad != nil {
                calcView.hideConverterLabel()
                NSLayoutConstraint.activate(calcView.landscapeWithBitKeypad!)
            } else {
                NSLayoutConstraint.activate(calcView.landscape!)
            }
            // hide pagecontrol
            setPageControl(visibile: false)
            // set landscape calcView frame
            calcView.frame = UIScreen.main.bounds
        }
    }
    
    // Handle dismissing modal vc
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Update rotation settings
        AppDelegate.AppUtility.lockPortraitOrientation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        unhighlightLabels()
    }

    // ===============
    // MARK: - Methods
    // ===============
    
    private func addLabelsUpdateHandlers() {
        // Add handler for main label
        (mainLabel as UpdatableLabel).updateHandler = { _ in
            guard self.mainLabel.error == nil else {
                self.calcState.updateMainValue("0")
                return
            }
            self.calcState.updateMainValue(self.mainLabel.text!)
        }
        // Add handler for converter label
        (converterLabel as UpdatableLabel).updateHandler = { _ in
            guard self.mainLabel.error == nil else {
                self.calcState.updateConverterValue("0")
                return
            }
            self.calcState.updateConverterValue(self.converterLabel.text!)
        }
    }
    	
    private func updateInfoSubLabels() {
        // info labels(sub labels) update
        mainLabel.setInfoLabelValue(conversionSettings.systemMain)
        converterLabel.setInfoLabelValue(conversionSettings.systemConverter)
    }
    
    public func handleConversion() {
        let forbiddenValues = ConversionValues.getForbiddenValues()
        
        if forbiddenValues[conversionSettings.systemMain]!.contains(where: mainLabel.text!.contains) {
            print("Forbidden values at input")
            print("Reseting input")
            clearLabels()
        }
    }
    
    public func updateChangeWordSizeButton() {
        calcView.updateCnageWordSizeButton(with: WordSize.shared)
    }
    
    // Make labels .clear color
    public func unhighlightLabels() {
        if mainLabel.layer.backgroundColor != UIColor.clear.cgColor { mainLabel.hideLabelMenu() }
        if converterLabel.layer.backgroundColor != UIColor.clear.cgColor { converterLabel.hideLabelMenu() }
    }
    
    // Clear mainLabel and update value in converter label
    public func clearLabels() {
        self.calculator.resetCurrentValue()
        self.mainLabelUpdate()
        self.converterLabelUpdate()
    }
    
    private func updateStyle() {
        // Apply style
        let styleSettings = StyleSettings.shared
        var styleType = styleSettings.currentStyle
        
        let interfaceStyle: UIUserInterfaceStyle
        // change style depends on state
        if styleSettings.isUsingSystemAppearance {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                // light mode detected
                styleSettings.currentStyle = .light
            case .dark:
                // dark mode detected
                styleSettings.currentStyle = .dark
            @unknown default:
                // light mode if unknown
                styleSettings.currentStyle = .dark
            }
            styleStorage.saveData(styleSettings)
            view.window?.overrideUserInterfaceStyle = .unspecified
            styleType = styleSettings.currentStyle

        } else {
            if styleType == .light {
                interfaceStyle = .light
            } else {
                interfaceStyle = .dark
            }
            view.window?.overrideUserInterfaceStyle = interfaceStyle
        }
        
        // Update bitwise keypad style if exist
        bitwiseKeypad?.updateStyle()
        
        let style = styleFactory.get(style: styleType)
        self.view.backgroundColor = style.backgroundColor
        isDarkContentBackground = styleType == .light ? false : true
        self.setNeedsStatusBarAppearanceUpdate()
    }

    public func updateAllLayout() {
        updateChangeWordSizeButton()
        updateIsSignedButton()
        changeStatePlusMinus()
        updateLabels()
    }
    
    private func updateLabels() {
        self.mainLabelUpdate()
        self.converterLabelUpdate()
    }
    
    // Handle button enabled state for various conversion systems
    public func updateButtonsState() {
        let forbidden: Set<String> = ConversionValues.getForbiddenValues()[conversionSettings.systemMain]!
        // Update all numeric buttons
        // loop buttons vc
        for vc in calcButtonsViewControllers {
            // update all numeric buttons state in vc
            if let buttonsPage = vc.view as? CalcButtonPageProtocol {
                buttonsPage.updateButtonIsEnabled(by: forbidden)
            }
        }
        updateIsSignedButton()
        changeStatePlusMinus()
    }
 
    // Handle displaying of mainLabel
    public func handleDisplayingMainLabel() {
        // IF System == System then hide label
        if conversionSettings.systemMain == conversionSettings.systemConverter {
            // hide
            calcView.hideConverterLabel()
        } else {
            // show
            calcView.showConverterLabel()
            // lines for binary
            mainLabel.numberOfLines = conversionSettings.systemMain == .bin ? 2 : 1 // 2 if binary else 1
        }
    }
    
    private func mainLabelUpdate() {
        self.calculator.mainLabelUpdate()
    }
    
    private func converterLabelUpdate() {
        self.calculator.converterLabelUpdate()
    }
    
    private func mainLabelAdd(digit: String) {
        self.calculator.mainLabelAdd(digit: digit)
    }
    
    // Change clear button title
    func updateClearButton(hasInput state: Bool) {
        if let clearButton = self.view.viewWithTag(100) as? CalculatorButton {
            clearButton.changeTitleClearButtonFor(state)
        }
    }
    
    // Change state of plusminus button
    private func changeStatePlusMinus() {
        if let plusMinusButton = self.view.viewWithTag(101) as? CalculatorButton {
            plusMinusButton.isEnabled = calcState.processSigned
            plusMinusButton.alpha = plusMinusButton.isEnabled ? 1.0 : 0.5
        }
    }
        
    // Update signed button
    private func updateIsSignedButton() {
        // get button by tag 102
        if let isSignedButton = self.view.viewWithTag(102) as? CalculatorButton {
            isSignedButton.changeTitleIsSignedButtonFor(calcState.processSigned)
        }
    }
    
    private func updateBitwiseKeypad() {
        if let vc = bitwiseKeypad {
            guard let bin = converter.convertValue(value: calculator.currentValue, to: .bin, format: false) as? Binary else {
                return
            }
            vc.binary = bin
            vc.updateKeypad()
        }
    }
    
    private func getBitwiseUpdateHandler() -> ((NumberSystemProtocol) -> Void) {
        let handler: ((NumberSystemProtocol) -> Void) = { newValue in
            // update currentValue
            let dec = self.converter.convertValue(value: newValue, to: .dec, format: true) as! DecimalSystem
            self.calculator.currentValue.updateValue(dec.decimalValue)
            self.updateLabels()
        }
        return handler
    }
    
    private func refreshCalcButtons() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [self] in
            let currentPage = (viewControllers?.first as? CalcButtonsViewController) ?? calcButtonsViewControllers[1]
            let currentPageCount = calcButtonsViewControllers.firstIndex(of: currentPage) ?? 1
            
            setViewControllers([currentPage], direction: .forward, animated: false, completion: nil)
            // update selected dot for uipagecontrol
            setPageControlCurrentPage(count: currentPageCount)
        })
    }
    
    private func isBitwiseKeypadExists() -> Bool {
        return bitwiseKeypad != nil
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
        if buttonText != "0" && buttonText != "00" {
            self.updateClearButton(hasInput: true)
        }
 
        print("Button \(buttonText) touched")
        
//        if self.calculator.hasPendingOperation && !self.calculator.operation!.shouldStartNewInput {
//            let digit = buttonText == "." ? "0." : buttonText
//            self.mainLabelAdd(digit: digit, shouldStartNewInput: true)
//            self.calculator.operation!.shouldStartNewInput = true
//        } else {
            self.mainLabelAdd(digit: buttonText)
//        }
        self.converterLabelUpdate()
    }
    
    // Sign buttons actions
    @objc func signButtonTapped(_ sender: UIButton) {
        guard sender.accessibilityIdentifier != "=" else { return }
        let buttonText = sender.titleLabel!.text ?? ""

        updateInfoSubLabels()
        
        print("Button \(buttonText) touched")
        
        if mainLabel.hasErrorMessage {
            mainLabel.resetError()
            converterLabel.resetError()
            clearLabels()
            return
        }
        
        let operation = calculator.getOperation(with: sender.accessibilityIdentifier ?? "")
        guard operation != .none else { return }
        
        if calculator.hasPendingOperation && calculator.shouldStartNewInput {
            calculator.setOperation(operation)
            return
        } else if calculator.hasPendingOperation {
            calculator.calculate()
            calculator.setOperation(operation)
            updateLabels()
        } else if isUnaryOperation(operation) {
            calculator.setOperation(operation)
            calculator.calculate()
            calculator.resetCalculation()
            calculator.shouldStartNewInput = true
            updateLabels()
        } else {
            calculator.setOperation(operation)
            calculator.shouldStartNewInput = true
        }
    }
    
    func isUnaryOperation(_ operation: CalcMath.OperationType) -> Bool {
        return operation == .shiftRight ||
               operation == .shiftLeft ||
               operation == .oneS ||
               operation == .twoS
    }
    
    // 1's or 2's button tapped
    @objc func complementButtonTapped(_ sender: UIButton) {
        // update conversion state
        updateInfoSubLabels()
        
        if mainLabel.hasErrorMessage {
            mainLabel.resetError()
            converterLabel.resetError()
            clearLabels()
            return
        }

        if calculator.currentValue.hasFloatingPoint {
            return
        }

        let operation = calculator.getOperation(with: sender.accessibilityIdentifier ?? "")
        guard operation != .none else { return }
        if operation == .oneS || operation == .twoS {
            calculator.setOperation(operation)
            calculator.calculate()
            calculator.resetCalculation()
            updateLabels()
        }
    }

    // Bitwise operations
    @objc func bitwiseButtonTapped(_ sender: UIButton) {
        // update conversion state
        updateInfoSubLabels()
        // if float then exit
        guard !mainLabel.text!.contains(".") else { return }
        
        let operation = calculator.getOperation(with: sender.accessibilityIdentifier ?? "" )
        guard operation != .none else { return }
        if operation == .shiftLeft || operation == .shiftRight {
            calculator.setOperation(operation)
            calculator.calculate()
            calculator.resetCalculation()
            updateLabels()
        } else {
            if calculator.hasPendingOperation && calculator.shouldStartNewInput {
                // calculate
                calculator.calculate()
                calculator.resetCalculation()
                updateLabels()
            } else {
                calculator.setOperation(operation)
            }
        }
    }
    
    // Signed OFF/ON button
    @objc func toggleIsSigned(_ sender: UIButton) {
        let valueIsNegativeAndWillProcessUnsigned = self.calculator.currentValue.isSigned && (self.calcState.processSigned == true)
        let valueIsPositiveAndWillProcessSigned = !self.calculator.currentValue.isSigned && (self.calcState.processSigned == false)
        
        self.calcState.processSigned.toggle()
        print("Signed - \(self.calcState.processSigned)")
        
        if valueIsNegativeAndWillProcessUnsigned || valueIsPositiveAndWillProcessSigned {
            let oldValue = self.calculator.currentValue
            self.calculator.currentValue.fixOverflow(bitWidth: WordSize.shared.value, processSigned: self.calcState.processSigned)
            
            if self.calculator.currentValue.isSignedAndFloat {
                self.clearLabels()
            } else if oldValue != self.calculator.currentValue {
                self.updateLabels()
            }
        }
        self.updateIsSignedButton()
        self.changeStatePlusMinus()
    }
    
    // AC/C button
    @objc func clearButtonTapped(_ sender: UIButton) {
        print("Clear")
        // Clear buttons
        mainLabel.resetError()
        converterLabel.resetError()
        updateClearButton(hasInput: false)
        clearLabels()
        calculator.resetCalculation()
    }
    
    // Calculate button =
    @objc func calculateButtonTapped(_ sender: UIButton) {
        print("=")
        if calculator.hasPendingOperation {
            calculator.calculate()
            calculator.resetCalculation()
            
            guard mainLabel.error == nil else { return }
            updateLabels()
        }
    }

    // Negate button
    @objc func negateButtonTapped(_ sender: UIButton) {
        if calculator.currentValue.hasFloatingPoint {
            return
        }
        calculator.negateCurrentValue()
        updateLabels()
    }
    
    // Change conversion button action
    @objc func changeConversionButtonTapped(_ sender: UIButton) {
        // label higliglht handling
        touchHandleLabelHighlight()
        // initialize vc popover
        let vc = ConversionViewController()
        // present settings
        vc.modalPresentationStyle = .overFullScreen
        // set delegate and update handler
        vc.delegate = self
        vc.updateHandler = {
            self.updateInfoSubLabels()
            self.handleDisplayingMainLabel()
            self.updateButtonsState()
            self.updateBitwiseKeypad()
        }
        // show popover
        self.present(vc, animated: false, completion: nil)
    }
    
    // Keypad switch action Default/Bitwise
    @objc func switchKeypad(_ sender: UIBarButtonItem) {
        touchHandleLabelHighlight()
        
        let animDuration: CGFloat = 0.3
        let animOptions: UIView.AnimationOptions = [.curveEaseInOut]
        let calcButtonsTransform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        let bitwiseKeypadTransform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                                                       
        calcView.freezeNavBar(by: animDuration * 1.5) // also freezes all navbar items
        
        if isBitwiseKeypadExists() {
            
            sender.changeImage(named: "keypadIcon-bitwise")
            
            calcButtonsViewControllers.forEach({ $0.view?.transform = calcButtonsTransform })
            
            UIView.animate(withDuration: animDuration, delay: 0, options: animOptions, animations: {
                AppDelegate.AppUtility.lockPortraitOrientation()
                self.bitwiseKeypad?.view.transform = bitwiseKeypadTransform
                self.calcButtonsViewControllers.forEach({ $0.view?.transform = .identity })
            }, completion: { [weak self] _ in
                self?.bitwiseKeypad?.willMove(toParent: nil)
                self?.bitwiseKeypad?.view.removeFromSuperview()
                self?.bitwiseKeypad?.removeFromParent()
                self?.bitwiseKeypad = nil
                AppDelegate.AppUtility.unlockPortraitOrientation()
            })
            
        } else {
            
            sender.changeImage(named: "keypadIcon-default")
            
            // prepare input value for bitwise keypad
            let bin = converter.convertValue(value: calculator.currentValue, to: .bin, format: false) as! Binary

            bitwiseKeypad = BitwiseKeypadController(binary: bin)
            
            self.addChild(bitwiseKeypad!)
            self.view.addSubview(bitwiseKeypad!.view)
            
            bitwiseKeypad?.updateHandlder = getBitwiseUpdateHandler()
            bitwiseKeypad?.setContainerConstraintsFor(self.view)

            bitwiseKeypad?.view.transform = bitwiseKeypadTransform
            
            UIView.animate(withDuration: animDuration, delay: 0, options: animOptions, animations: {
                self.bitwiseKeypad?.view.transform = .identity
                self.calcButtonsViewControllers.forEach({ $0.view?.transform = calcButtonsTransform })
            }, completion: { [weak self] _ in
                self?.bitwiseKeypad?.didMove(toParent: self)
                self?.calcButtonsViewControllers.forEach({ $0.view?.transform = .identity })
                self?.refreshCalcButtons()
            })
        }
    }

    // Change word size button action
    @objc func changeWordSizeButtonTapped(_ sender: UIButton) {
        touchHandleLabelHighlight()
        
        let vc = WordSizeViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.updaterHandler = {
            self.calculator.fixOverflowForCurrentValue()
            self.updateAllLayout()
            self.updateBitwiseKeypad()
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
            self.updateBitwiseKeypad()
        }
        navigationController.setViewControllers([vc], animated: false)
        self.present(navigationController, animated: true)
    }
     
    @objc func labelSwipeRight(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.calculator.mainLabelRemoveTrailing()
            // update bitwise keypad if exists
            self.updateBitwiseKeypad()
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
        if let index = calcButtonsViewControllers.firstIndex(of: viewController) {
            if index > 0 {
                return calcButtonsViewControllers[index - 1]
            }
        }

        return nil
    }
    
    // Load vc after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // handle highlighting of labels when page changes
        touchHandleLabelHighlight()
        
        guard let viewController = viewController as? CalcButtonsViewController else {return nil}
        if let index = calcButtonsViewControllers.firstIndex(of: viewController) {
            if index < arrayButtonsStack.count - 1 {
                return calcButtonsViewControllers[index + 1]
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
