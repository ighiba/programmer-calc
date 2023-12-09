//
//  CalculatorViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

enum CalculatorLabelsDisplayMode {
    case standart(inputNumberOfLines: Int, outputNumberOfLines: Int)
    case onlyInputLabel(numberOfLines: Int)
}

protocol CalculatorInput: AnyObject {
    func setInputLabelText(_ text: String)
    func setOutputLabelText(_ text: String)
    func setInputConversionSystemLabelText(_ text: String)
    func setOutputConversionSystemLabelText(_ text: String)
    func setLabelsDisplayMode(_ displayMode: CalculatorLabelsDisplayMode)
    func setWordSizeButtonTitle(_ title: String)
    func setClearButtonTitle(inputHasStarted: Bool)
    func setNegateButton(isEnabled: Bool)
    func changeSignedButtonLabel(isSigned: Bool)
    func disableNumericButtons(withForbiddenDigits forbiddenDigits: Set<String>)
    func updateBitwiseKeypad(withBits bits: [Bit])
    func presentViewController(_ viewController: UIViewController, animated: Bool)
}

final class CalculatorViewController: StyledViewController, CalculatorInput, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    var output: CalculatorOutput!
    
    private let calculatorView = CalculatorView()
    private lazy var inputLabel = calculatorView.inputLabel
    private lazy var outputLabel = calculatorView.outputLabel

    var buttonsContainerController: ButtonsContainerControllerProtocol!
    private var bitwiseKeypad: BitwiseKeypadController?
    
    private var isAllowedLandscape: Bool = false
    
    override func loadView() {
        view = calculatorView
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGestures()
        
        output.viewDidLoad()
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
        
        handlePhoneOrientationChange(phoneVC)
    }
    
    override func styleWillUpdate(with style: Style) {
        super.styleWillUpdate(with: style)
        
        bitwiseKeypad?.updateStyle(style)
        view.backgroundColor = style.backgroundColor
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func handlePhoneOrientationChange(_ phoneVC: ButtonsViewControllerPhone) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let isPortrait = windowScene?.interfaceOrientation.isPortrait ?? UIDevice.current.orientation.isPortrait
        let isLandscape = windowScene?.interfaceOrientation.isLandscape ?? UIDevice.current.orientation.isLandscape
        let willEnterPortraitOrientation = isPortrait && !isLandscape
        let willEnterLandscapeOrientation = isLandscape && !isPortrait && isAllowedLandscape
        
        if willEnterPortraitOrientation {
            calculatorView.showNavigationBar()
            phoneVC.calcButtonsViewControllers.forEach { $0.showWithAnimation() }
            
            output.didEnterPhonePortraitOrientation()

            NSLayoutConstraint.deactivate(calculatorView.landscape!)
            NSLayoutConstraint.deactivate(calculatorView.landscapeWithBitKeypad!)
            NSLayoutConstraint.activate(calculatorView.portrait!)

            inputLabel.sizeToFit()
            outputLabel.sizeToFit()
            inputLabel.conversionSystemLabel.sizeToFit()
            outputLabel.conversionSystemLabel.sizeToFit()
            
            phoneVC.setPageControl(isVisible: true)
        } else if willEnterLandscapeOrientation {
            calculatorView.hideNavigationBar()
            phoneVC.calcButtonsViewControllers.forEach { $0.hideWithAnimation() }
            
            NSLayoutConstraint.deactivate(calculatorView.portrait!)
            
            let isBitwiseKeypadActive = bitwiseKeypad != nil
            
            if isBitwiseKeypadActive {
                NSLayoutConstraint.activate(calculatorView.landscapeWithBitKeypad!)
            } else {
                NSLayoutConstraint.activate(calculatorView.landscape!)
            }
            
            output.didEnterPhoneLandscapeOrientation(isBitwiseKeypadActive: isBitwiseKeypadActive)
            
            phoneVC.setPageControl(isVisible: false)
            calculatorView.frame = UIScreen.main.bounds
        }
    }
    
    func subviewsSetNeedsLayout() {
        view.setNeedsLayout()
        calculatorView.setNeedsLayout()
        buttonsContainerController.view.setNeedsLayout()
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        NSLayoutConstraint.deactivate(calculatorView.landscape!)
        NSLayoutConstraint.activate(calculatorView.portrait!)

        view.addSubview(buttonsContainerController.view)
        buttonsContainerController.didMove(toParent: self)
        
        buttonsContainerController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsContainerController.view.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor),
            buttonsContainerController.view.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor),
            buttonsContainerController.view.topAnchor.constraint(equalTo: calculatorView.labelsStack.bottomAnchor, constant: 30),
            buttonsContainerController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupGestures() {
        inputLabel.addSwipeRightGesture(target: self, action: #selector(labelSwipeRight))
        outputLabel.addSwipeRightGesture(target: self, action: #selector(labelSwipeRight))
    }
    
    func setInputLabelText(_ text: String) {
        inputLabel.setText(text)
    }
    
    func setOutputLabelText(_ text: String) {
        outputLabel.setText(text)
    }
    
    func setInputConversionSystemLabelText(_ text: String) {
        inputLabel.conversionSystemLabel.text = text
    }
    
    func setOutputConversionSystemLabelText(_ text: String) {
        outputLabel.conversionSystemLabel.text = text
    }
    
    func setLabelsDisplayMode(_ displayMode: CalculatorLabelsDisplayMode) {
        switch displayMode {
        case .standart(let inputNumberOfLines, let outputNumberOfLines):
            calculatorView.showOutputLabel()
            inputLabel.numberOfLines = inputNumberOfLines
            outputLabel.numberOfLines = outputNumberOfLines
        case .onlyInputLabel(let numberOfLines):
            calculatorView.hideOutputLabel()
            inputLabel.numberOfLines = numberOfLines
        }
    }
    
    func setWordSizeButtonTitle(_ title: String) {
        calculatorView.setWordSizeButtonTitle(title)
    }
    
    func setClearButtonTitle(inputHasStarted state: Bool) {
        let clearButton = view.viewWithTag(tagCalculatorButtonClear) as? CalculatorButton
        clearButton?.changeTitleClearButtonFor(state)
    }
    
    func setNegateButton(isEnabled: Bool) {
        let negateButton = view.viewWithTag(tagCalculatorButtonNegate) as? CalculatorButton
        negateButton?.isEnabled = isEnabled
        negateButton?.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func changeSignedButtonLabel(isSigned: Bool) {
        let signedButton = view.viewWithTag(tagCalculatorButtonIsSigned) as? CalculatorButton
        signedButton?.changeTitleIsSignedButtonFor(isSigned)
    }
    
    func disableNumericButtons(withForbiddenDigits forbiddenDigits: Set<String>) {
        buttonsContainerController.disableNumericButtons(withForbiddenDigits: forbiddenDigits)
    }
    
    func updateBitwiseKeypad(withBits bits: [Bit]) {
        bitwiseKeypad?.update(withBits: bits)
    }
    
    func presentViewController(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, completion: nil)
    }
}

// MARK: - Actions

extension CalculatorViewController {

    @objc func clearButtonDidPress(_ sender: UIButton) {
        print("clearButtonDidPress")
        output.clearButtonDidPress()
    }
    
    @objc func negateButtonDidPress(_ sender: UIButton) {
        print("negateButtonDidPress")
        output.negateButtonDidPress()
    }
    
    @objc func signedButtonDidPress(_ sender: UIButton) {
        print("signedButtonDidPress")
        output.signedButtonDidPress()
    }
    
    @objc func numericButtonDidPress(_ sender: UIButton) {
        guard let buttonLabel = sender.titleLabel?.text else { return }
        
        print("numericButtonDidPress \(buttonLabel)")
        
        // TODO: FF and 00
        if buttonLabel == "FF" || buttonLabel == "00" {
            return
        }
        
        let digit = Character("\(buttonLabel)")
        
        // TODO: Separate target action for dot button
        if digit == "." {
            output.dotButtonDidPress()
        } else {
            output.numericButtonDidPress(digit: digit)
        }
    }
    
    @objc func operatorButtonDidPress(_ sender: UIButton) {
        guard sender.accessibilityIdentifier != "=", let operatorString = sender.titleLabel?.text else { return }
        
        print("operatorButtonDidPress")
        output.operatorButtonDidPress(operatorString: operatorString)
    }
    
    @objc func calculateButtonDidPress(_ sender: UIButton) {
        print("calculateButtonDidPress")
        output.calculateButtonDidPress()
    }
    
    @objc func changeConversionButtonDidPress(_ sender: UIButton) {
        print("changeConversionButtonDidPress")
        output.showConversion()
    }
    
    @objc func switchKeypadButtonDidPress(_ sender: UIBarButtonItem) {
        print("switchKeypadButtonDidPress")
        
        let animDuration: CGFloat = 0.3
        let animOptions: UIView.AnimationOptions = [.curveEaseInOut]
        let calcButtonsTransform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        let bitwiseKeypadTransform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)

        calculatorView.freezeNavigationBar(duration: animDuration * 1.5) // also freezes all navbar items

        let isBitwiseKeypadActive = bitwiseKeypad != nil
        
        if isBitwiseKeypadActive {

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
            
            let bits = output.getInputValueBits()
            bitwiseKeypad = BitwiseKeypadController(bits: bits, bitButtonDidPressHandler: { [weak self] bitState, bitIndex in
                self?.output.bitButtonDidPress(bitIsOn: bitState, atIndex: bitIndex)
            })
            
            addChild(bitwiseKeypad!)
            view.addSubview(bitwiseKeypad!.view)

            bitwiseKeypad?.view.transform = bitwiseKeypadTransform
            bitwiseKeypad?.setContainerConstraintsFor(buttonsContainerController.view)

            UIView.animate(withDuration: animDuration, delay: 0, options: animOptions, animations: { [weak self] in
                self?.bitwiseKeypad?.view.transform = .identity
                self?.buttonsContainerController.view?.transform = calcButtonsTransform
            }, completion: { [weak self] _ in
                self?.bitwiseKeypad?.didMove(toParent: self)
            })
        }
    }
    
    @objc func changeWordSizeButtonDidPress(_ sender: UIButton) {
        print("changeWordSizeButtonDidPress")
        output.showWordSize()
    }
    
    @objc func settingsButtonDidPress(_ sender: UIButton) {
        print("settingsButtonDidPress")
        output.showSettings()
    }
    
    @objc func labelSwipeRight(_ sender: UISwipeGestureRecognizer) {
        print("labelSwipeRight")
        output.labelDidSwipeRight()
    }
}
