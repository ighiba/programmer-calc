//
//  BitwiseKeypad.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 15.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import UIKit

final class BitwiseKeypad: UIView {
    
    // MARK: - Properties
    
    weak var controllerDelegate: BitwiseKeypadControllerDelegate!
    
    private let spacing: CGFloat = UIDevice.current.deviceType == .iPad ? 20 : 10
    private var fontSize: CGFloat { calculateFontSize(forDeviceType: UIDevice.current.deviceType) }
    private var bitIndexFontSize: CGFloat { fontSize / 3 }
    
    private let keypadPortraitWidthMultiplier: CGFloat = UIDevice.current.deviceType == .iPad ? 0.93 : 0.9
    private let keypadLandscapeWidthMultiplier: CGFloat = 0.9
    
    private var keypadStack: UIStackView!
    private(set) var bitButtons: [BitButton] = []

    private(set) var portrait: [NSLayoutConstraint]?
    private(set) var landscape: [NSLayoutConstraint]?
    
    // MARK: - Layout
    
    func configureView(controllerDelegate delegate: BitwiseKeypadControllerDelegate) {
        controllerDelegate = delegate
        keypadStack = configureKeypadStack()
        
        addSubview(keypadStack)
        applyStyle(controllerDelegate.currentStyle)
    }
    
    func applyStyle(_ style: Style) {
        backgroundColor = style.backgroundColor
        
        for button in bitButtons {
            button.setTitleColor(style.bitButtonColor, for: .normal)
            button.setTitleColor(style.tintColor, for: .highlighted)
            button.setTitleColor(style.tintColor, for: .selected)
        }
    }
    
    func setContainerConstraints(_ parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        keypadStack.translatesAutoresizingMaskIntoConstraints = false
        
        portrait = [
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            
            keypadStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            keypadStack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -spacing * 2),
            keypadStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: keypadPortraitWidthMultiplier, constant: spacing * 3),
            keypadStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65, constant: spacing * 3)
        ]
        
        landscape = [
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: keypadLandscapeWidthMultiplier),
            self.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -spacing * 2),
            
            keypadStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            keypadStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            keypadStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: keypadLandscapeWidthMultiplier),
            keypadStack.heightAnchor.constraint(equalTo: self.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(portrait!)
    }
    
    // MARK: - Methods
    
    private func calculateFontSize(forDeviceType deviceType: DeviceType) -> CGFloat {
        let widthCoef: CGFloat = deviceType == .iPad ? 24 : 13.5
        return UIScreen.mainRealSize().width / widthCoef
    }
    
    private func configureKeypadStack() -> UIStackView {
        let wordStacks: [UIStackView] = (0..<4).map { wordRow in
            return configureWordStack(wordRow: wordRow)
        }
        
        let stack = UIStackView(arrangedSubviews: wordStacks.reversed())
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        
        return stack
    }
    
    private func configureWordStack(wordRow: Int) -> UIStackView {
        let halfByteStacks: [UIStackView] = (0..<4).map { i in
            let halfByteStackIndex = i + (wordRow * 4)
            return configureHalfByteStack(halfByteStackIndex: halfByteStackIndex)
        }
        
        let stack = UIStackView(arrangedSubviews: halfByteStacks.reversed())
        stack.axis = .horizontal
        stack.distribution = .equalSpacing

        return stack
    }
    
    private func configureHalfByteStack(halfByteStackIndex: Int) -> UIStackView {
        let buttons: [BitButton] = (0..<4).map { i in
            let bitIndex = i + (halfByteStackIndex * 4)
            return configureBitButton(bitIndex: bitIndex)
        }
        
        bitButtons.append(contentsOf: buttons)
        
        let stack = UIStackView(arrangedSubviews: buttons.reversed())
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        let halfByteStackWidth = (UIScreen.mainRealSize().width - 5 * spacing) / 4
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: halfByteStackWidth),
            stack.heightAnchor.constraint(equalTo: buttons[0].heightAnchor),
        ])
        
        let index = halfByteStackIndex * 4 - 1
        let indexLabel = configureBitIndexLabel(index: index)

        stack.addSubview(indexLabel)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indexLabel.widthAnchor.constraint(equalTo: stack.widthAnchor),
            indexLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 0),
            indexLabel.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
        ])
        
        return stack
    }
    
    private func configureBitButton(bitIndex: Int) -> BitButton {
        let bit = controllerDelegate.bit(atIndex: bitIndex)
        let bitButton = BitButton(bitIndex: bitIndex)
        let bitState: BitButton.State = bit == 1 ? .on : .off
        
        bitButton.bitState = bitState
        bitButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        
        bitButton.setTitleColor(.systemOrange, for: .highlighted)
        bitButton.setTitleColor(.systemGray.withAlphaComponent(0.7), for: .disabled)

        bitButton.accessibilityIdentifier = "bitButton_\(bitIndex)" // identifier for UITests
        
        bitButton.addTarget(nil, action: #selector(BitwiseKeypadController.bitButtonDidPress), for: .touchUpInside)
        
        if bitIndex > controllerDelegate.wordSizeValue - 1 {
            bitButton.isEnabled = false
        }
        
        return bitButton
    }
    
    private func configureBitIndexLabel(index: Int) -> UILabel {
        let label = UILabel()
        
        label.text = String(index + 1)
        label.font = .systemFont(ofSize: bitIndexFontSize, weight: .light)
        label.textAlignment = .right
        label.textColor = .systemGray
        label.sizeToFit()
        
        return label
    }
}
