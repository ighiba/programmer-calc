//
//  CalcButtonsPage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

protocol CalcButtonPageProtocol: UIView {
    // 2D Array with calcualtor buttons
    var allButtons: [[CalculatorButton]] { get set }
    // Constraitns for current orientation
    var layoutConstraints: [NSLayoutConstraint]? { get set}
    // Updater method for disabling/enabling numeric buttons depends on covnersion system forbidden values
    func updateButtonIsEnabled(by forbiddenValues: Set<String>)
}

// Prototype Class
class CalcButtonsPage: UIView, CalcButtonPageProtocol {
    
    // MARK: - Properties

    lazy var allButtons: [[CalculatorButton]] = obtainButtons()
    lazy var buttonsStackView: UIStackView = obtainButtonsStackView(buttons: allButtons)
    
    var layoutConstraints: [NSLayoutConstraint]?
    
    private let styleFactory: StyleFactory = StyleFactory()
    
    private let buttonsHorizontalSpacing: CGFloat = CalculatorButton.spacingWidth
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect())
        setViews()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateButtonsStyle()
    }
    
    fileprivate func setViews() {
        self.addSubview(buttonsStackView)
    }
    
    fileprivate func setLayout() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints = [
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.90),
            buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3.5), // -3.5 for shadows
        ]
        NSLayoutConstraint.activate(layoutConstraints!)
        
        allButtons.forEachButton { button in
            button.setDefaultConstraints(spacingBetweenButtons: buttonsHorizontalSpacing)
        }
    }
    
    fileprivate func obtainButtons() -> [[CalculatorButton]] {
        return [] // should be implemented in child classes
    }
    
    private func obtainButtonsStackView(buttons: [[CalculatorButton]]) -> UIStackView {
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

    fileprivate func updateButtonsStyle() {
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        allButtons.forEachButton { $0.updateStyle(style) }
    }
    
    func updateButtonIsEnabled(by forbiddenValues: Set<String>) {
        allButtons.forEachButton { button in
            let buttonLabel = button.titleLabel?.text ?? ""
            let shouldBeEnabled = !(forbiddenValues.contains(buttonLabel) && button.calcButtonType == .numeric)
            button.isEnabled = shouldBeEnabled
        }
    }
}

// MARK: - Main Page

final class CalcButtonsMain: CalcButtonsPage {

    fileprivate override func obtainButtons() -> [[CalculatorButton]] {
        
        let buttonTitles = [["AC",  "±", "Signed\nOFF",  "÷"],
                            ["7",   "8",     "9",       "×"],
                            ["4",   "5",     "6",       "-"],
                            ["1",   "2",     "3",       "+"],
                            ["0",            ".",       "="]]
                    
        let buttons: [[CalculatorButton]] = buttonTitles.map { titlesRow in
            titlesRow.map { title in
                let button: CalculatorButton
                
                switch title {
                case "0"..."9",".":
                    button = CalculatorButton(calcButtonType: .numeric)
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
                
                button.setTitle(title, for: .normal)
                
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
}

// MARK: - Additional page

final class CalcButtonsAdditional: CalcButtonsPage {

    fileprivate override func obtainButtons() -> [[CalculatorButton]] {
        
        let buttonTitles = [["AND",  "OR",  "XOR", "NOR"],
                           ["X<<Y", "X>>Y",  "<<",  ">>"],
                           ["1's",   "D",    "E",    "F"],
                           ["2's",   "A",    "B",    "C"],
                           ["00",            "FF"      ]]
                    
        let buttons: [[CalculatorButton]] = buttonTitles.map { titlesRow in
            titlesRow.map { title in
                let button: CalculatorButton
                
                switch title {
                case "A","B","C","D","E","F","00","FF":
                    button = CalculatorButton(calcButtonType: .numeric)
                case "1's", "2's":
                    button = CalculatorButton(calcButtonType: .complement)
                case "X<<Y", "X>>Y", "<<", ">>", "AND", "OR", "XOR", "NOR":
                    button = CalculatorButton(calcButtonType: .bitwise)
                default:
                    button = CalculatorButton(calcButtonType: .numeric)
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
                
                button.accessibilityIdentifier = title

                return button
            }
        }
        return buttons
    }
}
