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

    static let spacingWidth: CGFloat = 15.83333333333333

    var defaultFontSize: CGFloat { buttonWidth() / 1.65 }
    
    public var calcButtonType: ButtonTypes = .defaultBtn
    var buffColor: UIColor? = .white

    var frameTint: UIColor = .white
    var textTint: UIColor = .black

    var portrait: [NSLayoutConstraint]?
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                buffColor = backgroundColor
                backgroundColor = frameTint
            } else {
                UIView.transition(
                    with: self,
                    duration: 0.7,
                    options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = self.buffColor },
                    completion: nil
                )
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect())
        calcButtonType = .defaultBtn
    }
    
    convenience init(calcButtonType: ButtonTypes) {
        self.init()
        self.calcButtonType = calcButtonType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func applyStyle() {
        setTitleColor(.black, for: .normal)
        backgroundColor = .white

        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: defaultFontSize)
        titleLabel?.autoresizingMask = .flexibleWidth

        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.75
        
        if calcButtonType == .sign {
            contentVerticalAlignment = .top
        }
        
        if let titleText = titleLabel?.text {
            if titleText.contains("\n") {
                titleLabel?.numberOfLines = 2
                titleLabel?.textAlignment = .center
                titleLabel?.font = titleLabel?.font.withSize(buttonWidth() / 3.916)
            } else if titleText.count > 3 {
                titleLabel?.font = titleLabel?.font.withSize(buttonWidth() / 2.970)
            } else if titleText.count > 1 {
                titleLabel?.font = titleLabel?.font.withSize(buttonWidth() / 2.65)
            }
        }
        
        layer.cornerRadius = buttonWidth() / 2
    }
  
    private func animateHighlight() {
        UIView.transition(
            with: self,
            duration: 0.1,
            options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction],
            animations: { self.backgroundColor = self.frameTint },
            completion: nil)
    }
    
    func changeTitleClearButtonFor(_ state: Bool) {
        let title = state ? "C" : "AC"
        guard tag == tagCalculatorButtonClear, titleLabel?.text != title else { return }
        setTitle(title, for: .normal)
    }
    
    func changeTitleIsSignedButtonFor(_ state: Bool) {
        guard tag == tagCalculatorButtonIsSigned else { return }
        let title = state ? "Signed\nON" : "Signed\nOFF"
        setTitle(title, for: .normal)
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
        addTarget(nil, action: #selector(CalculatorViewController.touchHandleLabelHighlight), for: .touchDown)
        addTarget(nil, action: #selector(CalcButtonsViewController.hapticFeedbackHandler), for: .touchUpInside)
        addTarget(nil, action: #selector(CalcButtonsViewController.tappingSoundHandler), for: .touchUpInside)
        
        switch buttonType {
        case .numeric:
            addTarget(nil, action: #selector(CalculatorViewController.numericButtonTapped), for: .touchUpInside)
        case .sign, .complement, .bitwise:
            addTarget(nil, action: #selector(CalculatorViewController.signButtonTapped), for: .touchUpInside)
        case .defaultBtn:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let outerBounds: CGRect = bounds.insetBy(dx: -1 * _boundsExtension, dy: -1 * _boundsExtension)
        let currentLocation: CGPoint = touch.location(in: self)
        
        let touchInside: Bool = outerBounds.contains(currentLocation)
        if touchInside {
            isHighlighted = false
            return sendActions(for: .touchUpInside)
        } else {
            isHighlighted = false
            sendActions(for: .touchUpOutside)
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

        if title == "00" || title == "FF" || title == "0" {
            button.portrait?.append( button.widthAnchor.constraint(equalToConstant: button.buttonWidth() * 2 + spacing) )
            button.titleLabel?.font = button.titleLabel?.font.withSize(button.defaultFontSize) // default
        } else {
            button.portrait?.append( button.widthAnchor.constraint(equalToConstant: button.buttonWidth()) )
        }

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
            button.setTitleColor(style.miscButtonStyle.textTint.darker(by: 0.7), for: .disabled)
        }

        if style.buttonBorderColor != .clear {
            let borderColor = button.backgroundColor?.darker(by: 0.98)
            button.layer.borderColor = borderColor?.cgColor
        } else {
            button.layer.borderColor = style.buttonBorderColor.cgColor
        }
        button.layer.borderWidth = 0.5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 1.5
        
        let shadowPath = CGPath(
            roundedRect: button.layer.bounds,
            cornerWidth: button.layer.cornerRadius,
            cornerHeight: button.layer.cornerRadius,
            transform: nil
        )
        button.layer.shadowPath = shadowPath
    }
}
