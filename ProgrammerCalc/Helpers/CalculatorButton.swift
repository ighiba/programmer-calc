//
//  CalculatorButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {
    // ====================
    // MARK: - Enumerations
    // ====================
    
    enum buttonTypes {
        case numeric
        case sign
        case logical
        case complement
        case bitwise
    }
    
    // ==================
    // MARK: - Properties
    // ==================
    
    
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
    
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Apply Style method to the all buttons
    // TODO: Style protocol
    func applyStyle() {
        // set title and background
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .white
        // set font size, font family
        //self.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 45.0)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin)
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
                self.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.thin)
            // if more than 1 char in title
            } else if titleText.count > 1 {
                self.titleLabel?.font = UIFont.systemFont(ofSize: 28.0, weight: UIFont.Weight.thin)
            }
            
        }
        
        // set borders
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        self.layer.cornerRadius = buttonWidth() / 2
        
    }
    
    func setActions(for buttonType: buttonTypes){
        
        self.addTarget(nil, action: #selector(PCalcViewController.toucUpOutsideAction), for: [.touchDragExit, .touchDragOutside])
        
        switch buttonType {
        case .numeric:
                self.addTarget(nil, action: #selector(PCalcViewController.numericButtonTapped), for: .touchUpInside)
            break
        case .sign:
            self.addTarget(nil, action: #selector(PCalcViewController.signButtonTapped), for: .touchUpInside)
            break
        case .complement:
            self.addTarget(nil, action: #selector(PCalcViewController.complementButtonTapped), for: .touchUpInside)
            break
        case .logical:
            break
        case .bitwise:
            self.addTarget(nil, action: #selector(PCalcViewController.bitwiseButtonTapped), for: .touchUpInside)
            break
        }
    }
    
    // Dynamic button width (except zero button) and height for autolayout
    //  5  - number of spacings
    //  17 - spacing width
    //  4  - number of buttons
    func buttonWidth() -> CGFloat {
        // TODO: Spacing width by uiscreen width
        return (UIScreen.main.bounds.width - 5 * 17) / 4
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
