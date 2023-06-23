//
//  CalculatorButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import AudioToolbox

let tagCalculatorButtonClear = 100
let tagCalculatorButtonNegate = 101
let tagCalculatorButtonIsSigned = 102

class CalculatorButton: UIButton {

    // MARK: - Enumerations
    
    enum ButtonTypes {
        case numeric
        case sign
        case complement
        case bitwise
        case defaultBtn
    }
    

    // MARK: - Properties

    private let _boundsExtension: CGFloat = 0
    // Spacing between buttons in horizontal stack (need for calculating width)
    static let spacingWidth: CGFloat = 15.83333333333333
    // Button fontSize
    var defaultFontSize: CGFloat {
        return buttonWidth() / 1.65
    }
    
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
                buffColor = self.backgroundColor!
                // set tint color
                self.backgroundColor = frameTint
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
    
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: defaultFontSize)
        self.titleLabel?.autoresizingMask = .flexibleWidth
        // resizeble text
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.75
        
        // content aligment for sign buttons
        if self.calcButtonType == .sign {
            self.contentVerticalAlignment = .top
        }
        
        // handle various button types by titleLabel text lenght
        if let titleText = self.titleLabel?.text {
            // if second line exists
            if titleText.contains("\n") {
                self.titleLabel?.numberOfLines = 2
                self.titleLabel?.textAlignment = .center
                self.titleLabel?.font = self.titleLabel?.font.withSize(buttonWidth() / 3.916)
            // if more than 3 char in title
            } else if titleText.count > 3 {
                self.titleLabel?.font = self.titleLabel?.font.withSize(buttonWidth() / 2.970)
            // for 2 and 3 chars
            } else if titleText.count > 1 {
                self.titleLabel?.font = self.titleLabel?.font.withSize(buttonWidth() / 2.65)
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
    
    // For AC/C button
    func changeTitleClearButtonFor(_ state: Bool) {
        guard self.tag == tagCalculatorButtonClear else { return }
        let title = state ? "C" : "AC"
        guard self.titleLabel?.text != title else { return }
        self.setTitle(title, for: .normal)
    }
    
    // For Signed ON/OFF button
    func changeTitleIsSignedButtonFor(_ state: Bool) {
        guard self.tag == tagCalculatorButtonIsSigned else { return }
        let title = state ? "Signed\nON" : "Signed\nOFF"
        self.setTitle(title, for: .normal)
    }
    
    // Dynamic button width (except zero button) and height for autolayout
    //  3  - number of spacings in horizontal stack
    //  0.9 - buttons stack view width
    //  4  - number of buttons
    func buttonWidth() -> CGFloat {
        let width = UIScreen.mainRealSize().width
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            return (width * 0.9 - 7 * CalculatorButton.spacingWidth) / 8
        } else {
            // iOS
            return (width * 0.9 - 3 * CalculatorButton.spacingWidth) / 4
        }
       
    }
    
    func buttonWidthPad() -> CGFloat {
        let width = UIScreen.mainRealSize().width
        return (width * 0.9 - 7 * CalculatorButton.spacingWidth) / 8
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
                isHighlighted = false
            } else {
                sendActions(for: .touchDragOutside)
                isHighlighted = false
            }
        } else {
            let previousTouchOutside: Bool = !outerBounds.contains(previousLocation)
            if previousTouchOutside {
                sendActions(for: .touchDragEnter)
                animateHighlight()
            } else {
                sendActions(for: .touchDragInside)
            }
        }
    }
    
    func setActions(for buttonType: ButtonTypes){
        // label higliglht handling
        self.addTarget(nil, action: #selector(CalculatorView.touchHandleLabelHighlight), for: .touchDown)
        // haptic feedback
        self.addTarget(nil, action: #selector(CalcButtonsViewController.hapticFeedbackHandler), for: .touchUpInside)
        // tapping sound
        self.addTarget(nil, action: #selector(CalcButtonsViewController.tappingSoundHandler), for: .touchUpInside)
        
        switch buttonType {
        case .numeric:
            self.addTarget(nil, action: #selector(CalculatorView.numericButtonTapped), for: .touchUpInside)
        case .sign, .complement, .bitwise:
            self.addTarget(nil, action: #selector(CalculatorView.signButtonTapped), for: .touchUpInside)
        case .defaultBtn:
            // do nothing
            break
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

// MARK: - Constraints

extension CalculatorButton {
    func setDefaultConstraints(spacingBetweenButtons spacing: CGFloat) {
        let button = self
        let title = button.titleLabel?.text
        button.translatesAutoresizingMaskIntoConstraints = false
        button.portrait = []
        button.portrait?.append( button.heightAnchor.constraint(equalToConstant: button.buttonWidth()) )
        // special style for double button
        if title == "00" || title == "FF" || title == "0" {
            button.portrait?.append( button.widthAnchor.constraint(equalToConstant: button.buttonWidth() * 2 + spacing) )
            button.titleLabel?.font = button.titleLabel?.font.withSize(button.defaultFontSize) // default
        } else {
            button.portrait?.append( button.widthAnchor.constraint(equalToConstant: button.buttonWidth()) )
        }
        // change priority for all constraints to 999 (for disable log noise when device is rotated)
        button.portrait!.forEach { $0.priority = UILayoutPriority(999) }
        NSLayoutConstraint.activate(button.portrait!)
    }
}


// MARK: - Style

extension CalculatorButton {
    func updateStyle(_ style: Style) {
        let button = self
        
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

        if style.buttonBorderColor != .clear {
            let borderColor = button.backgroundColor?.setDarker(by: 0.98)
            button.layer.borderColor = borderColor?.cgColor
        } else {
            button.layer.borderColor = style.buttonBorderColor.cgColor
        }
        button.layer.borderWidth = 0.5

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
