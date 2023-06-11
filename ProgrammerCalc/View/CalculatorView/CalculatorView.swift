//
//  CalculatorView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorViewDelegate: AnyObject {
    func clearLabels()
    func unhighlightLabels()
    func updateAllLayout()
    func updateClearButton(hasInput: Bool)
}

protocol CalculatorInput: AnyObject {
    func clearLabels()
    func mainLabelHasNoError() -> Bool
}

class CalculatorView: UIViewController, CalculatorInput, CalculatorViewDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    var output: CalculatorOutput!
    
    let displayView = CalculatorDisplayView()
    lazy var mainLabel = displayView.mainLabel
    lazy var converterLabel = displayView.converterLabel

    var buttonsContainerController: ButtonsContainerControllerProtocol!
    private var bitwiseKeypad: BitwiseKeypadController?
    
    // Device states
    private var isAllowedLandscape: Bool = false
    private var isDarkContentBackground: Bool = false
    
    // Style Factory
    private let styleFactory: StyleFactory = StyleFactory()
    
    private var mainSystem: ConversionSystemsEnum {
        return output.getMainSystem()
    }
    
    private var converterSystem: ConversionSystemsEnum {
        return output.getConverterSystem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        displayView.setViews()
        self.view.addSubview(displayView)
        self.view.layoutIfNeeded()
        displayView.layoutIfNeeded()

        NSLayoutConstraint.deactivate(displayView.landscape!)
        NSLayoutConstraint.activate(displayView.portrait!)
        
        // Add swipe left for deleting last value in main label
        [mainLabel, converterLabel].forEach { label in
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CalculatorView.labelSwipeRight))
            swipeRight.direction = .right
            label.addGestureRecognizer(swipeRight)
        }
        
        output.setDelegates(mainLabel: mainLabel, converterLabel: converterLabel)
        
        self.view.addSubview(buttonsContainerController.view)
        buttonsContainerController.didMove(toParent: self)
        
        buttonsContainerController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsContainerController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonsContainerController.view.leadingAnchor.constraint(equalTo: self.displayView.leadingAnchor),
            buttonsContainerController.view.trailingAnchor.constraint(equalTo: self.displayView.trailingAnchor),
            buttonsContainerController.view.topAnchor.constraint(equalTo: self.displayView.labelsStack.bottomAnchor, constant: 30),
            buttonsContainerController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        //addLabelsUpdateHandlers()
        
        updateInfoSubLabels()
        handleConversion()

        updateAllLayout()
        handleDisplayingMainLabel()
        updateButtonsState()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchHandleLabelHighlight))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UIDevice.currentDeviceType == .iPad {
            AppDelegate.AppUtility.lockPortraitOrientation()
        } else {
            AppDelegate.AppUtility.unlockPortraitOrientation()
        }

        
        if #available(iOS 16.0, *) {
            setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        
        isAllowedLandscape = true
        buttonsContainerController.view.layoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateStyle()
        guard let phoneVC = self.buttonsContainerController as? ButtonsViewControllerPhone else { return }
        handleDeviceOrientationChange(phoneVC)
    }
    
    // Only for Phone
    // Handle orientation change for constraints
    func handleDeviceOrientationChange(_ phoneVC: ButtonsViewControllerPhone) {
        // get current device orientation
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let isPortrait = windowScene?.interfaceOrientation.isPortrait ?? UIDevice.current.orientation.isPortrait
        let isLandscape = windowScene?.interfaceOrientation.isLandscape ?? UIDevice.current.orientation.isLandscape
        
        if isPortrait && !isLandscape {
            // show button pages
            for page in phoneVC.calcButtonsViewControllers {
                page.showWithAnimation()
            }
            // change constraints
            displayView.showNavigationBar()
            NSLayoutConstraint.deactivate(displayView.landscape!)
            NSLayoutConstraint.deactivate(displayView.landscapeWithBitKeypad!)
            NSLayoutConstraint.activate(displayView.portrait!)

            // update label layouts
            handleDisplayingMainLabel()
            mainLabel.sizeToFit()
            mainLabel.infoSubLabel.sizeToFit()
            converterLabel.infoSubLabel.sizeToFit()
            converterLabel.sizeToFit()
            // show pagecontrol
            phoneVC.setPageControl(visibile: true)
            // show word size button
            displayView.changeWordSizeButton.isHidden = false
            // set default calcView frame
            displayView.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: displayView.getViewHeight())
            
        } else if isLandscape && !isPortrait && isAllowedLandscape {
            // hide word size button
            displayView.changeWordSizeButton.isHidden = true
            // hide button pages
            for page in phoneVC.calcButtonsViewControllers {
                page.hideWithAnimation()
            }
            // change constraints
            NSLayoutConstraint.deactivate(displayView.portrait!)
            displayView.hideNavigationBar()
            // landscape constraints by existing bitwiseKeypad
            if bitwiseKeypad != nil {
                displayView.hideConverterLabel()
                NSLayoutConstraint.activate(displayView.landscapeWithBitKeypad!)
            } else {
                NSLayoutConstraint.activate(displayView.landscape!)
            }
            // hide pagecontrol
            phoneVC.setPageControl(visibile: false)
            // set landscape calcView frame
            displayView.frame = UIScreen.main.bounds
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
    
    func layoutSubviews() {
        self.view.layoutSubviews()
        self.displayView.layoutSubviews()
        self.buttonsContainerController.layoutSubviews()
    }
    
    // MARK: - Methods
    
    private func updateInfoSubLabels() {
        mainLabel.setInfoLabelValue(mainSystem)
        converterLabel.setInfoLabelValue(converterSystem)
    }
    
    public func handleConversion() {
        if output.isInvalidMainLabelInput(mainLabel.text!) {
            clearLabels()
        }
    }
    
    public func updateChangeWordSizeButton() {
        displayView.updateCnageWordSizeButton(with: WordSize.shared)
    }
    
    public func unhighlightLabels() {
        if mainLabel.layer.backgroundColor != UIColor.clear.cgColor { mainLabel.hideLabelMenu() }
        if converterLabel.layer.backgroundColor != UIColor.clear.cgColor { converterLabel.hideLabelMenu() }
    }

    public func clearLabels() {
        output.resetCurrentValueAndUpdateLabels()
    }
    
    private func updateStyle() {
        let styleSettings = output.getCurrentStyleSettings()
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
            output.updateStyleSettings(styleSettings)
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
        updateButtonsState()
        updateLabels()
    }
    
    // Handle button enabled state for various conversion systems
    public func updateButtonsState() {
        let forbidden: Set<String> = output.getForbiddenToInputDigits()
        buttonsContainerController.updateButtonsIsEnabled(by: forbidden)
        updateIsSignedButton(processSigned: output.isProcessSigned())
        updatePlusMinusButton(processSigned: output.isProcessSigned())
    }

    private func updatePlusMinusButton(processSigned: Bool) {
        if let plusMinusButton = self.view.viewWithTag(101) as? CalculatorButton {
            plusMinusButton.isEnabled = processSigned
            plusMinusButton.alpha = plusMinusButton.isEnabled ? 1.0 : 0.5
        }
    }

    private func updateIsSignedButton(processSigned: Bool) {
        if let isSignedButton = self.view.viewWithTag(102) as? CalculatorButton {
            isSignedButton.changeTitleIsSignedButtonFor(processSigned)
        }
    }
    
    private func updateLabels() {
        mainLabelUpdate()
        converterLabelUpdate()
    }
    
    private func mainLabelUpdate() {
        output.updateMainLabelWithCurrentValue()
    }
    
    private func converterLabelUpdate() {
        output.updateConverterLabelWithCurrentValue()
    }
    
    private func mainLabelAdd(digit: String) {
        output.mainLabelAddAndUpdate(digit: digit)
    }
    
    func updateClearButton(hasInput state: Bool) {
        if let clearButton = self.view.viewWithTag(100) as? CalculatorButton {
            clearButton.changeTitleClearButtonFor(state)
        }
    }
    
    private func handleDisplayingMainLabel() {
        if mainSystem == converterSystem {
            displayView.hideConverterLabel()
        } else {
            displayView.showConverterLabel()
            mainLabel.numberOfLines = mainSystem == .bin ? 2 : 1 // 2 if binary else 1
        }
    }
   
    private func updateBitwiseKeypad() {
        guard let bitwiseKeypad = self.bitwiseKeypad,
              let bin = output.getCurrentValueBinary(format: false) else { return }
        bitwiseKeypad.binary = bin
        bitwiseKeypad.updateKeypad()
    }
    
    private func getBitwiseUpdateHandler() -> ((NumberSystemProtocol) -> Void) {
        let handler: ((NumberSystemProtocol) -> Void) = { [weak self] newValue in
            guard let strongSelf = self else { return }
            strongSelf.output.setNewCurrentValue(newValue)
            strongSelf.updateLabels()
        }
        return handler
    }
    
    private func refreshCalcButtons() {
        buttonsContainerController.refreshCalcButtons()
    }
    
    private func isBitwiseKeypadExists() -> Bool {
        return bitwiseKeypad != nil
    }
    
    func mainLabelHasNoError() -> Bool {
        return mainLabel.error == nil
    }

}

