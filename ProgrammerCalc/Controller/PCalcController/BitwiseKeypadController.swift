//
//  BitwiseKeypadController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 13.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import UIKit
import AudioToolbox

protocol BitwiseKeypadControllerDelegate: AnyObject {
    var binary: Binary { get set }
    var binaryValue: [Character] { get set }
    var wordSize: WordSize { get set }
    var tagOffset: Int { get }
    var bitButtons: [UIButton] { get set }
}

class BitwiseKeypadController: UIViewController, BitwiseKeypadControllerDelegate {
    
    // MARK: - Properties
    
    // inputValue
    var binary: Binary
    // inputValue in array for further processing
    lazy var binaryValue: [Character] = getBinaryValueString()
    var wordSize: WordSize = WordSize(64)
    var processSigned: Bool = false
    // tag offset for viewWithTag
    var tagOffset: Int = 300
    
    var bitButtons: [UIButton] = []
    
    // Views
    lazy var bitwiseKeypadView = BitwiseKeypad(frame: CGRect())
    
    // Update inputValue in parent vc and update labels
    var updateHandlder: ((NumberSystemProtocol) -> Void)?
    
    // Storages
    private let settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    private let calcStateStorage: CalcStateStorageProtocol = CalcStateStorage()
    
    // Sound of tapping bool setting
    private var tappingSounds = false
    // haptic feedback setting
    private var hapticFeedback = false
    // Taptic feedback generator
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Initialization
    
    init(binary: Binary) {
        self.binary = binary
        super.init(nibName: nil, bundle: nil)
        self.updateWordSize()
        self.updateProcessSigned()
        self.updateSettings()
        self.bitwiseKeypadView.controllerDelegate = self
        self.bitwiseKeypadView.setViews()
        self.view = bitwiseKeypadView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // get current device orientation
        let isPortrait = UIDevice.current.orientation.isPortrait
        let isLandscape = UIDevice.current.orientation.isLandscape
        
        if isPortrait && !isLandscape {
            NSLayoutConstraint.deactivate(bitwiseKeypadView.landscape!)
            NSLayoutConstraint.activate(bitwiseKeypadView.portrait!)
        } else if isLandscape && !isPortrait {
            NSLayoutConstraint.deactivate(bitwiseKeypadView.portrait!)
            NSLayoutConstraint.activate(bitwiseKeypadView.landscape!)
        }
    }
    
    public func setContainerConstraintsFor(_ parentView: UIView) {
        bitwiseKeypadView.setContainerConstraints(parentView)
    }
    
    private func getBinaryValueString() -> [Character] {
        return [Character](binary.value.removeAllSpaces())
    }
    
    public func updateStyle() {
        bitwiseKeypadView.applyStyle()
    }
    
    private func updateWordSize() {
        let wordSize = wordSizeStorage.safeGetData() as! WordSize
        setWordSize(wordSize)
    }
    
    public func setWordSize(_ size: WordSize) {
        wordSize = size
    }
    
    private func updateProcessSigned() {
        let calcState = calcStateStorage.safeGetData() as! CalcState
        processSigned = calcState.processSigned
    }
    
    private func updateSettings() {
        // get settings from UserDefaults and update settings
        let settings = settingsStorage.safeGetData()
        setTappingSounds(settings.tappingSounds)
        setHapticFeedback(settings.hapticFeedback)
    }
    
    public func setTappingSounds(_ state: Bool) {
        tappingSounds = state
    }
    
    public func setHapticFeedback(_ state: Bool) {
        hapticFeedback = state
    }
    
    private func canChangeSignedBit(for button: UIButton) -> Bool {
        return !(button.tag - tagOffset + 1 == wordSize.value && binary.value.contains(".") && processSigned)
    }
    
    private func updateInputValue() {
        if let updateWith = updateHandlder {
            updateWith(binary)
        }
    }
    
    public func updateKeypadState() {
        var buttonTag = 63
        
        for button in bitButtons {
            if isNextButtonAlreadyProcessed(currentButton: button, tag: buttonTag) {
                break
            }
            if buttonTag < wordSize.value {
                button.isEnabled = true
            } else if buttonTag >= wordSize.value && button.isEnabled {
                button.isEnabled = false
                button.setTitle("0", for: .normal)
            }
            buttonTag -= 1
        }
    }
    
    private func isNextButtonAlreadyProcessed(currentButton button: UIButton, tag: Int) -> Bool {
        return tag + 1 == wordSize.value && button.isEnabled || tag < wordSize.value && button.isEnabled
    }
    
    public func updateKeypadValues() {
        let newBinaryValue = [Character](binary.value)
        let buttonTag = 63
        for i in 0...buttonTag {
            if newBinaryValue[i] != binaryValue[i] && bitButtons[i].isEnabled {
                let bit = newBinaryValue[i]
                bitButtons[i].setTitle(String(bit), for: .normal)
            }
        }
        
        binaryValue = [Character](newBinaryValue)
    }
    
    // MARK: - Actions
    
    @objc func tappingSoundHandler(_ sender: CalculatorButton) {
        if tappingSounds {
            // play KeyPressed
            AudioServicesPlaySystemSound(1104)
        }
    }
    
    // Haptic feedback action for all buttons
    @objc func hapticFeedbackHandler(_ sender: CalculatorButton) {
        if hapticFeedback {
            generator.prepare()
            // impact
            generator.impactOccurred()
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard canChangeSignedBit(for: sender) else  { return }
        
        let bit: Character = sender.titleLabel?.text == "0" ? "1" : "0"
        sender.setTitle(String(bit), for: .normal)
        
        let bitIndex = 63 - sender.tag + tagOffset
        binary.value = binary.value.replaceAt(index: bitIndex, with: bit)
        binaryValue[bitIndex] = bit
        
        updateInputValue()
    }
    
    
    
    
}
