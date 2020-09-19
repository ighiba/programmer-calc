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
//        self.frame = UIScreen.main.bounds
        
        self.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: labelHeight() * 2 + 44)
        
        // add navigation bar
        self.addSubview(navigationBar)
        
        // add labels
        self.addSubview(labelsStack)
        
        //self.addSubview(buttonsStackView)
        //self.addSubview(converterInfo)
        //self.addSubview(changeConversion)
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
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.backgroundColor = .white
        // set font size, font family
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        //label.font = UIFont.systemFont(ofSize: 72.0, weight: UIFont.Weight.thin)
        label.textAlignment = .right
        // set borders
        //label.layer.borderWidth = 0.5
        //label.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        label.layer.cornerRadius = 0.0
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        
        return label
    }()
    
    // Label wich shows converted values from user input
    lazy var converterLabel: UILabel = {
        
        let label = UILabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.numberOfLines = 2
        label.backgroundColor = .white
        // set font size, font family
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 62.0)
        //label.font = UIFont.systemFont(ofSize: 62.0, weight: UIFont.Weight.thin)
        label.textAlignment = .right
        // set borders
        //label.layer.borderWidth = 0.5
        //label.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        label.layer.cornerRadius = 0.0
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        
        //label.backgroundColor = .red
        
         
        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [self.mainLabel, self.converterLabel])
        // Display settings for labels UIStackView
        labels.alignment = .fill
        labels.axis = .vertical
        
        return labels
    }()
    
//    // Change conversion button
//    let changeConversion: UIButton = {
//        let button = UIButton()
//        
//        button.frame = CGRect(x: 0, y: 0, width: 200, height: 25)
//        
//        button.setTitle("Change conversion ▾", for: .normal)
//        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
//        button.setTitleColor(.black, for: .normal)
//        button.setTitleColor(.lightGray, for: .highlighted)
//        button.addTarget(nil, action: #selector(PCalcViewController.changeButtonTapped), for: .touchUpInside)
//        
//        return button
//    }()
    
    
    // View for converting information
    
//    lazy var converterInfo: UIView = {
//        let view = UIView()
//        
//        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        
//        view.addSubview(self.arrow)
//        view.addSubview(self.numNotation)
//        view.addSubview(self.numNotationConverted)
//        
//        return view
//    }()
//    
//    lazy var arrow: UILabel = {
//        let label = UILabel()
//        
//        label.frame = CGRect( x: 370, y: 165, width: 50, height: 50)
//        label.text = "↓"
//        // set font size, font family, color, alligment
//        label.font = UIFont(name: "HelveticaNeue-Thin", size: 32.0)
//        //label.textColor = .lightGray
//        label.textAlignment = .right
//        
//        return label
//    }()
//    
//    lazy var numNotation: UILabel = {
//
//        let label = UILabel()
//        
//        label.frame = CGRect( x: 345, y: 165, width: 25, height: 25)
//        label.text = "10"
//        // set font size, font family, color, alligment
//        label.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
//        //label.textColor = .lightGray
//        label.textAlignment = .right
//        
//        return label
//
//    }()
//    
//    lazy var numNotationConverted: UILabel = {
//        let label = UILabel()
//        
//        label.frame = CGRect( x: 345, y: 185, width: 25, height: 25)
//        label.text = "2"
//        // set font size, font family, color, alligment
//        label.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
//
//        label.textAlignment = .right
//        
//        return label
//    }()
    
    
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
        
        
//        // Contraints for converter information
//        converterInfo.translatesAutoresizingMaskIntoConstraints = false
//        // width and height anchors
//        converterInfo.widthAnchor.constraint(equalToConstant: 35).isActive = true
//        converterInfo.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        // ridght and left anchors
//        converterInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        converterInfo.centerYAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 5).isActive = true
//
//        // contraints for down arrow
//        arrow.translatesAutoresizingMaskIntoConstraints = false
//        arrow.trailingAnchor.constraint(equalTo: converterInfo.trailingAnchor).isActive = true
//
//        // contraints for input value notation
//        numNotation.translatesAutoresizingMaskIntoConstraints = false
//        numNotation.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: 8).isActive = true
//        numNotation.topAnchor.constraint(equalTo: converterInfo.topAnchor).isActive = true
//
//        // contraints for output value notation
//        numNotationConverted.translatesAutoresizingMaskIntoConstraints = false
//        numNotationConverted.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: 5).isActive = true
//        numNotationConverted.bottomAnchor.constraint(equalTo: converterInfo.bottomAnchor).isActive = true
//
//
//        // Constraints for conversion button
//        changeConversion.translatesAutoresizingMaskIntoConstraints = false
//        // width and height anchors
//        changeConversion.widthAnchor.constraint(equalToConstant: 163).isActive = true
//        changeConversion.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        // ridght and left anchors
//        changeConversion.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        changeConversion.centerYAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10).isActive = true
        
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




