//
//  CalculatorViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorViewControllerDelegate: AnyObject {
    func clearLabels()
    func unhighlightLabels()
    func updateAllLayout()
}

class CalculatorViewController: StyledViewController, CalculatorInput, CalculatorViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    var output: CalculatorOutput!
    
    let calculatorView = CalculatorView(frame: .zero)
    lazy var mainLabel = calculatorView.mainLabel
    lazy var converterLabel = calculatorView.converterLabel

    var buttonsContainerController: ButtonsContainerControllerProtocol!
    private var bitwiseKeypad: BitwiseKeypadController?
    
    // Device states
    private var isAllowedLandscape: Bool = false
    
    private var mainSystem: ConversionSystem { output.getMainSystem() }
    private var converterSystem: ConversionSystem { output.getConverterSystem() }
    
    override func loadView() {
        view = calculatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSLayoutConstraint.deactivate(calculatorView.landscape!)
        NSLayoutConstraint.activate(calculatorView.portrait!)
        
        // Add swipe left for deleting last value in main label
        [mainLabel, converterLabel].forEach { label in
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CalculatorViewController.labelSwipeRight))
            swipeRight.direction = .right
            label.addGestureRecognizer(swipeRight)
        }

        view.addSubview(buttonsContainerController.view)
        buttonsContainerController.didMove(toParent: self)
        
        buttonsContainerController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsContainerController.view.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor),
            buttonsContainerController.view.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor),
            buttonsContainerController.view.topAnchor.constraint(equalTo: calculatorView.labelsStack.bottomAnchor, constant: 30),
            buttonsContainerController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
 
        updateInfoSubLabels()
        handleConversion()

        updateAllLayout()
        handleDisplayingMainLabel()
        updateButtonsState()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchHandleLabelHighlight))
        view.addGestureRecognizer(tap)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let phoneVC = buttonsContainerController as? ButtonsViewControllerPhone else { return }
        handleDeviceOrientationChange(phoneVC)
    }
    
    override func styleWillUpdate(with style: Style) {
        super.styleWillUpdate(with: style)
        bitwiseKeypad?.updateStyle(style)
        view.backgroundColor = style.backgroundColor
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // Only for Phone
    // Handle orientation change for constraints
    func handleDeviceOrientationChange(_ phoneVC: ButtonsViewControllerPhone) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let isPortrait = windowScene?.interfaceOrientation.isPortrait ?? UIDevice.current.orientation.isPortrait
        let isLandscape = windowScene?.interfaceOrientation.isLandscape ?? UIDevice.current.orientation.isLandscape
        
        if isPortrait && !isLandscape {
            calculatorView.showNavigationBar()
            phoneVC.calcButtonsViewControllers.forEach { page in
                page.showWithAnimation()
            }

            NSLayoutConstraint.deactivate(calculatorView.landscape!)
            NSLayoutConstraint.deactivate(calculatorView.landscapeWithBitKeypad!)
            NSLayoutConstraint.activate(calculatorView.portrait!)

            handleDisplayingMainLabel()
            mainLabel.sizeToFit()
            mainLabel.infoSubLabel.sizeToFit()
            converterLabel.infoSubLabel.sizeToFit()
            converterLabel.sizeToFit()
            phoneVC.setPageControl(visibile: true)

        } else if isLandscape && !isPortrait && isAllowedLandscape {
            
            calculatorView.hideNavigationBar()
            phoneVC.calcButtonsViewControllers.forEach { page in
                page.hideWithAnimation()
            }
            
            NSLayoutConstraint.deactivate(calculatorView.portrait!)
            if bitwiseKeypad != nil {
                calculatorView.hideConverterLabel()
                NSLayoutConstraint.activate(calculatorView.landscapeWithBitKeypad!)
            } else {
                NSLayoutConstraint.activate(calculatorView.landscape!)
            }
            
            phoneVC.setPageControl(visibile: false)
            calculatorView.frame = UIScreen.main.bounds
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        unhighlightLabels()
    }
    
    func subviewsSetNeedsLayout() {
        view.setNeedsLayout()
        calculatorView.setNeedsLayout()
        buttonsContainerController.view.setNeedsLayout()
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
        calculatorView.updateCnageWordSizeButton(with: WordSize.shared)
    }
    
    public func unhighlightLabels() {
        if mainLabel.layer.backgroundColor != UIColor.clear.cgColor {
            mainLabel.hideLabelMenu()
        }
        if converterLabel.layer.backgroundColor != UIColor.clear.cgColor {
            converterLabel.hideLabelMenu()
        }
    }

    public func clearLabels() {
        output.resetCurrentValueAndUpdateLabels()
    }

    public func updateAllLayout() {
        updateChangeWordSizeButton()
        updateButtonsState()
        updateLabels()
        updateBitwiseKeypad()
    }
    
    // Handle button enabled state for various conversion systems
    public func updateButtonsState() {
        let forbidden: Set<String> = output.getForbiddenToInputDigits()
        buttonsContainerController.updateButtonsIsEnabled(by: forbidden)
        updateIsSignedButton(processSigned: output.isProcessSigned())
        updateNegateButton(processSigned: output.isProcessSigned())
    }

    private func updateNegateButton(processSigned: Bool) {
        if let negateButton = view.viewWithTag(tagCalculatorButtonNegate) as? CalculatorButton {
            negateButton.isEnabled = processSigned
            negateButton.alpha = negateButton.isEnabled ? 1.0 : 0.5
        }
    }

    private func updateIsSignedButton(processSigned: Bool) {
        if let isSignedButton = view.viewWithTag(tagCalculatorButtonIsSigned) as? CalculatorButton {
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
        if let clearButton = view.viewWithTag(tagCalculatorButtonClear) as? CalculatorButton {
            clearButton.changeTitleClearButtonFor(state)
        }
    }
    
    private func handleDisplayingMainLabel() {
        if mainSystem == converterSystem {
            calculatorView.hideConverterLabel()
        } else {
            calculatorView.showConverterLabel()
            mainLabel.numberOfLines = mainSystem == .bin ? 2 : 1 // 2 if binary else 1
        }
    }
   
    private func updateBitwiseKeypad() {
        guard let bitwiseKeypad = bitwiseKeypad, let bin = output.getCurrentValueBinary(format: false) else { return }
        bitwiseKeypad.binary = bin
        bitwiseKeypad.updateKeypad()
    }
    
    private func getBitwiseUpdateHandler() -> ((NumberSystemProtocol) -> Void) {
        return { [weak self] newValue in
            self?.output.setNewCurrentValue(newValue)
            self?.updateLabels()
        }
    }
    
    private func refreshCalcButtons() {
        buttonsContainerController.refreshCalcButtons()
    }
    
    private func isBitwiseKeypadExists() -> Bool {
        return bitwiseKeypad != nil
    }
    
    func mainLabelHasError() -> Bool {
        return mainLabel.hasError
    }
    
    func showErrorInLabels(_ error: MathErrors) {
        mainLabel.showErrorInLabel(error.localizedDescription!)
        converterLabel.showErrorInLabel("NaN")
    }
    
    func setErrorInLabels(_ error: MathErrors) {
        mainLabel.setError(error)
        converterLabel.setError(error)
    }
    
    func resetErrorInLabels() {
        mainLabel.resetError()
        converterLabel.resetError()
    }
    
    func getMainLabelText(deleteSpaces: Bool) -> String {
        return mainLabel.getText(deleteSpaces: deleteSpaces)
    }
    
    func setMainLabelText(_ text: String) {
        mainLabel.setText(text)
    }
    
    func setConverterLabelText(_ text: String) {
        converterLabel.setText(text)
    }
    
    func updateAfterConversionChange() {
        updateInfoSubLabels()
        handleDisplayingMainLabel()
        updateButtonsState()
        updateBitwiseKeypad()
    }
    
    func presentViewControlle(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, completion: nil)
    }
}

