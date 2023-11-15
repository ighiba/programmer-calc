//
//  CalculatorLabel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

protocol UpdatableLabel: UILabel {
    var updateHandler: ((UpdatableLabel) -> Void)? { get set }
}

protocol CalculatorLabelDelegate {
    var hasError: Bool { get }
    func getText(deleteSpaces: Bool) -> String
    func setText(_ text: String)
    func setError(_ error: MathError)
    func showErrorInLabel(_ errorMessage: String)
}

class CalculatorLabel: UILabel, UpdatableLabel, CalculatorLabelDelegate {

    // MARK: - Properties
    
    var updateHandler: ((UpdatableLabel) -> Void)?

    lazy var infoSubLabel: UILabel = getSubLabel()
    
    override var canBecomeFirstResponder: Bool { true }
    
    override var text: String? {
        didSet {
            updateHandler?(self)
        }
    }
    
    var error: MathError?
    var hasError: Bool { error != nil }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        var textToBoard: String? = ""
        for error in MathError.allCases {
            if text == error.localizedDescription {
                textToBoard = text
                break
            } else {
                textToBoard = text?.removedAllSpaces()
            }
        }
        
        board.string = textToBoard
        hideLabelMenu()
        resignFirstResponder()
        undoHighlightLabel()
    }
    
    func addInfoLabel() {
        addSubview(infoSubLabel)
        infoSubLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoSubLabel.topAnchor.constraint(equalTo: bottomAnchor),
            infoSubLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
    func setInfoLabelValue(_ newValue: ConversionSystem) {
        infoSubLabel.text = newValue.title
    }
    
    private func getSubLabel() -> UILabel {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 44, height: 14.5)
        label.text = "Decimal"
        label.backgroundColor = .clear
        label.textColor = .systemGray
        
        label.font = .infoLabelFont
        label.textAlignment = .center
        
        label.sizeToFit()
        
        return label
    }
    
    func highlightLabel() {
        layer.cornerRadius = 0
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0)
        
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0.3)
            self?.layer.cornerRadius = 15
            self?.layer.masksToBounds = true
        }, completion: nil)

    }
    
    func undoHighlightLabel() {
        resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0)
            self?.layer.cornerRadius = 0
            self?.layer.masksToBounds = false
        }, completion: nil)
    }
    
    func hideLabelMenu() {
        let menu = UIMenuController.shared
        menu.hideMenu(from: self)
        undoHighlightLabel()
    }
    
    func getText(deleteSpaces: Bool = false) -> String {
        if deleteSpaces {
            return text?.removedAllSpaces() ?? "0"
        } else {
            return text ?? "0"
        }
    }
    
    func setText(_ text: String) {
        self.text = text
    }
    
    func setError(_ error: MathError) {
        self.error = error
    }
    
    func resetError() {
        error = nil
    }

    func showErrorInLabel(_ errorMessage: String = "Error") {
        guard errorMessage == "Error" else {
            text = errorMessage
            return
        }
        
        if let error = self.error {
            text = error.localizedDescription!
        } else {
            text = errorMessage
        }
    }
}

// MARK: - Actions

extension CalculatorLabel {
    @objc func showMenu(_ sender: AnyObject?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            let settings = Settings.shared
            if settings.hapticFeedback {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            }
            highlightLabel()
            menu.showMenu(from: self, rect: bounds)
        }
    }
}
