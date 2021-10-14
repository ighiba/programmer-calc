//
//  PCalcView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PCalcView: UIView {
    
    // MARK: - Properties
    
    private let margin: CGFloat = 10
    private let navBarHeight: CGFloat = 44
    
    // safe area insets in CGFloat .top .bottom
    let windowSafeAreaInsets: UIEdgeInsets = {
        if let window = UIApplication.shared.windows.first {
            return window.safeAreaInsets
        } else {
            return UIEdgeInsets()
        }
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    
    func setViews() {
        self.backgroundColor = .clear
        self.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: viewHeight())
        // add navigation bar
        self.addSubview(navigationBar)
        // add labels
        self.addSubview(labelsStack)
        
        setupLayout()
    }
    
    // MARK: - Views
    
    // Set change word size button
    lazy var changeWordSizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: navBarHeight*2, height: navBarHeight)
        // title adjustments
        button.setTitle("QWORD", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        // change font size
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
    
        button.sizeToFit()
        
        button.addTarget(nil, action: #selector(PCalcViewController.changeWordSizeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // Set navigation bar
    fileprivate let navigationBar: UINavigationBar = {
        // Set navigation bar
        let navBar = UINavigationBar(frame: CGRect())
        let navItem = UINavigationItem()
        //let changeItem = UIBarButtonItem(title: "Change conversion", style: .plain, target: self, action: #selector(PCalcViewController.changeButtonTapped))
        let changeItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"), style: .plain, target: self, action: #selector(PCalcViewController.changeConversionButtonTapped))
        //let settingsItem = UIBarButtonItem(title: "⚙\u{0000FE0E}", style: .plain, target: self, action: #selector(PCalcViewController.settingsButtonTapped))
        let settingsItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(PCalcViewController.settingsButtonTapped))
        let font = UIFont.systemFont(ofSize: 42.0)
        settingsItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        // add buttons to navigation item
        navItem.leftBarButtonItem = changeItem
        navItem.rightBarButtonItem = settingsItem
        
        // title view for middle button "Change word size"
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44*2, height: 44))
        navItem.titleView = titleView

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
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 62.0)
        label.textAlignment = .right
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        
        // add info label
        label.addInfoLabel()
        
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
        
        // add info label
        label.addInfoLabel()
   
        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [self.mainLabel, self.converterLabel])
        // Display settings for labels UIStackView
        //labels.alignment = .fill
        labels.axis = .vertical
        labels.distribution = .fillEqually
        
        labels.spacing = self.mainLabel.infoSubLabel.frame.height
        
        return labels
    }()

    // MARK: - Layout
    
    private func setupLayout() {
        //self.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        converterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate([
            // View
            //self.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            //self.heightAnchor.constraint(equalToConstant: viewHeight()+windowSafeAreaInsets.top-10),
           // self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            // Constraints for navigation bar
            navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            navigationBar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            navigationBar.heightAnchor.constraint(equalToConstant: navBarHeight),
            navigationBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Constraints for labelStack
            labelsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            labelsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95),
            //labelsStack.heightAnchor.constraint(equalToConstant: self.frame.height - 44),
            labelsStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: viewHeight() - margin*2),
            labelsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Constraints for main label
            // width and height anchors
            //mainLabel.widthAnchor.constraint(equalTo: labelsStack.widthAnchor),
            //mainLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: labelHeight() ),
            //mainLabel.heightAnchor.constraint(equalToConstant: labelHeight() ),
            
            // Constraints for converter label
            // width and height anchors
            //converterLabel.widthAnchor.constraint(equalTo: labelsStack.widthAnchor),
            //converterLabel.heightAnchor.constraint(equalToConstant: labelHeight()),
            
        ])
        
        // Additional setups
        
        // add changeWordSizeButton to navigationBar title view(in center)
        navigationBar.items?.first?.titleView?.addSubview(changeWordSizeButton)
        changeWordSizeButton.center =  (navigationBar.items?.first?.titleView!.center)!
    }
    // MARK: - Calculated heights
    
    // Dynamic label height for autolayout
    // the label stack must fill 1/3 part of screen
    func labelHeight() -> CGFloat {
        return (viewHeight() - labelsStack.spacing * 2 - navBarHeight - windowSafeAreaInsets.top - margin ) / 2
    }
    
    func viewHeight() -> CGFloat {
        return UIScreen.main.bounds.height / 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




