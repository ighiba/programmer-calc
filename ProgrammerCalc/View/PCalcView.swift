//
//  PCalcView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    
    
    func setViews() {
        self.backgroundColor = .white
        self.frame = UIScreen.main.bounds
        
        // add navigation bar
        self.addSubview(navigationBar)
        
        // add labels
        //self.addSubview(mainLabel)
        //self.addSubview(converterLabel)
        self.addSubview(labelsStack)
        
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
        //self.addSubview(converterInfo)
        //self.addSubview(changeConversion)
        setupLayout()
    }
    
    // Horizontal main calc buttons stack
    let buttonsStackView: UIStackView = UIStackView()
    
    
    // Set navigation bar
    fileprivate let navigationBar: UINavigationBar = {
        // Set navigation bar
        let navBar = UINavigationBar(frame: CGRect())
        let navItem = UINavigationItem()
        let changeItem = UIBarButtonItem(title: "Change conversion", style: .plain, target: self, action: #selector(PCalcViewController.changeButtonTapped))
        let settingsItem = UIBarButtonItem(title: "⚙\u{0000FE0E}", style: .plain, target: self, action: #selector(PCalcViewController.settingsButtonTapped))
        let font = UIFont.systemFont(ofSize: 42.0)
        settingsItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

        
        // add buttons to navigation item
        navItem.leftBarButtonItem = changeItem
        navItem.rightBarButtonItem = settingsItem
        // set navigation items
        navBar.setItems([navItem], animated: false)
        // set transparent
        navBar.backgroundColor = UIColor.white.withAlphaComponent(0)
        navBar.barTintColor = UIColor.white.withAlphaComponent(0)
        // TODO: Theme color for buttons
        
        return navBar
    }()
   
    // Label wich shows user input
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.backgroundColor = .white
        // set font size, font family
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        //label.font = UIFont.systemFont(ofSize: 72.0, weight: UIFont.Weight.thin)
        label.textAlignment = .right
        // set borders
        //label.layer.borderWidth = 0.5
        //label.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        label.layer.cornerRadius = 0.0
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        
        return label
    }()
    
    // Label wich shows converted values from user input
    lazy var converterLabel: UILabel = {
        
        let label = UILabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.numberOfLines = 2
        label.backgroundColor = .white
        // set font size, font family
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 62.0)
        //label.font = UIFont.systemFont(ofSize: 62.0, weight: UIFont.Weight.thin)
        label.textAlignment = .right
        // set borders
        //label.layer.borderWidth = 0.5
        //label.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        label.layer.cornerRadius = 0.0
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        
        //label.backgroundColor = .red
        
         
        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [self.mainLabel, self.converterLabel])
        
        labels.alignment = .fill
        labels.axis = .vertical
        
        return labels
    }()
    
    // Change conversion button
    let changeConversion: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 25)
        
        button.setTitle("Change conversion ▾", for: .normal)
        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(nil, action: #selector(PCalcViewController.changeButtonTapped), for: .touchUpInside)
        
        return button
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
            // apply style for signed button
            // TODO: Remove hardcode
            if button.titleLabel?.text == "Signed\nOFF" {
                button.titleLabel?.numberOfLines = 2
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
            }
            
            // set width and height by constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth()).isActive = true
            // special width for zero
            if title == "0" {
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: button.buttonWidth() * 2 + 15).isActive = true
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
    
    // View for converting information
    
//    lazy var converterInfo: UIView = {
//        let view = UIView()
//        
//        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        
//        view.addSubview(self.arrow)
//        view.addSubview(self.numNotation)
//        view.addSubview(self.numNotationConverted)
//        
//        return view
//    }()
//    
//    lazy var arrow: UILabel = {
//        let label = UILabel()
//        
//        label.frame = CGRect( x: 370, y: 165, width: 50, height: 50)
//        label.text = "↓"
//        // set font size, font family, color, alligment
//        label.font = UIFont(name: "HelveticaNeue-Thin", size: 32.0)
//        //label.textColor = .lightGray
//        label.textAlignment = .right
//        
//        return label
//    }()
//    
//    lazy var numNotation: UILabel = {
//
//        let label = UILabel()
//        
//        label.frame = CGRect( x: 345, y: 165, width: 25, height: 25)
//        label.text = "10"
//        // set font size, font family, color, alligment
//        label.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
//        //label.textColor = .lightGray
//        label.textAlignment = .right
//        
//        return label
//
//    }()
//    
//    lazy var numNotationConverted: UILabel = {
//        let label = UILabel()
//        
//        label.frame = CGRect( x: 345, y: 185, width: 25, height: 25)
//        label.text = "2"
//        // set font size, font family, color, alligment
//        label.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
//
//        label.textAlignment = .right
//        
//        return label
//    }()
    
    
    private func setupLayout() {
        // Constraints for navigation bar
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // Constraints for labelStack
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        labelsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
        labelsStack.heightAnchor.constraint(equalToConstant: labelHeight() * 2 - 44).isActive = true
        labelsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // Constraints for main label
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        // width and height anchors
        mainLabel.widthAnchor.constraint(equalTo: labelsStack.widthAnchor).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: labelHeight() - 33).isActive = true
        // centering
        //mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        // top anchor with safe area
        //mainLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        
        // Constraints for converter label
        converterLabel.translatesAutoresizingMaskIntoConstraints = false
        // width and height anchors
        converterLabel.widthAnchor.constraint(equalTo: labelsStack.widthAnchor).isActive = true
        converterLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: labelHeight() - 11).isActive = true
        // centering
        //converterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        // top anchor to main label
        //converterLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        
        
        // Display settings for buttons UIStackView
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .equalSpacing
        
        // Constraints for buttons (Main)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        // width = main view width - spacing * 2
        buttonsStackView.widthAnchor.constraint(equalTo: labelsStack.widthAnchor).isActive = true
        // centering
        buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        // top anchor == spacing
        buttonsStackView.topAnchor.constraint(lessThanOrEqualTo: converterLabel.bottomAnchor, constant: 10).isActive = true
        // bottom anchor === spacing
        buttonsStackView.bottomAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