extension CalculatorView {
    
    // MARK: - Actions
    
    @objc func touchHandleLabelHighlight() {
        self.unhighlightLabels()
    }
    
    @objc func numericButtonTapped(_ sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        // update AC/C button
        if buttonText != "0" && buttonText != "00" {
            updateClearButton(hasInput: true)
        }
 
        print("Button \(buttonText) touched")

        mainLabelAdd(digit: buttonText)
        converterLabelUpdate()
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
        
        output.doOperationFor(operationString: sender.accessibilityIdentifier ?? "")
    }
    
    // Signed OFF/ON button
    @objc func toggleIsSigned(_ sender: UIButton) {
        output.toggleProcessSigned()
        print("Signed - \(output.isProcessSigned())")
        self.updateIsSignedButton(processSigned: output.isProcessSigned())
        self.updatePlusMinusButton(processSigned: output.isProcessSigned())
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        print("Clear")
        mainLabel.resetError()
        converterLabel.resetError()
        updateClearButton(hasInput: false)
        clearLabels()
        output.resetCalculation()
    }
    
    @objc func calculateButtonTapped(_ sender: UIButton) {
        print("=")
        output.doCalculation()
    }

    @objc func negateButtonTapped(_ sender: UIButton) {
        print("±")
        output.doNegation()
    }
    
