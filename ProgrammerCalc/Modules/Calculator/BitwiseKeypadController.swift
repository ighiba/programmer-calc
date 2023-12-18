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
    var wordSizeValue: Int { get }
    var currentStyle: Style { get }
    func bit(atIndex bitIndex: Int) -> Bit
}

final class BitwiseKeypadController: UIViewController, BitwiseKeypadControllerDelegate {
    
    // MARK: - Properties
    
    var wordSizeValue: Int { wordSize.intValue }
    var currentStyle: Style { getCurrentStyle() }
    
    private var bits: [Bit]
    
    private let bitwiseKeypadView: BitwiseKeypad
    private var bitButtons: [BitButton] { bitwiseKeypadView.bitButtons }
    
    private let styleFactory: StyleFactory = StyleFactory()
    
    private let calculatorState: CalculatorState = CalculatorState.shared
    private let wordSize: WordSize = WordSize.shared
    
    private let settings = Settings.shared
    private let hapticFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private let bitButtonDidPressHandler: (_ bitIsOn: Bool, _ bitIndex: UInt8) -> Void
    
    // MARK: - Initialization
    
    init(bits: [Bit], bitButtonDidPressHandler: @escaping (Bool, UInt8) -> Void) {
        self.bits = bits.adjusted(toCount: 64, repeatingElement: 0)
        self.bitButtonDidPressHandler = bitButtonDidPressHandler
        self.bitwiseKeypadView = BitwiseKeypad()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        bitwiseKeypadView.configureView(controllerDelegate: self)
        view = bitwiseKeypadView
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isPortrait = UIDevice.current.orientation.isPortrait
        let isLandscape = UIDevice.current.orientation.isLandscape
        
        guard let landscape = bitwiseKeypadView.landscape, let portrait = bitwiseKeypadView.portrait else { return }
        
        if isPortrait && !isLandscape {
            NSLayoutConstraint.deactivate(landscape)
            NSLayoutConstraint.activate(portrait)
        } else if isLandscape && !isPortrait {
            NSLayoutConstraint.deactivate(portrait)
            NSLayoutConstraint.activate(landscape)
        }
    }
    
    // MARK: - Methods
    
    func setContainerConstraintsFor(_ parentView: UIView) {
        bitwiseKeypadView.setContainerConstraints(parentView)
    }

    func updateStyle(_ style: Style) {
        bitwiseKeypadView.applyStyle(style)
    }

    private func getCurrentStyle() -> Style {
        let theme = StyleSettings.shared.theme
        return styleFactory.get(theme: theme)
    }
    
    func bit(atIndex bitIndex: Int) -> Bit {
        guard bitIndex >= 0 && bitIndex < bits.count else { return 0 }
        
        return bits[bitIndex]
    }
    
    func update(withBits bits: [Bit]) {
        let bitWidth = bitButtons.count
        self.bits = bits.adjusted(toCount: bitWidth, repeatingElement: 0)
        
        for (index, bitButton) in bitButtons.enumerated().reversed() {
            if index < wordSize.intValue && bitButton.isEnabled {
                break
            }

            if index < wordSize.intValue {
                bitButton.isEnabled = true
            } else if index >= wordSize.intValue && bitButton.isEnabled {
                bitButton.isEnabled = false
            }
        }
        
        for (index, bit) in bits.enumerated() {
            if index >= wordSize.intValue {
                break
            }

            let bitState: BitButton.State = bit == 1 ? .on : .off
            bitButtons[index].bitState = bitState
        }
    }
    
    private func playTappingSound() {
        if settings.isTappingSoundsEnabled {
            AudioServicesPlaySystemSound(1104)
        }
    }
    
    private func hapticFeedbackImpact() {
        if settings.isHapticFeedbackEnabled {
            hapticFeedbackGenerator.prepare()
            hapticFeedbackGenerator.impactOccurred()
        }
    }
    
    // MARK: - Actions
    
    @objc func bitButtonDidPress(_ bitButton: BitButton) {
        playTappingSound()
        hapticFeedbackImpact()
        
        let bitState = !bitButton.bitState.boolValue
        bitButton.toggleState()
        
        let bitIndex = UInt8(bitButton.bitIndex)

        bitButtonDidPressHandler(bitState, bitIndex)
    }
}
