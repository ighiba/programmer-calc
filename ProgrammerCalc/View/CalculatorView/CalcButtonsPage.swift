//
//  CalcButtonsPage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

protocol CalcButtonPageProtocol: UIView {
    // Array with calcualtor buttons
    var allButtons: [CalculatorButton] { get set }
    // Constraitns for current orientation
    var layoutConstraints: [NSLayoutConstraint]? { get set}
    // Updater method for disabling/enabling numeric buttons depends on covnersion system forbidden values
    func updateButtonIsEnabled(by forbiddenValues: Set<String>)
}

// Parent Class
class CalcButtonsPage: UIView, CalcButtonPageProtocol {

    // Default calculator buttons
    var allButtons: [CalculatorButton] = []
    
    // Layout constraints
    var layoutConstraints: [NSLayoutConstraint]?
    // Style factory
    var styleFactory: StyleFactory = StyleFactory()
    
    // spacing between buttons in horizontal stack
    let spacing: CGFloat = CalculatorButton.spacingWidth
    
    init() {
        super.init(frame: CGRect())
    }
    
    func setViews() {
        // override in child class
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
        
        // Buttons individual constraints
        allButtons.forEach { button in
            button.setDefaultConstraints(spacingBetweenButtons: spacing)
        }
    }
    
    // Vertical main calc buttons stack
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        // Display settings for buttons UIStackView
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        stackView.isExclusiveTouch = true
        
        return stackView
    }()

    // Style for buttons
    func updateStyle(for buttons: [CalculatorButton]) {
        // Apply style by button type
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        
        buttons.forEach { button in
            button.updateStyle(style)
        }
    }
    
    func updateButtonIsEnabled(by forbiddenValues: Set<String>) {
        allButtons.forEach { button in
            let buttonLabel = String((button.titleLabel?.text)!)
            let shouldBeEnabled = !(forbiddenValues.contains(buttonLabel) && button.calcButtonType == .numeric)
            button.isEnabled = shouldBeEnabled
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Main Page

final class CalcButtonsMain: CalcButtonsPage {
    
    override init() {
        super.init()
        
        self.getButtons()
        self.setViews()
        super.setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update style for buttons
        super.updateStyle(for: allButtons)
    }
    
    // MARK: - Methods
    
    override func setViews() {
        // stuff for create buttonStackView
        var buffStackView: UIStackView = UIStackView()
        var counter: Int = 0
        
        for button in allButtons {
            buffStackView.addArrangedSubview(button)
            // fill each stack with 4 buttons (the last one with 3)
            switch counter {
            case 3,7,11,15,18:
                buffStackView.axis = .horizontal
                buffStackView.alignment = .fill
                buffStackView.distribution = .equalSpacing
                buffStackView.isExclusiveTouch = true
                buttonsStackView.addArrangedSubview(buffStackView)

                buffStackView = UIStackView()
                break
            default:
                break
            }
            counter += 1
        }
        
        self.addSubview(buttonsStackView)
    }
    
    // Standart calculator buttons
    private func getButtons() {
        
        let allTitles = ["AC","±","Signed\nOFF","÷",
                         "7", "8", "9", "×",
                         "4", "5", "6", "-",
                         "1", "2", "3", "+",
                         "0", ".", "="]
                    
        var buttons: [CalculatorButton] = []
        
        // Create buttons by looping titles
        for title in allTitles {
            let button: CalculatorButton

            // initialize button by type
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
            // set actions/targets
            button.setActions(for: button.calcButtonType)
            
            // set title and style
            button.setTitle(title, for: .normal)

            button.setTitleColor(.systemGray, for: .disabled)
            button.applyStyle()
            
            // apply font style for AC button
            if title == "AC" {
                button.titleLabel?.font = button.titleLabel?.font.withSize(button.buttonWidth() / 1.8)
            }
            
            button.accessibilityIdentifier = title
            
            // add element to array
            buttons.append(button)
        }

        allButtons = buttons
    }
    
}

// MARK: - Additional page

final class CalcButtonsAdditional: CalcButtonsPage {
    
    override init() {
        super.init()
        
        self.getButtons()
        self.setViews()
        super.setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update style for buttons
        super.updateStyle(for: allButtons)
    }
    
    // MARK: - Methods
    
    override func setViews() {
        // stuff for create buttonStackView
        var buffStackView: UIStackView = UIStackView()
        var counter: Int = 0
        
        for button in allButtons {
            buffStackView.addArrangedSubview(button)
            // fill each stack with 4 buttons (the last one with 3)
            switch counter {
            case 3,7,11,15,17:
                buffStackView.axis = .horizontal
                buffStackView.alignment = .fill
                buffStackView.distribution = .equalSpacing
                buffStackView.isExclusiveTouch = true
                buttonsStackView.addArrangedSubview(buffStackView)
                buffStackView = UIStackView()
                break
            default:
                break
            }
            counter += 1
        }
        
        self.addSubview(buttonsStackView)
    }

    // Standart calculator buttons
    private func getButtons() {
        
        let allTitles = ["AND","OR","XOR","NOR",
                         "X<<Y", "X>>Y", "<<", ">>",
                         "1's", "D", "E", "F",
                         "2's", "A", "B", "C",
                         "00", "FF"]
                    
        var buttons: [CalculatorButton] = []
        
        // Create buttons by looping titles
        for title in allTitles {
            let button: CalculatorButton

            // initialize button by type
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
            
            button.accessibilityIdentifier = title
            
            // add element to array
            buttons.append(button)
        }

        allButtons = buttons
    }
    
}