extension CalculatorViewController {
    
    // MARK: - Actions
    
    @objc func touchHandleLabelHighlight() {
        unhighlightLabels()
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
        
        if mainLabel.hasError {
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
        updateIsSignedButton(processSigned: output.isProcessSigned())
        updateNegateButton(processSigned: output.isProcessSigned())
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
        output.showConversion()
    }
    
    // Keypad switch action Default/Bitwise
    @objc func switchKeypad(_ sender: UIBarButtonItem) {
        touchHandleLabelHighlight()
        let animDuration: CGFloat = 0.3
        let animOptions: UIView.AnimationOptions = [.curveEaseInOut]
        let calcButtonsTransform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        let bitwiseKeypadTransform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)

        calculatorView.freezeNavBar(by: animDuration * 1.5) // also freezes all navbar items

        if isBitwiseKeypadExists() {

            sender.changeImage(named: "keypadIcon-bitwise")

            buttonsContainerController.view?.transform = calcButtonsTransform
            UIView.animate(withDuration: animDuration, delay: 0, options: animOptions, animations: { [weak self] in
                AppDelegate.AppUtility.lockPortraitOrientation()
                self?.bitwiseKeypad?.view.transform = bitwiseKeypadTransform
                self?.buttonsContainerController.view?.transform = .identity
            }, completion: { [weak self] _ in
                self?.bitwiseKeypad?.willMove(toParent: nil)
                self?.bitwiseKeypad?.view.removeFromSuperview()
                self?.bitwiseKeypad?.removeFromParent()
                self?.bitwiseKeypad = nil
                AppDelegate.AppUtility.unlockPortraitOrientation()
            })
        } else {
            sender.changeImage(named: "keypadIcon-default")
            let bin = output.getCurrentValueBinary(format: false)!
            bitwiseKeypad = BitwiseKeypadController(binary: bin)

            addChild(bitwiseKeypad!)
            view.addSubview(bitwiseKeypad!.view)

            bitwiseKeypad?.updateHandlder = getBitwiseUpdateHandler()
            bitwiseKeypad?.setContainerConstraintsFor(buttonsContainerController.view)
            bitwiseKeypad?.view.transform = bitwiseKeypadTransform

            UIView.animate(withDuration: animDuration, delay: 0, options: animOptions, animations: { [weak self] in
                self?.bitwiseKeypad?.view.transform = .identity
                self?.buttonsContainerController.view?.transform = calcButtonsTransform
            }, completion: { [weak self] _ in
                self?.bitwiseKeypad?.didMove(toParent: self)
                self?.refreshCalcButtons()
            })
        }
    }

    @objc func changeWordSizeButtonTapped(_ sender: UIButton) {
        touchHandleLabelHighlight()
        output.showWordSize()
    }
    
    @objc func settingsButtonTapped(_ sender: UIButton) {
        touchHandleLabelHighlight()
        output.showSettings()
    }
     
    @objc func labelSwipeRight(_ sender: UISwipeGestureRecognizer) {
        touchHandleLabelHighlight()
        guard sender.direction == .right else { return }
        output.mainLabelRemoveTrailing()
        updateBitwiseKeypad()
    }
}
