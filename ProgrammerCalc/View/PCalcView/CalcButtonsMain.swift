//
//  CalcButtonsMain.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class CalcButtonsMain: UIView {
    
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
        NSLayoutConstraint.activate([
            // Constraints for buttons (Main)
            // width = main view width - spacing * 2
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.90),
            // centering
            buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // top anchor == spacing
            buttonsStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: buttonsStackHeight() / 2 + 5),
            // bottom anchor === spacing
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
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
    let allButtons: [UIButton] = {
        
        let allTitles = ["AC","\u{00B1}","Signed\nOFF","\u{00f7}",
                         "7", "8", "9", "X",
                         "4", "5", "6", "-",
                         "1", "2", "3", "+",
                         "0", ".", "="]
                    
        var buttonLabel: Int = 9
        var buttonTag: Int = 100
        var buttons: [UIButton] = []
        
        allTitles.forEach { (title) in
            let button = CalculatorButton.init(type: .custom)
            button.setFrame(xMult: 0, yMult: 0, width: 75, height: 75)

            // set actions for button
            switch title{
            case "0"..."9",".":
                button.setActions(for: .numeric)
                break
            case "Signed\nOFF":
                button.addTarget(nil, action: #selector(PCalcViewController.toggleIsSigned), for: .touchUpInside)
                break
            default:
                button.setActions(for: .sign)
                break
            }
            
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
    
        // TODO: Logical buttons
        
        //
        // Logical buttons
        //

        return buttons
    }()
    
    
    // Dynamic butons stack height for autolayout
    func buttonsStackHeight() -> CGFloat {
        return (UIScreen.main.bounds.height / 3) * 2
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
