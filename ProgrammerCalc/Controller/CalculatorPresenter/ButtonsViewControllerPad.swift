//
//  ButtonsBigViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

// MARK: - iPadOS

class ButtonsViewControllerPad: UIViewController, ButtonsContainerControllerProtocol {
    
    // MARK: - Properties
    
    var allButtons: [CalculatorButton] = []
    var buttonsStackView: UIStackView = UIStackView()

    var layoutConstraints: [NSLayoutConstraint] = []
    private var styleFactory: StyleFactory = StyleFactory()

    private let spacing: CGFloat = CalculatorButton.spacingWidth  // spacing between buttons in horizontal stack
    private let verticalMargin: CGFloat = 20
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let buttons = getButtons()
        self.buttonsStackView = getButtonsStackView(buttons: buttons)
        self.allButtons = buttons.flatMap{ $0.map { $0 } }
        
        self.view.addSubview(buttonsStackView)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func getButtons() -> [[CalculatorButton]] {
        
        let buttonTitles = [["AND","OR","XOR","NOR","AC","±","Signed\nOFF","÷"],
                            ["X<<Y", "X>>Y", "<<", ">>", "7", "8", "9", "×"],
                            ["1's", "D", "E", "F", "4", "5", "6", "-"],
                            ["2's", "A", "B", "C", "1", "2", "3", "+"],
                            ["00", "FF", "0", ".", "="]]

        let buttons: [[CalculatorButton]] = buttonTitles.map { titleRow in
            titleRow.map { title in
                let button: CalculatorButton

                // initialize button by type
                switch title {
                case "A","B","C","D","E","F","00","FF","0"..."9",".":
                    button = CalculatorButton(calcButtonType: .numeric)
                case "1's", "2's":
                    button = CalculatorButton(calcButtonType: .complement)
                case "X<<Y", "X>>Y", "<<", ">>", "AND", "OR", "XOR", "NOR":
                    button = CalculatorButton(calcButtonType: .bitwise)
                case "AC":
                    button = CalculatorButton()
                    button.tag = 100
                    button.addTarget(nil, action: #selector(CalculatorView.clearButtonTapped), for: .touchUpInside)
                case "±":
                    button = CalculatorButton()
                    button.tag = 101
                    button.addTarget(nil, action: #selector(CalculatorView.negateButtonTapped), for: .touchUpInside)
                case "Signed\nOFF":
                    button = CalculatorButton()
                    button.tag = 102
                    button.addTarget(nil, action: #selector(CalculatorView.toggleIsSigned), for: .touchUpInside)
                case "=":
                    button = CalculatorButton(calcButtonType: .sign)
                    button.addTarget(nil, action: #selector(CalculatorView.calculateButtonTapped), for: .touchUpInside)
                default:
                    button = CalculatorButton(calcButtonType: .sign)
                }

                // set actions/targets
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
    
    func getButtonsStackView(buttons: [[CalculatorButton]]) -> UIStackView {
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
        
        // Buttons constraints
        for button in allButtons {
            button.setDefaultConstraints(spacingBetweenButtons: spacing)
        }
    }
    
    private func updateButtonsStyle() {
        // Apply style by button type
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        allButtons.forEach { button in
            button.updateStyle(style)
        }
    }
    
    func refreshCalcButtons() {
        //
    }
    
    func updateButtonsIsEnabled(by forbiddenValues: Set<String>) {
        allButtons.forEach { button in
            let buttonLabel = String((button.titleLabel?.text)!)
            if forbiddenValues.contains(buttonLabel) && button.calcButtonType == .numeric {
                button.isEnabled = false
            } else {
                button.isEnabled = true
            }
        }
    }
}
