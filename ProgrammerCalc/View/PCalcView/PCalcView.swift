//
//  PCalcView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    
    func setViews() {
        self.backgroundColor = .clear
        self.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: labelHeight() * 2 + 44)
        // add navigation bar
        self.addSubview(navigationBar)
        // add labels
        self.addSubview(labelsStack)
        
        setupLayout()
    }
    
    // Set navigation bar
    fileprivate let navigationBar: UINavigationBar = {
        // Set navigation bar
        let navBar = UINavigationBar(frame: CGRect())
        let navItem = UINavigationItem()
        let changeItem = UIBarButtonItem(title: "Change conversion", style: .plain, target: self, action: #selector(PCalcViewController.changeButtonTapped))
        let settingsItem = UIBarButtonItem(title: "⚙\u{0000FE0E}", style: .plain, target: self, action: #selector(PCalcViewController.settingsButtonTapped))
        let font = UIFont.systemFont(ofSize: 42.0)
        settingsItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        // add buttons to navigation item
        navItem.leftBarButtonItem = changeItem
        navItem.rightBarButtonItem = settingsItem
        // set navigation items
        navBar.setItems([navItem], animated: false)
        // set transparent
        navBar.backgroundColor = UIColor.white.withAlphaComponent(0)
        navBar.barTintColor = UIColor.white.withAlphaComponent(0)
        // set clear for bottom line (shadow)
        navBar.setValue(true, forKey: "hidesShadow")
        // TODO: Theme color for buttons

        return navBar
    }()
   
    // Label wich shows user input
    lazy var mainLabel: CalcualtorLabel = {
        let label = CalcualtorLabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.backgroundColor = .clear
        // set font size, font family, allignment
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        label.textAlignment = .right
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        
        return label
    }()
    
    // Label wich shows converted values from user input
    lazy var converterLabel: CalcualtorLabel = {
        let label = CalcualtorLabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.numberOfLines = 2
        label.backgroundColor = .clear
        // set font size, font family
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 62.0)
        label.textAlignment = .right
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
   
        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [self.mainLabel, self.converterLabel])
        // Display settings for labels UIStackView
        labels.alignment = .fill
        labels.axis = .vertical
        
        return labels
    }()

    private func setupLayout() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        converterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate([
            // Constraints for navigation bar
            navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            navigationBar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            navigationBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Constraints for labelStack
            labelsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            labelsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95),
            labelsStack.heightAnchor.constraint(equalToConstant: labelHeight() * 2 - 44),
            labelsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Constraints for main label
            // width and height anchors
            mainLabel.widthAnchor.constraint(equalTo: labelsStack.widthAnchor),
            mainLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: labelHeight() - 33),
            
            // Constraints for converter label
            // width and height anchors
            converterLabel.widthAnchor.constraint(equalTo: labelsStack.widthAnchor),
            converterLabel.heightAnchor.constraint(equalToConstant: labelHeight() - 11),
        ])
    }
    
    // Dynamic label height for autolayout
    // the labels must fill 1/3 part of screen
    func labelHeight() -> CGFloat {
        return (UIScreen.main.bounds.height / 3) / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




