//
//  CalculatorButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import AudioToolbox

let clearButtonTag = 100
let negateButtonTag = 101
let signedButtonTag = 102

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
        guard tag == clearButtonTag, titleLabel?.text != title else { return }
        setTitle(title, for: .normal)
    }
    
    func changeTitleIsSignedButtonFor(_ state: Bool) {
        guard tag == signedButtonTag else { return }
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
        addTarget(nil, action: #selector(CalcButtonsViewController.hapticFeedbackHandler), for: .touchUpInside)
        addTarget(nil, action: #selector(CalcButtonsViewController.tappingSoundHandler), for: .touchUpInside)
        
        switch buttonType {
        case .numeric:
            addTarget(nil, action: #selector(CalculatorViewController.numericButtonDidPress), for: .touchUpInside)
        case .sign, .complement, .bitwise:
            addTarget(nil, action: #selector(CalculatorViewController.operatorButtonDidPress), for: .touchUpInside)
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
            button.backgroundColor = style.numericButtonStyle.backgroundColor
            button.frameTint = style.numericButtonStyle.backgroundTintColor
            button.setTitleColor(style.numericButtonStyle.textColor, for: .normal)
            button.setTitleColor(style.numericButtonStyle.textTintColor, for: .highlighted)
        case .sign:
            button.backgroundColor = style.actionButtonStyle.backgroundColor
            button.frameTint = style.actionButtonStyle.backgroundTintColor
            button.setTitleColor(style.actionButtonStyle.textColor, for: .normal)
            button.setTitleColor(style.actionButtonStyle.textTintColor, for: .highlighted)
        case .complement:
            button.backgroundColor = style.miscButtonStyle.backgroundColor
            button.frameTint = style.miscButtonStyle.backgroundTintColor
            button.setTitleColor(style.miscButtonStyle.textColor, for: .normal)
            button.setTitleColor(style.miscButtonStyle.textTintColor, for: .highlighted)
        case .bitwise:
            button.backgroundColor = style.actionButtonStyle.backgroundColor
            button.frameTint = style.actionButtonStyle.backgroundTintColor
            button.setTitleColor(style.actionButtonStyle.textColor, for: .normal)
            button.setTitleColor(style.actionButtonStyle.textTintColor, for: .highlighted)
        case .defaultBtn:
            button.backgroundColor = style.miscButtonStyle.backgroundColor
            button.frameTint = style.miscButtonStyle.backgroundTintColor
            button.setTitleColor(style.miscButtonStyle.textColor, for: .normal)
            button.setTitleColor(style.miscButtonStyle.textTintColor, for: .highlighted)
            button.setTitleColor(style.miscButtonStyle.textTintColor.darker(by: 0.7), for: .disabled)
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

class CalculatorButton_: UIButton {
    
    // MARK: - Properties
    
    var buttonWidth: CGFloat { calculateButtonWidth() }
    var defaultFontSize: CGFloat { buttonWidth / 1.65 }
    
    var buttonStyleType: ButtonStyleType { .misc }
    
    var portrait: [NSLayoutConstraint]?
    
    private var defaultBackgroundColor: UIColor = .white
    private var highlightedBackgroundColor: UIColor = .black
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedBackgroundColor
            } else {
                transitionToDefaultBackgroundColor()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.setupButton()
        self.setupActions()
        self.applyStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupButton() {
        
    }
    
    func setupActions() {
        addTarget(nil, action: #selector(CalcButtonsViewController.hapticFeedbackHandler), for: .touchUpInside)
        addTarget(nil, action: #selector(CalcButtonsViewController.tappingSoundHandler), for: .touchUpInside)
    }
    
    func applyStyle() {
        setTitleColor(.black, for: .normal)
        backgroundColor = defaultBackgroundColor
        
        if let text = titleLabel?.text, text.contains("\n") {
            titleLabel?.numberOfLines = 2
            titleLabel?.textAlignment = .center
        }
        
        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: calculateFontSize())
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.75
        titleLabel?.autoresizingMask = .flexibleWidth
        
        layer.cornerRadius = buttonWidth / 2
        
        layer.borderWidth = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1.5
        
        layer.shadowPath = CGPath(
            roundedRect: layer.bounds,
            cornerWidth: layer.cornerRadius,
            cornerHeight: layer.cornerRadius,
            transform: nil
        )
    }
    
    func calculateButtonWidth() -> CGFloat {
        let width = UIScreen.mainRealSize().width
        
        switch UIDevice.currentDeviceType {
        case .iPad:
            return (width * 0.9 - 7 * CalculatorButton.spacingWidth) / 8
        case .iPhone:
            return (width * 0.9 - 3 * CalculatorButton.spacingWidth) / 4
        }
    }
    
    func calculateFontSize() -> CGFloat {
        guard let text = titleLabel?.text else { return defaultFontSize }
        
        if text.contains("\n") {
            return buttonWidth / 3.916
        } else if text.count > 3 {
            return buttonWidth / 2.970
        } else if text.count > 1 {
            return buttonWidth / 2.65
        } else {
            return defaultFontSize
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let currentLocation = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        let isTouchOutside = !bounds.contains(currentLocation)
        if isTouchOutside {
            let isPreviousTouchInside = bounds.contains(previousLocation)
            if isPreviousTouchInside {
                sendActions(for: .touchDragExit)
            } else {
                sendActions(for: .touchDragOutside)
            }
            
            isHighlighted = false
        } else {
            let isPreviousTouchOutside = !bounds.contains(previousLocation)
            if isPreviousTouchOutside {
                sendActions(for: .touchDragEnter)
                transitionToHighlightedBackgroundColor()
            } else {
                sendActions(for: .touchDragInside)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let currentLocation = touch.location(in: self)
        
        let isTouchInBounds = bounds.contains(currentLocation)
        if isTouchInBounds {
            sendActions(for: .touchUpInside)
        } else {
            sendActions(for: .touchUpOutside)
        }
        
        isHighlighted = false
    }
    
    private func transitionToHighlightedBackgroundColor(duration: TimeInterval = 0.1) {
        UIView.transition(
            with: self,
            duration: duration,
            options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction],
            animations: { self.backgroundColor = self.highlightedBackgroundColor },
            completion: nil)
    }
    
    private func transitionToDefaultBackgroundColor(duration: TimeInterval = 0.7) {
        UIView.transition(
            with: self,
            duration: duration,
            options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
            animations: { self.backgroundColor = self.defaultBackgroundColor },
            completion: nil
        )
    }
    
    func updateStyle(buttonStyle: ButtonStyleProtocol, borderColor: UIColor) {
        defaultBackgroundColor = buttonStyle.backgroundColor
        highlightedBackgroundColor = buttonStyle.backgroundTintColor
        
        backgroundColor = buttonStyle.backgroundColor
        setTitleColor(buttonStyle.textColor, for: .normal)
        setTitleColor(buttonStyle.textTintColor, for: .highlighted)

        if borderColor != .clear {
            layer.borderColor = buttonStyle.backgroundColor.darker(by: 0.98).cgColor
        } else {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    func setDefaultConstraints(spacingBetweenButtons spacing: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        portrait = [
            heightAnchor.constraint(equalToConstant: buttonWidth),
            widthAnchor.constraint(equalToConstant: constrainedButtonWidth(withSpacing: spacing))
        ]
        
        portrait?.forEach { $0.priority = UILayoutPriority(999) }
        NSLayoutConstraint.activate(portrait!)
    }
    
    func constrainedButtonWidth(withSpacing spacing: CGFloat) -> CGFloat {
        return buttonWidth
    }
}

// MARK: - 1

enum ComplementOperator: String {
    case oneS = "1's"
    case twoS = "2's"
}

enum UnaryOperator: String {
    case shiftLeft = "<<"
    case shiftRight = ">>"
}

enum BinaryOperator: String {
    case add = "+"
    case sub = "-"
    case mul = "×"
    case div = "÷"
    case and = "AND"
    case or = "OR"
    case xor = "XOR"
    case nor = "NOR"
    case shiftLeftBy = "X<<Y"
    case shiftRightBy = "X>>Y"
    
    var isBitwise: Bool {
        switch self {
        case .add, .sub, .mul, .div:
            return false
        default:
            return true
        }
    }
}
