//
//  ButtonsBigViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

// MARK: - iPad

final class ButtonsViewControllerPad: StyledViewController, ButtonsContainerControllerProtocol {
    
    // MARK: - Properties
    
    lazy var buttons: [[CalculatorButton]] = configureButtons()
    lazy var buttonsStackView: UIStackView = configureButtonsStackView(buttons: buttons)

    var layoutConstraints: [NSLayoutConstraint] = []

    private let spacing: CGFloat = CalculatorButton.spacingWidth  // spacing between buttons in horizontal stack
    private let verticalMargin: CGFloat = 20
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buttonsStackView)
        setupLayout()
    }
    
    override func styleWillUpdate(with style: Style) {
        super.styleWillUpdate(with: style)
        
        updateButtonsStyle(style)
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalMargin),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalMargin),
        ])
        
        buttons.flattened().forEach { $0.setConstraints(spacingBetweenButtons: spacing) }
    }
    
    private func configureButtons() -> [[CalculatorButton]] {
        let andButton = OperatorButton(.binary(.and))
        let orButton = OperatorButton(.binary(.or))
        let xorButton = OperatorButton(.binary(.xor))
        let norButton = OperatorButton(.binary(.nor))
        let clearButton = ClearButton()
        let negateButton = NegateButton()
        let signedButton = SignedButton()
        let divButton = OperatorButton(.binary(.div))
        
        let shLByButton = OperatorButton(.binary(.shiftLeftBy))
        let shRByButton = OperatorButton(.binary(.shiftRightBy))
        let shLButton = OperatorButton(.unary(.shiftLeft))
        let shRButton = OperatorButton(.unary(.shiftRight))
        let sevenButton = NumericButton(.single("7"))
        let eightButton = NumericButton(.single("8"))
        let nineButton = NumericButton(.single("9"))
        let mulButton = OperatorButton(.binary(.mul))
        
        let oneS = ComplementButton(.oneS)
        let dButton = NumericButton(.single("D"))
        let eButton = NumericButton(.single("E"))
        let fButton = NumericButton(.single("F"))
        let fourButton = NumericButton(.single("4"))
        let fiveButton = NumericButton(.single("5"))
        let sixButton = NumericButton(.single("6"))
        let subButton = OperatorButton(.binary(.sub))
        
        let twoS = ComplementButton(.twoS)
        let aButton = NumericButton(.single("A"))
        let bButton = NumericButton(.single("B"))
        let cButton = NumericButton(.single("C"))
        let oneButton = NumericButton(.single("1"))
        let twoButton = NumericButton(.single("2"))
        let threeButton = NumericButton(.single("3"))
        let addButton = OperatorButton(.binary(.add))
        
        let doubleZeroButton = NumericButton(.double("0", "0"), size: .double)
        let doubleFButton = NumericButton(.double("F", "F"), size: .double)
        let zeroButton = NumericButton(.single("0"), size: .double)
        let dotButton = DotButton()
        let calculateButton = CalculateButton()
        
        return [
            [andButton, orButton, xorButton, norButton, clearButton, negateButton, signedButton, divButton],
            [shLByButton, shRByButton, shLButton, shRButton, sevenButton, eightButton, nineButton, mulButton],
            [oneS, dButton, eButton, fButton, fourButton, fiveButton, sixButton, subButton],
            [twoS, aButton, bButton, cButton, oneButton, twoButton, threeButton, addButton],
            [doubleZeroButton, doubleFButton, zeroButton, dotButton, calculateButton]
        ]
    }
    
    private func configureButtonsStackView(buttons: [[CalculatorButton]]) -> UIStackView {
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
            button.updateStyle(buttonStyle: buttonStyle)
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
