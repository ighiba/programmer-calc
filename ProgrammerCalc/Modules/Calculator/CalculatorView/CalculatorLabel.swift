//
//  CalculatorLabel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

final class CalculatorLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool { true }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupGestures()
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        layer.backgroundColor = UIColor.clear.cgColor
        
        addSubview(conversionSystemLabel)
    }
    
    private func setupGestures() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: UIMenuController.willHideMenuNotification, object: nil, queue: .main) { [weak self] _ in
            if self?.layer.backgroundColor != UIColor.clear.cgColor {
                self?.disableHighlighting()
            }
        }
    }
    
    func addSwipeRightGesture(target: Any?, action: Selector?) {
        let swipeRight = UISwipeGestureRecognizer(target: target, action: action)
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        resignFirstResponder()
    }
    
    private func enableHighlighting() {
        layer.cornerRadius = 0
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0)
        
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.layer.cornerRadius = 15
            self?.layer.masksToBounds = true
            self?.layer.backgroundColor = UIColor.lightGray.cgColor.copy(alpha: 0.3)
        }, completion: nil)
    }
    
    private func disableHighlighting() {
        resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.layer.cornerRadius = 0
            self?.layer.masksToBounds = false
            self?.layer.backgroundColor = UIColor.clear.cgColor
        }, completion: nil)
    }
    
    func setText(_ text: String) {
        self.text = text
    }
    
    // MARK: - Views
    
    lazy var conversionSystemLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 44, height: 14.5)
        label.text = "Decimal"
        label.backgroundColor = .clear
        label.textColor = .systemGray
        
        label.font = .conversionSystemLabelFont
        label.textAlignment = .center
        
        label.sizeToFit()
        
        return label
    }()
}

// MARK: - Actions

extension CalculatorLabel {
    @objc func showMenu(_ sender: AnyObject?) {
        becomeFirstResponder()
        
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            let settings = Settings.shared
            if settings.isHapticFeedbackEnabled {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            }
            
            enableHighlighting()
            
            menu.showMenu(from: self, rect: bounds)
        }
    }
}
