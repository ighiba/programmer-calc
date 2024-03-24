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
    
    // MARK: - Properties
    
    static let spacingWidth: CGFloat = 15.83333333333333
    
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
        addTarget(nil, action: #selector(CalculatorViewController.hapticFeedbackHandler), for: .touchUpInside)
        addTarget(nil, action: #selector(CalculatorViewController.tappingSoundHandler), for: .touchUpInside)
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
        let width = UIScreen.main.portraitSize.width
        
        switch UIDevice.current.deviceType {
        case .iPad:
            return (width * 0.9 - 7 * Self.spacingWidth) / 8
        case .iPhone:
            return (width * 0.9 - 3 * Self.spacingWidth) / 4
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
        let options: UIView.AnimationOptions = [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction]
        
        UIView.transition(
            with: self,
            duration: duration,
            options: options,
            animations: { self.backgroundColor = self.highlightedBackgroundColor },
            completion: nil)
    }
    
    private func transitionToDefaultBackgroundColor(duration: TimeInterval = 0.7) {
        let options: UIView.AnimationOptions = [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction]
        
        UIView.transition(
            with: self,
            duration: duration,
            options: options,
            animations: { self.backgroundColor = self.defaultBackgroundColor },
            completion: nil
        )
    }
    
    func updateStyle(buttonStyle: ButtonStyleProtocol) {
        defaultBackgroundColor = buttonStyle.backgroundColor
        highlightedBackgroundColor = buttonStyle.backgroundTintColor
        
        backgroundColor = buttonStyle.backgroundColor
        setTitleColor(buttonStyle.textColor, for: .normal)
        setTitleColor(buttonStyle.textTintColor, for: .highlighted)
        layer.borderColor = buttonStyle.borderColor.cgColor
    }
    
    func setConstraints(spacingBetweenButtons spacing: CGFloat) {
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
