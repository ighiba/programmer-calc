//
//  CalculatorButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import AudioToolbox

class CalculatorButton: UIButton {
    // ====================
    // MARK: - Enumerations
    // ====================
    
    enum ButtonTypes {
        case numeric
        case sign
        case complement
        case bitwise
        case defaultBtn
    }
    
    // ==================
    // MARK: - Properties
    // ==================
    
    private let _boundsExtension: CGFloat = 0
    
    // Button types
    public var calcButtonType: ButtonTypes = .defaultBtn // default value
    // Buff color
    var buffColor: UIColor = .white
    // Custom tint colors
    var frameTint: UIColor = .white
    var textTint: UIColor = .black
    // Constraints
    var portrait: [NSLayoutConstraint]?
    
    // override isHighlighted for calculator buttons
    override open var isHighlighted: Bool {
        // if variable state changed
        // change background color for calulator buttons while they pressed
        didSet {
            if isHighlighted {
                // create button animation when button pressed
                self.buffColor = self.backgroundColor!
                // set tint color
                self.backgroundColor = self.frameTint
            } else {
                // create button animation when button unpressed
                UIView.transition(
                    with: self,
                    duration: 0.7,
                    options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = self.buffColor },
                    completion: nil)
            }
        }
    }
    
    // ======================
    // MARK: - Initialization
    // ======================
    
    init() {
        super.init(frame: CGRect())
        self.calcButtonType = .defaultBtn
    }
    
    convenience init(calcButtonType: ButtonTypes) {
        self.init()
        self.calcButtonType = calcButtonType
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Apply default style to the all buttons
    func applyStyle() {
        // set title and background
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .white
        // set font size, font family
        //self.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 45.0)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin)
        self.titleLabel?.autoresizingMask = .flexibleWidth
        //self.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin)
        // resizeble text
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.75
        
        // handle two lined label
        if let titleText = self.titleLabel?.text {
            // if second line exists
            if titleText.contains("\n") {
                self.titleLabel?.numberOfLines = 2
                self.titleLabel?.textAlignment = .center
                //self.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
                self.titleLabel?.font = UIFont.systemFont(ofSize: buttonWidth() / 3.916 , weight: UIFont.Weight.thin)
                
            // if more than 3 char in title
            } else if titleText.count > 3 {
                self.titleLabel?.font = UIFont.systemFont(ofSize: buttonWidth() / 2.670 , weight: UIFont.Weight.thin)
            // for 2 and 3 chars
            } else if titleText.count > 1 {
                self.titleLabel?.font = UIFont.systemFont(ofSize: buttonWidth() / 2.35 , weight: UIFont.Weight.thin)
            }
        }
        
        // round corners
        self.layer.cornerRadius = buttonWidth() / 2
        
    }
    
    private func animateHighlight() {
        UIView.transition(
            with: self,
            duration: 0.1,
            options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction],
            animations: { self.backgroundColor = self.frameTint },
            completion: nil)
    }
    
    func setActions(for buttonType: ButtonTypes){
        
        // label higliglht handling
        self.addTarget(nil, action: #selector(PCalcViewController.touchHandleLabelHighlight), for: .touchDown)
        // haptic feedback
        self.addTarget(nil, action: #selector(CalcButtonsViewController.hapticFeedbackHandler), for: .touchUpInside)
        // tapping sound
        self.addTarget(nil, action: #selector(CalcButtonsViewController.tappingSoundHandler), for: .touchUpInside)
        
        switch buttonType {
        case .numeric:
            self.addTarget(nil, action: #selector(PCalcViewController.numericButtonTapped), for: .touchUpInside)
        case .sign:
            self.addTarget(nil, action: #selector(PCalcViewController.signButtonTapped), for: .touchUpInside)
        case .complement:
            self.addTarget(nil, action: #selector(PCalcViewController.complementButtonTapped), for: .touchUpInside)
        case .bitwise:
            self.addTarget(nil, action: #selector(PCalcViewController.bitwiseButtonTapped), for: .touchUpInside)
        case .defaultBtn:
            // do nothing
            break
        }
    }
    
    // Dynamic button width (except zero button) and height for autolayout
    //  5  - number of spacings
    //  17 - spacing width
    //  4  - number of buttons
    func buttonWidth() -> CGFloat {
        // TODO: Spacing width by uiscreen width
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let width = screenWidth < screenHeight ? screenWidth : screenHeight
        return (width - 5 * 17) / 4
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
                animateHighlight()
                //self.isHighlighted = true
            } else {
                sendActions(for: .touchDragInside)
                //self.isHighlighted = true
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
