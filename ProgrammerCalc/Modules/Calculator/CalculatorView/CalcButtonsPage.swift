//
//  CalcButtonsPage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

protocol CalcButtonPageProtocol {
    // 2D Array with calcualtor buttons
    var buttons: [[CalculatorButton]] { get set }
    // Constraitns for current orientation
    var layoutConstraints: [NSLayoutConstraint]? { get set}
    // Updater method for disabling/enabling numeric buttons depends on covnersion system forbidden values
    func disableNumericButtons(withForbiddenDigits forbiddenDigits: Set<String>)
}

// Prototype Class
class CalcButtonsPage: StyledView, CalcButtonPageProtocol {
    
    // MARK: - Properties

    lazy var buttons: [[CalculatorButton]] = configureButtons()
    lazy var buttonsStackView: UIStackView = configureButtonsStackView(buttons: buttons)
    
    var layoutConstraints: [NSLayoutConstraint]?
    
    private let buttonsHorizontalSpacing: CGFloat = CalculatorButton.spacingWidth
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect())
        self.addSubview(buttonsStackView)
        self.setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func styleWillUpdate(with style: Style) {
        super.styleWillUpdate(with: style)
        
        updateButtonsStyle(style)
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstraints = [
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3.5), // -3.5 for shadows
        ]
        NSLayoutConstraint.activate(layoutConstraints!)
        
        buttons.flattened().forEach { $0.setConstraints(spacingBetweenButtons: buttonsHorizontalSpacing) }
    }
    
    fileprivate func configureButtons() -> [[CalculatorButton]] {
        return [] // should be implemented in child classes
    }
    
    private func configureButtonsStackView(buttons: [[CalculatorButton]]) -> UIStackView {
        guard !buttons.isEmpty else { return UIStackView() }
        let buttonsStackRows = buttons.map { buttonsRow in
            let buttonsRowStack = UIStackView(arrangedSubviews: buttonsRow)
            buttonsRowStack.axis = .horizontal
            buttonsRowStack.alignment = .fill
            buttonsRowStack.distribution = .equalSpacing
            buttonsRowStack.isExclusiveTouch = true
            return buttonsRowStack
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: buttonsStackRows)
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .equalSpacing
        buttonStackView.isExclusiveTouch = true
        
        return buttonStackView
    }

    private func updateButtonsStyle(_ style: Style) {
        buttons.flattened().forEach { button in
            let buttonStyle = style.buttonStyle(for: button.buttonStyleType)
            button.updateStyle(buttonStyle: buttonStyle, borderColor: style.buttonBorderColor)
        }
    }
    
    func disableNumericButtons(withForbiddenDigits forbiddenDigits: Set<String>) {
        buttons.flattened().forEach { button in
            if button is NumericButton {
                let buttonLabel = button.titleLabel?.text ?? ""
                let shouldBeEnabled = !forbiddenDigits.contains(buttonLabel)
                button.isEnabled = shouldBeEnabled
            }
        }
    }
}

// MARK: - Main Page

final class CalcButtonsMain: CalcButtonsPage {
    
    fileprivate override func configureButtons() -> [[CalculatorButton]] {
        let clearButton = ClearButton()
        let negateButton = NegateButton()
        let signedButton = SignedButton()
        let divButton = OperatorButton(.binary(.div))
        
        let sevenButton = NumericButton(.single("7"))
        let eightButton = NumericButton(.single("8"))
        let nineButton = NumericButton(.single("9"))
        let mulButton = OperatorButton(.binary(.mul))
        
        let fourButton = NumericButton(.single("4"))
        let fiveButton = NumericButton(.single("5"))
        let sixButton = NumericButton(.single("6"))
        let subButton = OperatorButton(.binary(.sub))
        
        let oneButton = NumericButton(.single("1"))
        let twoButton = NumericButton(.single("2"))
        let threeButton = NumericButton(.single("3"))
        let addButton = OperatorButton(.binary(.add))
        
        let zeroButton = NumericButton(.single("0"), size: .double)
        let dotButton = DotButton()
        let calculateButton = CalculateButton()
        
        return [
            [clearButton, negateButton, signedButton, divButton],
            [sevenButton, eightButton, nineButton, mulButton],
            [fourButton, fiveButton, sixButton, subButton],
            [oneButton, twoButton, threeButton, addButton],
            [zeroButton, dotButton, calculateButton]
        ]
    }
}

// MARK: - Additional page

final class CalcButtonsAdditional: CalcButtonsPage {
    
    fileprivate override func configureButtons() -> [[CalculatorButton]] {
        let andButton = OperatorButton(.binary(.and))
        let orButton = OperatorButton(.binary(.or))
        let xorButton = OperatorButton(.binary(.xor))
        let norButton = OperatorButton(.binary(.nor))
        
        let shLByButton = OperatorButton(.binary(.shiftLeftBy))
        let shRByButton = OperatorButton(.binary(.shiftRightBy))
        let shLButton = OperatorButton(.unary(.shiftLeft))
        let shRButton = OperatorButton(.unary(.shiftRight))
        
        let oneS = ComplementButton(.oneS)
        let dButton = NumericButton(.single("D"))
        let eButton = NumericButton(.single("E"))
        let fButton = NumericButton(.single("F"))
        
        let twoS = ComplementButton(.twoS)
        let aButton = NumericButton(.single("A"))
        let bButton = NumericButton(.single("B"))
        let cButton = NumericButton(.single("C"))
        
        let doubleZeroButton = NumericButton(.double("0", "0"), size: .double)
        let doubleFButton = NumericButton(.double("F", "F"), size: .double)
        
        return [
            [andButton, orButton, xorButton, norButton],
            [shLByButton, shRByButton, shLButton, shRButton],
            [oneS, dButton, eButton, fButton],
            [twoS, aButton, bButton, cButton],
            [doubleZeroButton, doubleFButton]
        ]
    }
}
