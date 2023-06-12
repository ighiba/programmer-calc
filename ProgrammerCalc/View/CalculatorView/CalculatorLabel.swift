//
//  CalculatorLabel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import QuartzCore

protocol UpdatableLabel: UILabel {
    var updateHandler: ((UpdatableLabel) -> Void)? { get set }
}

protocol CalculatorLabelDelegate {
    var hasError: Bool { get }
    func getText(deleteSpaces: Bool) -> String
    func setText(_ text: String)
    func setError(_ error: MathErrors)
    func showErrorInLabel(_ errorMessage: String)
}

class CalculatorLabel: UILabel, UpdatableLabel, CalculatorLabelDelegate {

    // ==================
    // MARK: - Properties
    // ==================
    
    var updateHandler: ((UpdatableLabel) -> Void)?

    // Font
    let fontName: String = "HelveticaNeue-Thin"
    // Sub label for displaying current system of label
    lazy var infoSubLabel: UILabel = getSubLabel()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var text: String? {
        didSet {
            //print(self.text)
            self.updateHandler?(self)
        }
    }
    
    var error: MathErrors?
    
    var hasError: Bool {
        return error != nil
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func addInfoLabel() {
        self.addSubview(infoSubLabel)
        infoSubLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoSubLabel.topAnchor.constraint(equalTo: self.bottomAnchor),
            infoSubLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
    
    // Set new value in info label
    func setInfoLabelValue(_ newValue: ConversionSystemsEnum) {
        self.infoSubLabel.text = newValue.rawValue
    }
    
    fileprivate func getSubLabel() -> UILabel {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 44, height: 14.5)
        label.text = "Decimal"
        label.backgroundColor = .clear
        label.textColor = .systemGray
        
        label.font = UIFont(name: fontName, size: 12.0)
        label.textAlignment = .center
        
        label.sizeToFit()
        
        return label
    }
    
    // Action when long press on label
    @objc func showMenu(_ sender: AnyObject?) {
        self.becomeFirstResponder()
        
        let menu = UIMenuController.shared

        if !menu.isMenuVisible {
            // haptic feedback generator
            let settings = Settings.shared
            if settings.hapticFeedback {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                // impact
                generator.impactOccurred()
            }
            // higlight label and show menu
            highlightLabel()
            menu.showMenu(from: self, rect: bounds)
            
        }
    }
    
    // Press copy button
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        var textToBoard: String? = ""
        // Check if error message in main label
        for error in MathErrors.allCases {
            if self.text == error.localizedDescription {
                // set converter to NaN if error in label
                textToBoard = self.text
                break
            } else {
                // change clipboard text with new value from label self.text and delete all spaces in string
                textToBoard = self.text?.removeAllSpaces()
            }
        }
        
        // set clipboard
        board.string = textToBoard

        // hide menu
        self.hideLabelMenu()
        self.resignFirstResponder()
        // do animation
        undoHighlightLabel()
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    
    // Animations for un/highllight labels on long touch (copy from label)
    func highlightLabel() {
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0)
        
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0.3)
            self.layer.cornerRadius = 15
            self.layer.masksToBounds = true
        }, completion: nil)

    }
    
    func undoHighlightLabel() {
        self.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0)
            self.layer.cornerRadius = 0
            self.layer.masksToBounds = false
        }, completion: nil)
        
    }
    
    public func hideLabelMenu() {
        let menu = UIMenuController.shared
        menu.hideMenu(from: self)
        undoHighlightLabel()
    }
    
    public func getText(deleteSpaces: Bool = false) -> String {
        if deleteSpaces {
            return self.text?.removeAllSpaces() ?? "0"
        } else {
            return self.text ?? "0"
        }
    }
    
    public func setText(_ text: String) {
        self.text = text
    }
    
    public func setError(_ error: MathErrors) {
        self.error = error
    }
    
    public func resetError() {
        self.error = nil
    }

    public func showErrorInLabel(_ errorMessage: String = "Error") {
        guard errorMessage == "Error" else {
            self.text = errorMessage
            return
        }
        
        if let error = self.error {
            self.text = error.localizedDescription!
        } else {
            self.text = errorMessage
        }
    }
}
