//
//  BitwiseKeypad.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 15.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import UIKit

class BitwiseKeypad: UIView {
    
    // MARK: - Properties
    
    private let spacing: CGFloat = UIDevice.currentDeviceType == .iPad ? 20 : 10
    private var fontSize: CGFloat {
        let coef: CGFloat = UIDevice.currentDeviceType == .iPad ? 24 : 13.5
        return UIScreen.mainRealSize().width / coef
    }
    private var infoFontSize: CGFloat {
        return fontSize / 3
    }
    private var buttonTag: Int = 63 // buttons or bit tags, buttons created in reverse order from 63 to 0
    private let buttonsContainerMultiplier: CGFloat = UIDevice.currentDeviceType == .iPad ? 0.93 : 0.90
    
    lazy var wordSizeValue: Int = getWordSizeValue()
    lazy var tagOffset: Int = getTagOffset()
    
    // Views
    lazy var container: UIView = UIView()
    lazy var allKeypadStack: UIStackView = getKeypadStack()
    
    weak var controllerDelegate: BitwiseKeypadControllerDelegate?
    
    // Constraints
    var portrait: [NSLayoutConstraint]?
    var landscape: [NSLayoutConstraint]?
    
    // MARK: - Layout
    
    private func setupLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        allKeypadStack.translatesAutoresizingMaskIntoConstraints = false
        
        portrait?.append(contentsOf: [
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            allKeypadStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            allKeypadStack.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -spacing * 2),
            allKeypadStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: buttonsContainerMultiplier, constant: spacing * 3),
            allKeypadStack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.65, constant: spacing * 3)
        ])
        
        landscape?.append(contentsOf: [
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            allKeypadStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            allKeypadStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            allKeypadStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.90),
            allKeypadStack.heightAnchor.constraint(equalTo: container.heightAnchor)
        ])
        
        NSLayoutConstraint.activate(portrait!)
    }
    
    public func setContainerConstraints(_ parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        portrait = [
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ]
        
        landscape = [
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.9),
            self.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -spacing * 2)
        ]
        
        setupLayout()
    }
    
    // MARK: - Methods
 
    private func getWordSizeValue() -> Int {
        return controllerDelegate!.getWordSizeValue()
    }
    
    private func getTagOffset() -> Int {
        return controllerDelegate!.getTagOffset()
    }
    
    public func setViews() {
        container.addSubview(allKeypadStack)
        self.addSubview(container)
        applyStyle()
    }
    
    public func applyStyle() {
        let style = controllerDelegate!.getStyle()
        container.backgroundColor = style.backgroundColor
        // Set colors for buttons - normal and when pressed
        for button in controllerDelegate!.bitButtons {
            button.setTitleColor(style.bitButtonColor, for: .normal)
            button.setTitleColor(style.tintColor, for: .highlighted)
            button.setTitleColor(style.tintColor, for: .selected)
        }
    }

    private func getKeypadStack() -> UIStackView {
        let wordStacks: [UIStackView] = (0..<4).map { _ in
            return getWordStack()
        }
        
        let stack = UIStackView(arrangedSubviews: wordStacks)
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        //stack.spacing = spacing
        
        return stack
    }
    
    // Stack of 16 bit buttons (4 stacks)
    private func getWordStack() -> UIStackView {
        // Prepare stacks with buttons
        let halfByteStacks: [UIStackView] = (0..<4).map { _ in
            return getHalfByteStack()
        }
        
        let stack = UIStackView(arrangedSubviews: halfByteStacks)
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        //stack.spacing = spacing

        return stack
    }
    
    // Stack of 4 bit buttons
    private func getHalfByteStack() -> UIStackView {
        // Prepare buttons for stack
        let buttons: [BitButton] = (0..<4).map { _ in
            return getButton()
        }

        controllerDelegate?.bitButtons.append(contentsOf: buttons)
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        let halfByteStackWidth = (UIScreen.mainRealSize().width - 5 * spacing) / 4
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: halfByteStackWidth),
            stack.heightAnchor.constraint(equalTo: buttons[0].heightAnchor),
        ])
        
        let indexLabel = getInfoLabel()

        stack.addSubview(indexLabel)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indexLabel.widthAnchor.constraint(equalTo: stack.widthAnchor),
            indexLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 0),
            indexLabel.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
        ])
        
        return stack
    }
    
    // Bit button
    private func getButton() -> BitButton {
        let button = BitButton()
        let index = abs(buttonTag - 63)
        let bit = String(controllerDelegate!.binaryCharArray[index])
        // set bitState
        let bitState = bit == "1" ? true : false
        
        button.setBitState(bitState)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        
        button.setTitleColor(.systemOrange, for: .highlighted) // default before applyStyle
        button.setTitleColor(.systemGray.withAlphaComponent(0.7), for: .disabled) // for all styles
        // identifier for UITests
        button.accessibilityIdentifier = "bitButton_\(buttonTag)"
        
        button.addTarget(nil, action: #selector(BitwiseKeypadController.buttonTapped), for: .touchUpInside)
        button.addTarget(nil, action: #selector(CalculatorView.touchHandleLabelHighlight), for: .touchDown)
        
        // tag processing
        button.tag = buttonTag + tagOffset
        
        if buttonTag + 1 > wordSizeValue {
            button.isEnabled = false
        }
        buttonTag -= 1
        
        return button
    }
    
    private func getInfoLabel() -> UILabel {
        // info label for bit index
        let label = UILabel()
        label.text = String(buttonTag + 1)
        label.font = UIFont.systemFont(ofSize: infoFontSize, weight: .light)
        label.textAlignment = .right
        label.sizeToFit()
        label.textColor = .systemGray
        return label
    }
}
