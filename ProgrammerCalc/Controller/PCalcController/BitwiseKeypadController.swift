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
    var binaryValue: [Character] { get }
    var bitButtons: [UIButton] { get set }
    func getTagOffset() -> Int
    func getWordSizeValue() -> Int
    func getStyle() -> Style
}

class BitwiseKeypadController: UIViewController, BitwiseKeypadControllerDelegate {
    
    // MARK: - Properties
    
    // inputValue
    var binary: Binary
    // inputValue in array for further processing
    lazy var binaryValue: [Character] = getBinaryValueString()
    // tag offset for viewWithTag
    var tagOffset: Int = 300

    var bitButtons: [UIButton] = []
    
    // Views
    lazy var bitwiseKeypadView = BitwiseKeypad(frame: CGRect())
    
    // Update inputValue in parent vc and update labels
    var updateHandlder: ((NumberSystemProtocol) -> Void)?
    
    // Storages
    private let styleStorage: StyleStorageProtocol = StyleStorage()
    
    private let styleFactory: StyleFactory = StyleFactory()
    
    
    private let calcState: CalcState = CalcState.shared
    private let wordSize: WordSize = WordSize.shared
    
    // Sound of tapping bool setting
    // and
    // Haptic feedback setting
    let settings = Settings.shared
    // Taptic feedback generator
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Initialization
    
    init(binary: Binary) {
        self.binary = binary
        super.init(nibName: nil, bundle: nil)
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
    
    func getStyle() -> Style {
        let styleName = styleStorage.safeGetStyleData()
        let style = styleFactory.get(style: styleName)
        return style
    }
    
    func getWordSizeValue() -> Int {
        return wordSize.value
    }
    
    func getTagOffset() -> Int {
        return tagOffset
    }
    
    private func updateInputValue() {
        if let updateWith = updateHandlder {
            updateWith(binary)
        }
    }
    
    public func updateKeypad() {
        updateKeypadState()
        updateKeypadValues()
    }
    
    private func updateKeypadState() {
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
    
    private func updateKeypadValues() {
        let newBinaryValue = [Character](binary.value)
        let buttonTag = 63

        for i in 0...buttonTag where bitButtons[i].isEnabled {
            let bit = newBinaryValue[i]
            bitButtons[i].setTitle(String(bit), for: .normal)
        }
        
        binaryValue = [Character](newBinaryValue)
    }
    
    private func canChangeSignedBit(for button: UIButton) -> Bool {
        return !(button.tag - tagOffset + 1 == wordSize.value && binary.value.contains(".") && calcState.processSigned)
    }
    
    // MARK: - Actions
    
    @objc func tappingSoundHandler(_ sender: CalculatorButton) {
        if settings.tappingSounds {
            // play KeyPressed
            AudioServicesPlaySystemSound(1104)
        }
    }
    
    // Haptic feedback action for all buttons
    @objc func hapticFeedbackHandler(_ sender: CalculatorButton) {
        if settings.hapticFeedback {
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
