//
//  PCalcView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit



class PCalcView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setViews()
    }
    
    
    func setViews() {
        allViews.frame = UIScreen.main.bounds
        allViews.addSubview(mainLabel)
        allViews.addSubview(converterLabel)
        
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
        
        allViews.addSubview(buttonsStackView)
        setupLayout()
    }
    
    let allViews: UIView = UIView()
    let buttonsStackView: UIStackView = UIStackView()
    
    
    // Label wich shows user input
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect( x: Double(0), y: Double(20), width: 372.0, height: 100.0)
        label.text = "0"
        label.backgroundColor = .white
        // set font size, font family
        //mainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        label.font = UIFont.systemFont(ofSize: 72.0, weight: UIFont.Weight.thin)
        label.textAlignment = .right
        // set borders
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        label.layer.cornerRadius = 0.0
        // resizeble text
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    // Label wich shows converted values from user input
    lazy var converterLabel: UILabel = {
        
        let label = UILabel()
        
        label.frame = CGRect( x: Double(0), y: Double(120), width: 372.0, height: 100.0)
        label.text = "0"
        label.backgroundColor = .white
        // set font size, font family
        //mainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        label.font = UIFont.systemFont(ofSize: 62.0, weight: UIFont.Weight.thin)
        label.textAlignment = .right
        // set borders
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        label.layer.cornerRadius = 0.0
        // resizeble text
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
         
         return label
    }()
    
    // Standart calculator buttons
    let allButtons: [UIButton] = {
        
        let allTitles = ["AC","\u{00B1}","%","\u{00f7}",
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
            default:
                button.setActions(for: .sign)
                break
            }
            
            // set title and style
            button.setTitle(title, for: .normal)
            button.applyStyle()
            
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
    
    
    private func setupLayout() {
        // Constraints for main label
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        // width and height anchors
        mainLabel.widthAnchor.constraint(equalTo: allViews.widthAnchor).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: labelHeight()).isActive = true
        // ridght and left anchors
        mainLabel.rightAnchor.constraint(equalTo: allViews.rightAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: allViews.leftAnchor).isActive = true
        // top anchor with safe area
        mainLabel.topAnchor.constraint(equalTo: allViews.safeAreaLayoutGuide.topAnchor).isActive = true
        
        // Constraints for converter label
        converterLabel.translatesAutoresizingMaskIntoConstraints = false
        // width and height anchors
        converterLabel.widthAnchor.constraint(equalTo: allViews.widthAnchor).isActive = true
        converterLabel.heightAnchor.constraint(equalToConstant: labelHeight()).isActive = true
        // ridght and left anchors
        converterLabel.rightAnchor.constraint(equalTo: allViews.rightAnchor).isActive = true
        converterLabel.leftAnchor.constraint(equalTo: allViews.leftAnchor).isActive = true
        // top anchor to main label
        converterLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        
        
        // Display settings for buttons UIStackView
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .equalSpacing
        
        // Constraints for buttons (Main)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        // width = main view width - spacing * 2
        buttonsStackView.widthAnchor.constraint(equalToConstant: allViews.frame.width - 30).isActive = true
        // left anchor == spacing
        buttonsStackView.leadingAnchor.constraint(lessThanOrEqualTo: allViews.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        // top anchor == spacing
        buttonsStackView.topAnchor.constraint(lessThanOrEqualTo: converterLabel.bottomAnchor, constant: 15).isActive = true
        // bottom anchor === spacing
        buttonsStackView.bottomAnchor.constraint(greaterThanOrEqualTo: allViews.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
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
                //print("HIGHLIGHT - ON")
                // create button animation when button pressed
                UIView.transition(
                    with: self,
                    duration: 0.1,
                    options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .lightGray },
                    completion: nil)
            } else {
                //print("HIGHLIGHT - OFF")
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
        self.layer.cornerRadius = 35.0
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
                //print("touchDragExit")
            } else {
                sendActions(for: .touchDragOutside)
                self.isHighlighted = false
                //print("touchDragOutside")
            }
        } else {
            let previousTouchOutside: Bool = !outerBounds.contains(previousLocation)
            if previousTouchOutside {
                sendActions(for: .touchDragEnter)
                self.isHighlighted = true
                //print("touchDragEnter")
            } else {
                sendActions(for: .touchDragInside)
                self.isHighlighted = true
                //print("touchDragInside")
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
            //print("touchUpInside")
            return sendActions(for: .touchUpInside)
        } else {
            self.isHighlighted = false
            //print("touchUpOutside")
            return sendActions(for: .touchUpOutside)
        }
    }
    
}


