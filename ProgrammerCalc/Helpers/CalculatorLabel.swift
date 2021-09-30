//
//  CalculatorLabel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import QuartzCore

class CalcualtorLabel: UILabel {
    
    // ==================
    // MARK: - Properties
    // ==================

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
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
    
    // Action when long press on label
    @objc func showMenu(_ sender: AnyObject?) {
        self.becomeFirstResponder()
        
        let menu = UIMenuController.shared

        if !menu.isMenuVisible {
            
            highlightLabel()
            menu.showMenu(from: self, rect: bounds)
            
        }
    }
    
    // Press copy button
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        
        // change clipboard with new value from label self.text and delete all spaces in string
        board.string = self.text?.replacingOccurrences(of: " ", with: "")
        
        self.hideLabelMenu()
        self.resignFirstResponder()
        
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
