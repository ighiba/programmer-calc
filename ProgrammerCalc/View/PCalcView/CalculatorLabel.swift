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
    var updateRawValueHandler: ((UpdatableLabel) -> Void)? { get set }
}

class CalcualtorLabel: UILabel, UpdatableLabel {

    // ==================
    // MARK: - Properties
    // ==================
    
    var updateRawValueHandler: ((UpdatableLabel) -> Void)?
    
    override var text: String? {
        didSet {
            self.updateRawValueHandler?(self)
            
        }
    }
    var rawValue: NumberSystemProtocol?

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    lazy var infoSubLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 44, height: 14.5)
        label.text = "Decimal"
        label.backgroundColor = .clear
        label.textColor = .systemGray
        
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
        label.textAlignment = .center
        
        label.sizeToFit()
        
        return label
    }()
    
    // ======================
    // MARK: - Initialization
    // ======================
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit() 
    }
    
    func sharedInit() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    func setRawValue(value: NumberSystemProtocol) {
        self.rawValue = value
    }
    
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
    
    // Action when long press on label
    @objc func showMenu(_ sender: AnyObject?) {
        self.becomeFirstResponder()
        
        let menu = UIMenuController.shared

        if !menu.isMenuVisible {
            let settingsStorage = SettingsStorage()
            // haptic feedback generator
            let settings = settingsStorage.loadData()
            if (settings?.hapticFeedback ?? false) {
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
        // change clipboard with new value from label self.text and delete all spaces in string
        board.string = self.text?.removeAllSpaces()
        // hide menu
        self.hideLabelMenu()
        self.resignFirstResponder()
        // do animation
        undoHighlightLabel()
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
