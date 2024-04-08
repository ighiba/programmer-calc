//
//  CalculatorViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit
import AudioToolbox

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
    func changeClearButtonTitle(inputState: ClearButton.State)
    func changeSignedButtonTitle(signedState: SignedButton.State)
    func setNegateButton(isEnabled: Bool)
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

    private var buttonsContainerController: ButtonsContainerControllerProtocol!
    private var bitwiseKeypad: BitwiseKeypadController?
    
    private var isAllowedLandscape: Bool = false
    
    private let settings = Settings.shared
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    private let deviceType: DeviceType
    
    // MARK: - Init
    
    init(deviceType: DeviceType) {
        self.deviceType = deviceType
        super.init(nibName: nil, bundle: nil)
        self.buttonsContainerController = self.configureButtonsContainerController(forDeviceType: deviceType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func loadView() {
        view = calculatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGestures()
        
        output.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if deviceType == .iPad {
            AppDelegate.AppUtility.lockPortraitOrientation()
        } else {
            AppDelegate.AppUtility.unlockPortraitOrientation()
        }

        if #available(iOS 16.0, *) {
            setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        
        isAllowedLandscape = true
        buttonsContainerController.view.setNeedsLayout()
        buttonsContainerController.view.layoutIfNeeded()
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
            
            phoneVC.setPageControl(isHidden: false)
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
            
            phoneVC.setPageControl(isHidden: true)
            calculatorView.frame = UIScreen.main.bounds
        }
    }
    
    func subviewsSetNeedsLayout() {
        view.setNeedsLayout()
        calculatorView.setNeedsLayout()
        buttonsContainerController.view.setNeedsLayout()
    }
    
    // MARK: - Methods
    
    private func configureButtonsContainerController(forDeviceType deviceType: DeviceType) -> ButtonsContainerControllerProtocol {
        switch deviceType {
        case .iPhone:
            return ButtonsViewControllerPhone()
        case .iPad:
            return ButtonsViewControllerPad()
        }
    }
    
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
    
    func changeClearButtonTitle(inputState: ClearButton.State) {
        let clearButton = view.viewWithTag(clearButtonTag) as? ClearButton
        clearButton?.changeButtonTitle(inputState)
    }
    
    func changeSignedButtonTitle(signedState: SignedButton.State) {
        let signedButton = view.viewWithTag(signedButtonTag) as? SignedButton
        signedButton?.changeButtonTitle(signedState)
    }
    
    func setNegateButton(isEnabled: Bool) {
        let negateButton = view.viewWithTag(negateButtonTag) as? NegateButton
        negateButton?.isEnabled = isEnabled
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
    
    @objc func labelSwipeRight(_ sender: UISwipeGestureRecognizer) {
        print("labelSwipeRight")
        output.labelDidSwipeRight()
    }

    @objc func clearButtonDidPress(_ sender: ClearButton) {
        print("clearButtonDidPress")
        output.clearButtonDidPress()
    }
    
    @objc func negateButtonDidPress(_ sender: NegateButton) {
        print("negateButtonDidPress")
        output.negateButtonDidPress()
    }
    
    @objc func signedButtonDidPress(_ sender: SignedButton) {
        print("signedButtonDidPress")
        output.signedButtonDidPress()
    }
    
    @objc func numericButtonDidPress(_ sender: NumericButton) {
        print("numericButtonDidPress \(sender.digit)")
        output.numericButtonDidPress(digit: sender.digit)
    }
    
    @objc func dotButtonDidPress(_ sender: ComplementButton) {
        print("dotButtonDidPress")
        output.dotButtonDidPress()
    }
    
    @objc func operatorButtonDidPress(_ sender: OperatorButton) {
        print("operatorButtonDidPress")
        output.operatorButtonDidPress(operatorType: sender.operatorType)
    }
    
    @objc func calculateButtonDidPress(_ sender: CalculateButton) {
        print("calculateButtonDidPress")
        output.calculateButtonDidPress()
    }
    
    @objc func complementButtonDidPress(_ sender: ComplementButton) {
        print("complementButtonDidPress")
        output.complementButtonDidPress(complementOperator: sender.operatorType)
    }
    
    @objc func changeConversionButtonDidPress(_ sender: UIButton) {
        print("changeConversionButtonDidPress")
        output.showConversion()
    }
    
    @objc func changeWordSizeButtonDidPress(_ sender: UIButton) {
        print("changeWordSizeButtonDidPress")
        output.showWordSize()
    }
    
    @objc func settingsButtonDidPress(_ sender: UIButton) {
        print("settingsButtonDidPress")
        output.showSettings()
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
    
    @objc func tappingSoundHandler(_ sender: CalculatorButton) {
        if settings.isTappingSoundsEnabled {
            AudioServicesPlaySystemSound(1104)
        }
    }
    
    @objc func hapticFeedbackHandler(_ sender: CalculatorButton) {
        if settings.isHapticFeedbackEnabled {
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
