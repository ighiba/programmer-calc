//
//  ButtonsBigViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

// MARK: - iPad

class ButtonsViewControllerPad: UIViewController, ButtonsContainerControllerProtocol {
    
    // MARK: - Properties
    
    lazy var allButtons: [[CalculatorButton]] = obtainButtons()
    lazy var buttonsStackView: UIStackView = obtainButtonsStackView(buttons: allButtons)

    var layoutConstraints: [NSLayoutConstraint] = []
    private var styleFactory: StyleFactory = StyleFactory()

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
        self.view.addSubview(buttonsStackView)
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateButtonsStyle()
    }
    
    func layoutSubviews() {
        self.view.layoutSubviews()
        updateButtonsStyle()
    }
    
    // MARK: - Methods
    
    private func obtainButtons() -> [[CalculatorButton]] {
        
        let buttonTitles = [["AND",   "OR",  "XOR",  "NOR",  "AC"  ,"±", "Signed\nOFF", "÷"],
                            ["X<<Y", "X>>Y", "<<",   ">>",   "7",   "8",     "9",      "×"],
                            ["1's",   "D",   "E",    "F",    "4",   "5",     "6",      "-"],
                            ["2's",   "A",   "B",    "C",    "1",   "2",     "3",      "+"],
                            ["00",          "FF",            "0",           ".",      "="]]

        let buttons: [[CalculatorButton]] = buttonTitles.map { titlesRow in
            titlesRow.map { title in
                let button: CalculatorButton
                
                switch title {
                case "A","B","C","D","E","F","FF","00","0","1","2","3","4","5","6","7","8","9",".":
                    button = CalculatorButton(calcButtonType: .numeric)
                case "1's", "2's":
                    button = CalculatorButton(calcButtonType: .complement)
                case "X<<Y", "X>>Y", "<<", ">>", "AND", "OR", "XOR", "NOR":
                    button = CalculatorButton(calcButtonType: .bitwise)
                case "AC":
                    button = CalculatorButton()
                    button.tag = tagCalculatorButtonClear
                    button.addTarget(nil, action: #selector(CalculatorView.clearButtonTapped), for: .touchUpInside)
                case "±":
                    button = CalculatorButton()
                    button.tag = tagCalculatorButtonNegate
                    button.addTarget(nil, action: #selector(CalculatorView.negateButtonTapped), for: .touchUpInside)
                case "Signed\nOFF":
                    button = CalculatorButton()
                    button.tag = tagCalculatorButtonIsSigned
                    button.addTarget(nil, action: #selector(CalculatorView.toggleIsSigned), for: .touchUpInside)
                case "=":
                    button = CalculatorButton(calcButtonType: .sign)
                    button.addTarget(nil, action: #selector(CalculatorView.calculateButtonTapped), for: .touchUpInside)
                default:
                    button = CalculatorButton(calcButtonType: .sign)
                }

                button.setActions(for: button.calcButtonType)
                
                // set title and style
                if title == "1's" || title == "2's" {
                    // localization for 1's and 2's
                    let localizedTitle = NSLocalizedString(title, comment: "")
                    button.setTitle(localizedTitle, for: .normal)
                } else {
                    button.setTitle(title, for: .normal)
                }

                button.setTitleColor(.systemGray, for: .disabled)
                button.applyStyle()
                
                // apply font style for AC button
                if title == "AC" {
                    button.titleLabel?.font = button.titleLabel?.font.withSize(button.buttonWidth() / 1.8)
                }
                
                button.accessibilityIdentifier = title
                
                return button
            }
        }
        return buttons
    }
    
    func obtainButtonsStackView(buttons: [[CalculatorButton]]) -> UIStackView {
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
    
    private func setLayout() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95),
            buttonsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: verticalMargin),
            buttonsStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalMargin),
        ])
        
        allButtons.forEachButton { button in
            button.setDefaultConstraints(spacingBetweenButtons: spacing)
        }
    }
    
    private func updateButtonsStyle() {
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        allButtons.forEachButton { $0.updateStyle(style) }
    }
    
    func refreshCalcButtons() {
    }
    
    func updateButtonsIsEnabled(by forbiddenValues: Set<String>) {
        allButtons.forEachButton { button in
            let buttonLabel = button.titleLabel?.text ?? ""
            let shouldBeEnabled = !(forbiddenValues.contains(buttonLabel) && button.calcButtonType == .numeric)
            button.isEnabled = shouldBeEnabled
        }
    }
}

extension [[CalculatorButton]] {
    func forEachButton(_ body: (CalculatorButton) -> Void) {
        self.forEach { row in row.forEach { button in body(button) } }
    }
}