//        // Contraints for converter information
//        converterInfo.translatesAutoresizingMaskIntoConstraints = false
//        // width and height anchors
//        converterInfo.widthAnchor.constraint(equalToConstant: 35).isActive = true
//        converterInfo.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        // ridght and left anchors
//        converterInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        converterInfo.centerYAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 5).isActive = true
//
//        // contraints for down arrow
//        arrow.translatesAutoresizingMaskIntoConstraints = false
//        arrow.trailingAnchor.constraint(equalTo: converterInfo.trailingAnchor).isActive = true
//
//        // contraints for input value notation
//        numNotation.translatesAutoresizingMaskIntoConstraints = false
//        numNotation.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: 8).isActive = true
//        numNotation.topAnchor.constraint(equalTo: converterInfo.topAnchor).isActive = true
//
//        // contraints for output value notation
//        numNotationConverted.translatesAutoresizingMaskIntoConstraints = false
//        numNotationConverted.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: 5).isActive = true
//        numNotationConverted.bottomAnchor.constraint(equalTo: converterInfo.bottomAnchor).isActive = true
//
//
//        // Constraints for conversion button
//        changeConversion.translatesAutoresizingMaskIntoConstraints = false
//        // width and height anchors
//        changeConversion.widthAnchor.constraint(equalToConstant: 163).isActive = true
//        changeConversion.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        // ridght and left anchors
//        changeConversion.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        changeConversion.centerYAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10).isActive = true
        
    }
    
    // Dynamic label height for autolayout
    // the labels must fill 1/3 part of screen
    func labelHeight() -> CGFloat {
        return (UIScreen.main.bounds.height / 3) / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// ==============================
// Class for calculator's buttons
// ==============================

class CalculatorButton: UIButton {
    // ============
    // Enumerations
    // ============
    
    enum buttonTypes {
        case numeric
        case sign
        case logical
    }
    
    // ==========
    // Properties
    // ==========
    
    
    private let _boundsExtension: CGFloat = 0
    // override isHighlighted for calculator buttons
    override open var isHighlighted: Bool {
        // if variable state changed
        // change background color for calulator buttons while they pressed
        didSet { 
            if isHighlighted {
                // create button animation when button pressed
                UIView.transition(
                    with: self,
                    duration: 0.1,
                    options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .lightGray },
                    completion: nil)
            } else {
                // create button animation when button unpressed
                UIView.transition(
                    with: self,
                    duration: 0.3,
                    options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .white },
                    completion: nil)
            }
        }
    }
    
    
    // =======
    // Methods
    // =======
    
    // Apply Style method to the all buttons
    // TODO: Style protocol
    func applyStyle() {
        // set title and background
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .white
        // set font size, font family
        //self.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 45.0)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin)
        // set borders
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        self.layer.cornerRadius = buttonWidth() / 2
    }
    
    func setFrame(xMult: Int, yMult: Int, width fWidth: Double, height fHeight: Double) {
        self.frame = CGRect( x: Double(85*xMult + 20), y: Double(85*yMult + 320), width: fWidth, height: fHeight)
    }
    
    func setActions(for buttonType: buttonTypes){
        
        self.addTarget(nil, action: #selector(PCalcViewController.toucUpOutsideAction), for: [.touchDragExit, .touchDragOutside])
        
        switch buttonType {
        case .numeric:
                self.addTarget(nil, action: #selector(PCalcViewController.numericButtonTapped), for: .touchUpInside)
        case .sign:
            self.addTarget(nil, action: #selector(PCalcViewController.signButtonTapped), for: .touchUpInside)
        default:
            break
        }
    }
    
    // Dynamic button width (except zero button) and height for autolayout
    //  5  - number of spacings
    //  15 - spacing width
    //  4  - number of buttons
    func buttonWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 15) / 4
    }
    
    // override for decrease control bounds of button
    // and for correct highlight animation
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let outerBounds: CGRect = bounds.insetBy(dx: -1 * _boundsExtension, dy: -1 * _boundsExtension)
        let currentLocation: CGPoint = touch.location(in: self)
        let previousLocation: CGPoint = touch.previousLocation(in: self)
        
        let touchOutside: Bool = !outerBounds.contains(currentLocation)
        
        if touchOutside {
            let previousTouchInside: Bool = outerBounds.contains(previousLocation)
            if previousTouchInside {
                sendActions(for: .touchDragExit)
                self.isHighlighted = false
            } else {
                sendActions(for: .touchDragOutside)
                self.isHighlighted = false
            }
        } else {
            let previousTouchOutside: Bool = !outerBounds.contains(previousLocation)
            if previousTouchOutside {
                sendActions(for: .touchDragEnter)
                self.isHighlighted = true
            } else {
                sendActions(for: .touchDragInside)
                self.isHighlighted = true
            }
        }

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let outerBounds: CGRect = bounds.insetBy(dx: -1 * _boundsExtension, dy: -1 * _boundsExtension)
        let currentLocation: CGPoint = touch.location(in: self)
        
        let touchInside: Bool = outerBounds.contains(currentLocation)
        if touchInside {
            self.isHighlighted = false
            return sendActions(for: .touchUpInside)
        } else {
            self.isHighlighted = false
            return sendActions(for: .touchUpOutside)
        }
    }
    
}


