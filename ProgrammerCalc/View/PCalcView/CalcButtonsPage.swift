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
        
        // Activate constraints
        layoutConstraints = [
            // Constraints for buttons (Main)
            // width
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.90),
            // centering
            buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // top anchor
            buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: (buttonsStackHeight() / 2 + 2) * 1.089),
            // bottom anchor === spacing -3.5 for shadows
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3.5),
        ]
        NSLayoutConstraint.activate(layoutConstraints!)
        
        
        // Buttons constraints
        for button in allButtons {
            let title = button.titleLabel?.text // shorter name
            // set width and height by constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.portrait = []
            button.portrait?.append( button.heightAnchor.constraint(equalToConstant: button.buttonWidth()) )
            // special style for double button
            if title == "00" || title == "FF" || title == "0" {
                button.portrait?.append( button.widthAnchor.constraint(equalToConstant: button.buttonWidth() * 2 + spacing) )
                button.titleLabel?.font = button.titleLabel?.font.withSize(button.defaultFontSize) // default
            } else {
                // width for default
                button.portrait?.append( button.widthAnchor.constraint(equalToConstant: button.buttonWidth()) )
            }
            // change priority for all constraints to 999 (for disable log noise when device is rotated)
            button.portrait!.forEach { $0.priority = UILayoutPriority(999) }
            // activate portrait constraint
            NSLayoutConstraint.activate(button.portrait!)
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
    
    // Standart calculator buttons
    var allButtons: [CalculatorButton] = []
    
    // Style for buttons
    func updateStyle(for buttons: [CalculatorButton]) {
        
        // Apply style by button type
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        
        // set background color and text color
        for button in buttons {
            switch button.calcButtonType {
            case .numeric:
                button.backgroundColor = style.numericButtonStyle.frameColor
                button.frameTint = style.numericButtonStyle.frameTint
                button.setTitleColor(style.numericButtonStyle.textColor, for: .normal)
                button.setTitleColor(style.numericButtonStyle.textTint, for: .highlighted)

            case .sign:
                button.backgroundColor = style.actionButtonStyle.frameColor
                button.frameTint = style.actionButtonStyle.frameTint
                button.setTitleColor(style.actionButtonStyle.textColor, for: .normal)
                button.setTitleColor(style.actionButtonStyle.textTint, for: .highlighted)

            case .complement:
                button.backgroundColor = style.miscButtonStyle.frameColor
                button.frameTint = style.miscButtonStyle.frameTint
                button.setTitleColor(style.miscButtonStyle.textColor, for: .normal)
                button.setTitleColor(style.miscButtonStyle.textTint, for: .highlighted)

            case .bitwise:
                button.backgroundColor = style.actionButtonStyle.frameColor
                button.frameTint = style.actionButtonStyle.frameTint
                button.setTitleColor(style.actionButtonStyle.textColor, for: .normal)
                button.setTitleColor(style.actionButtonStyle.textTint, for: .highlighted)

            case .defaultBtn:
                button.backgroundColor = style.miscButtonStyle.frameColor
                button.frameTint = style.miscButtonStyle.frameTint
                button.setTitleColor(style.miscButtonStyle.textColor, for: .normal)
                button.setTitleColor(style.miscButtonStyle.textTint, for: .highlighted)
                button.setTitleColor(style.miscButtonStyle.textTint.setDarker(by: 0.7), for: .disabled)
                
            }
            // set border color
            if style.buttonBorderColor != .clear {
                let borderColor = button.backgroundColor?.setDarker(by: 0.98)
                button.layer.borderColor = borderColor?.cgColor
            } else {
                button.layer.borderColor = style.buttonBorderColor.cgColor
            }
            button.layer.borderWidth = 0.5
            
            // set shadow
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.25
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowRadius = 1.5
            
            let shadowPath = CGPath(roundedRect: button.layer.bounds,
                                    cornerWidth: button.layer.cornerRadius,
                                    cornerHeight: button.layer.cornerRadius,
                                    transform: nil)
            button.layer.shadowPath = shadowPath
        }

    }
    
    
    // Dynamic butons stack height for autolayout
    func buttonsStackHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight > screenWidth ? screenHeight : screenWidth
        return (height / 3) * 2
    }
    
    func updateButtonIsEnabled(by forbiddenValues: Set<String>) {
        allButtons.forEach { button in
            let buttonLabel = String((button.titleLabel?.text)!)
            if forbiddenValues.contains(buttonLabel) && button.calcButtonType == .numeric {
                // disable and set transparent
                button.isEnabled = false
                button.alpha = 0.5
            } else {
                // enable button ans set normal opacity
                button.isEnabled = true
                button.alpha = 1
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Main Page

class CalcButtonsMain: CalcButtonsPage {
    
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
    func getButtons() {
        
        let allTitles = ["AC","±","Signed\nOFF","÷",
                         "7", "8", "9", "×",
                         "4", "5", "6", "-",
                         "1", "2", "3", "+",
                         "0", ".", "="]
                    
        var buttonTag: Int = 100
        var buttons: [CalculatorButton] = []
        
        // Create buttons by looping titles
        for title in allTitles {
            let button: CalculatorButton

            // initialize button by type
            switch title{
            case "0"..."9",".":
                button = CalculatorButton(calcButtonType: .numeric)
            case "Signed\nOFF":
                button = CalculatorButton()
                button.addTarget(nil, action: #selector(PCalcViewController.toggleIsSigned), for: .touchUpInside)
            case "AC":
                button = CalculatorButton()
                button.addTarget(nil, action: #selector(PCalcViewController.clearButtonTapped), for: .touchUpInside)
            case "±":
                button = CalculatorButton()
                button.addTarget(nil, action: #selector(PCalcViewController.negateButtonTapped), for: .touchUpInside)
            case "=":
                button = CalculatorButton(calcButtonType: .sign)
                button.removeTarget(nil, action: #selector(PCalcViewController.signButtonTapped), for: .touchUpInside)
                button.addTarget(nil, action: #selector(PCalcViewController.calculateButtonTapped), for: .touchUpInside)
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
            
            // button tags start from 100 to 118
            button.tag = buttonTag
            buttonTag += 1
            
            // add element to array
            buttons.append(button)
        }

        allButtons = buttons
    }
    
}

// MARK: - Additional page

class CalcButtonsAdditional: CalcButtonsPage {
    
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
    func getButtons() {
        // localization for 1's and 2's
        let oneS = NSLocalizedString("1's", comment: "")
        let twoS = NSLocalizedString("2's", comment: "")
        
        let allTitles = ["AND","OR","XOR","NOR",
                         "X<<Y", "X>>Y", "<<", ">>",
                         oneS, "D", "E", "F",
                         twoS, "A", "B", "C",
                         "00", "FF"]
                    
        var buttonTag: Int = 200
        var buttons: [CalculatorButton] = []
        
        // Create buttons by looping titles
        for title in allTitles {
            let button: CalculatorButton

            // initialize button by type
            switch title{
            case "A","B","C","D","E","F","00","FF":
                button = CalculatorButton(calcButtonType: .numeric)
            case oneS, twoS:
                button = CalculatorButton(calcButtonType: .complement)
            case "X<<Y", "X>>Y", "<<", ">>", "AND", "OR", "XOR", "NOR":
                button = CalculatorButton(calcButtonType: .bitwise)
            default:
                button = CalculatorButton(calcButtonType: .numeric)
            }
            // set actions/targets
            button.setActions(for: button.calcButtonType)
            
            // set title and style
            button.setTitle(title, for: .normal)

            button.setTitleColor(.systemGray, for: .disabled)
            button.applyStyle()
            
            // button tags start from 200 to 217
            button.tag = buttonTag
            buttonTag += 1
            
            // add element to array
            buttons.append(button)
        }

        allButtons = buttons
    }
    
}