    @objc func changeConversionButtonTapped(_ sender: UIButton) {
        touchHandleLabelHighlight()
        let changeConversionVC = ConversionViewController()
        changeConversionVC.modalPresentationStyle = .overFullScreen
        //changeConversionVC.delegate = self
        changeConversionVC.updateHandler = {
            self.updateInfoSubLabels()
            self.handleDisplayingMainLabel()
            self.updateButtonsState()
            self.updateBitwiseKeypad()
        }
        self.present(changeConversionVC, animated: false, completion: nil)
    }
    
    // Keypad switch action Default/Bitwise
    @objc func switchKeypad(_ sender: UIBarButtonItem) {
        touchHandleLabelHighlight()
        let animDuration: CGFloat = 0.3
        let animOptions: UIView.AnimationOptions = [.curveEaseInOut]
        let calcButtonsTransform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        let bitwiseKeypadTransform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)

        displayView.freezeNavBar(by: animDuration * 1.5) // also freezes all navbar items

        if isBitwiseKeypadExists() {

            sender.changeImage(named: "keypadIcon-bitwise")

            buttonsContainerController.view?.transform = calcButtonsTransform

            UIView.animate(withDuration: animDuration, delay: 0, options: animOptions, animations: {
                AppDelegate.AppUtility.lockPortraitOrientation()
                self.bitwiseKeypad?.view.transform = bitwiseKeypadTransform
                self.buttonsContainerController.view?.transform = .identity
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
            let bin = output.getCurrentValueBinary(format: false)!

            bitwiseKeypad = BitwiseKeypadController(binary: bin)

            self.addChild(bitwiseKeypad!)
            self.view.addSubview(bitwiseKeypad!.view)

            bitwiseKeypad?.updateHandlder = getBitwiseUpdateHandler()
            bitwiseKeypad?.setContainerConstraintsFor(self.buttonsContainerController.view)

            bitwiseKeypad?.view.transform = bitwiseKeypadTransform

            UIView.animate(withDuration: animDuration, delay: 0, options: animOptions, animations: {
                self.bitwiseKeypad?.view.transform = .identity
                self.buttonsContainerController.view?.transform = calcButtonsTransform
            }, completion: { [weak self] _ in
                self?.bitwiseKeypad?.didMove(toParent: self)
                //self?.buttonsContainerController.view?.transform = .identity
                self?.refreshCalcButtons()
            })
        }
    }

    @objc func changeWordSizeButtonTapped(_ sender: UIButton) {
        touchHandleLabelHighlight()
        let changeWordSizeVC = WordSizeViewController()
        changeWordSizeVC.modalPresentationStyle = .overFullScreen
        changeWordSizeVC.updaterHandler = {
            self.output.fixOverflowForCurrentValue()
            self.updateAllLayout()
            self.updateBitwiseKeypad()
        }
        self.present(changeWordSizeVC, animated: false, completion: nil)
    }
    
    @objc func settingsButtonTapped(_ sender: UIButton) {
        touchHandleLabelHighlight()
        let settingsVC = SettingsViewController()
        let navigationController = UINavigationController()
        settingsVC.modalPresentationStyle = .pageSheet
        navigationController.presentationController?.delegate = self
        settingsVC.updaterHandler = {
            self.updateBitwiseKeypad()
        }
        navigationController.setViewControllers([settingsVC], animated: false)
        self.present(navigationController, animated: true)
    }
     
    @objc func labelSwipeRight(_ sender: UISwipeGestureRecognizer) {
        touchHandleLabelHighlight()
        guard sender.direction == .right else { return }
        output.mainLabelRemoveTrailing()
        // update bitwise keypad if exists
        updateBitwiseKeypad()
    }
}

