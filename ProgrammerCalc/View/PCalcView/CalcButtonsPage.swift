//
//  CalcButtonsPage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

protocol CalcButtonPageProtocol: UIView {
    var allButtons: [CalculatorButton] { get set }
    var layoutConstraints: [NSLayoutConstraint]? { get set}
}

class CalcButtonsMain: UIView, CalcButtonPageProtocol {
    
    var layoutConstraints: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setLayout()
    }
    
    fileprivate func setViews() {
        // stuff for create buttonStackView
        var buffStackView: UIStackView = UIStackView()
        var counter: Int = 0
        
        allButtons.forEach { (button) in
            
            buffStackView.addArrangedSubview(button)
            // fill each stack with 4 buttons (the last one with 3)
            switch counter {
            case 3,7,11,15,18:
                buffStackView.axis = .horizontal
                buffStackView.alignment = .fill
                buffStackView.distribution = .equalSpacing
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
    
    fileprivate func setLayout() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        layoutConstraints = [
            // Constraints for buttons (Main)
            // width = main view width - spacing * 2
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.90),
            // centering
            buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // top anchor == spacing
            buttonsStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: buttonsStackHeight() / 2 + 5),
            // bottom anchor === spacing
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(layoutConstraints!)
    }
    
    // Horizontal main calc buttons stack
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        // Display settings for buttons UIStackView
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    // Standart calculator buttons
    var allButtons: [CalculatorButton] = {
        
        let allTitles = ["AC","±","Signed\nOFF","÷",
                         "7", "8", "9", "×",
                         "4", "5", "6", "-",
                         "1", "2", "3", "+",
                         "0", ".", "="]
                    
        var buttonLabel: Int = 9
        var buttonTag: Int = 100
        var buttons: [CalculatorButton] = []
        
        allTitles.forEach { (title) in
            let button : CalculatorButton

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
                button = CalculatorButton()
                button.addTarget(nil, action: #selector(PCalcViewController.calculateButtonTapped), for: .touchUpInside)
            default:
                button = CalculatorButton(calcButtonType: .sign)
                break
            }
            // set actions/targets
            button.setActions(for: button.calcButtonType)
            
            // set title and style
            button.setTitle(title, for: .normal)
            // TODO: Themes
            button.setTitleColor(.lightGray, for: .disabled)
            button.applyStyle()
            
            // apply font style for AC button
            if title == "AC" {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin) // default
            }
                    
            // set width and height by constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth()).isActive = true
            // special width for zero
            if title == "0" {
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth() * 2 + 17).isActive = true
            } else {
                // width for default
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth()).isActive = true
            }
            // button tags start from 100 to 118
            button.tag = buttonTag
            buttonTag += 1
            
            // add element to array
            buttons.append(button)
        }

        return buttons
    }()
    
    // Dynamic butons stack height for autolayout
    func buttonsStackHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight > screenWidth ? screenHeight : screenWidth
        return (height / 3) * 2
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalcButtonsAdditional: UIView, CalcButtonPageProtocol {
    
    var layoutConstraints: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setLayout()
    }
    
    fileprivate func setViews() {
        // stuff for create buttonStackView
        var buffStackView: UIStackView = UIStackView()
        var counter: Int = 0
        
        allButtons.forEach { (button) in
            
            buffStackView.addArrangedSubview(button)
            // fill each stack with 4 buttons (the last one with 3)
            switch counter {
            case 3,7,11,15,17:
                buffStackView.axis = .horizontal
                buffStackView.alignment = .fill
                buffStackView.distribution = .equalSpacing
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
    
    fileprivate func setLayout() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        layoutConstraints = [
            // Constraints for buttons (Main)
            // width = main view width - spacing * 2
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.90),
            // centering
            buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // top anchor == spacing
            buttonsStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: buttonsStackHeight() / 2 + 5),
            // bottom anchor === spacing
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(layoutConstraints!)
    }
    
    // Horizontal main calc buttons stack
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        // Display settings for buttons UIStackView
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    // Standart calculator buttons
    var allButtons: [CalculatorButton] = {
        
        let allTitles = ["AND","OR","XOR","NOR",
                         "X<<Y", "X>>Y", "<<", ">>",
                         "D", "E", "F", "1's",
                         "A", "B", "C", "2's",
                         "00", "FF"]
                    
        var buttonLabel: Int = 9
        var buttonTag: Int = 200
        var buttons: [CalculatorButton] = []
        
        allTitles.forEach { (title) in
            let button: CalculatorButton

            // initialize button by type
            switch title{
            case "A","B","C","D","E","F","00","FF":
                button = CalculatorButton(calcButtonType: .numeric)
            // TODO: Localization
            case "1's", "2's":
                button = CalculatorButton(calcButtonType: .complement)
            case "X<<Y", "X>>Y", "<<", ">>", "AND", "OR", "XOR", "NOR":
                button = CalculatorButton(calcButtonType: .bitwise)
            default:
                button = CalculatorButton(calcButtonType: .numeric)
                break
            }
            // set actions/targets
            button.setActions(for: button.calcButtonType)
            
            // set title and style
            button.setTitle(title, for: .normal)
            // TODO: Themes
            button.setTitleColor(.lightGray, for: .disabled)
            button.applyStyle()
            
            // set width and height by constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth()).isActive = true
            // special style for 00 and FF
            if title == "00" || title == "FF" {
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth() * 2 + 17).isActive = true
                button.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin) // default
            } else {
                // width for default
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth()).isActive = true
            }
            // button tags start from 200 to 217
            button.tag = buttonTag
            buttonTag += 1
            
            // add element to array
            buttons.append(button)
            
        }

        return buttons
    }()
    
    
    // Dynamic butons stack height for autolayout
    func buttonsStackHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight > screenWidth ? screenHeight : screenWidth
        return (height / 3) * 2
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
