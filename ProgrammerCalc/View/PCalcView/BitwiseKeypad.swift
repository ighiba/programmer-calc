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
    
    private let spacing: CGFloat = 10
    private let fontSize: CGFloat = UIScreen.main.bounds.width / 13.5
    private var buttonTag: Int = 63 // buttons or bit tags, buttons created in reverse order from 63 to 0
    
    lazy var wordSize: WordSize = getWordSize()
    lazy var tagOffset: Int = getTagOffset()
    
    // Views
    lazy var container: UIView = UIView()
    lazy var allKeypadStack: UIStackView = getKeypadStack()
    
    private let styleStorage: StyleStorageProtocol = StyleStorage()
    private let styleFactory: StyleFactory = StyleFactory()
    
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
            allKeypadStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.90, constant: spacing * 3),
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
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: (getContainerHeight() / 2 + 2) * 1.089 - 2),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ]
        
        landscape = [
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            self.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.6),
            self.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -spacing * 2)
        ]
        
        setupLayout()
    }
    
    // MARK: - Methods
 
    private func getWordSize() -> WordSize {
        return controllerDelegate!.wordSize
    }
    
    private func getTagOffset() -> Int {
        return controllerDelegate!.tagOffset
    }
    
    public func setViews() {
        container.addSubview(allKeypadStack)
        self.addSubview(container)
        applyStyle()
    }
    
    public func applyStyle() {
        let styleName = styleStorage.safeGetStyleData()
        let style = styleFactory.get(style: styleName)
        container.backgroundColor = style.backgroundColor
        // Set colors for buttons - normal and when pressed
        for button in controllerDelegate!.bitButtons {
            button.setTitleColor(style.bitButtonColor, for: .normal)
            button.setTitleColor(style.tintColor, for: .highlighted)
        }
    }
    
    // Container height in default(portrait) orientation
    private func getContainerHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight > screenWidth ? screenHeight : screenWidth
        return (height / 3) * 2
    }

    private func getKeypadStack() -> UIStackView {
        let wordStacks: [UIStackView] = (0..<4).map { _ in
            return getWordStack()
        }
        
        let stack = UIStackView(arrangedSubviews: wordStacks)
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = spacing
        
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
        stack.distribution = .fillProportionally
        stack.spacing = spacing

        return stack
    }
    
    // Stack of 4 bit buttons
    private func getHalfByteStack() -> UIStackView {
        // Prepare buttons for stack
        let buttons: [UIButton] = (0..<4).map { _ in
            return getButton()
        }
        controllerDelegate?.bitButtons.append(contentsOf: buttons)
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
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
    private func getButton() -> UIButton {
        let button = UIButton()
        let index = abs(buttonTag - 63)
        let bit = controllerDelegate!.binaryValue[index]
        // title settings
        button.setTitle(String(bit), for: .normal)
        button.setTitle("0", for: .disabled)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        
        button.setTitleColor(.systemOrange, for: .highlighted) // default before applyStyle
        button.setTitleColor(.systemGray.withAlphaComponent(0.7), for: .disabled) // for all styles

        button.addTarget(nil, action: #selector(BitwiseKeypadController.buttonTapped), for: .touchUpInside)
        button.addTarget(nil, action: #selector(BitwiseKeypadController.hapticFeedbackHandler), for: .touchUpInside)
        button.addTarget(nil, action: #selector(BitwiseKeypadController.tappingSoundHandler), for: .touchUpInside)
        
        // identifier for UITests
        button.accessibilityIdentifier = "bitButton_\(buttonTag)"
        
        // tag processing
        button.tag = buttonTag + tagOffset
        
        if buttonTag + 1 > wordSize.value {
            button.isEnabled = false
        }
        buttonTag -= 1
        
        return button
    }
    
    private func getInfoLabel() -> UILabel {
        // info label for bit index
        let label = UILabel()
        label.text = String(buttonTag + 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }
}
