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
    
    // Constraints
    var portrait: [NSLayoutConstraint]?
    var landscape: [NSLayoutConstraint]?
    var landscapeWithBitKeypad: [NSLayoutConstraint]?
    
    // safe area insets in CGFloat .top .bottom
    let windowSafeAreaInsets: UIEdgeInsets = {
        if let window = UIApplication.shared.windows.first {
            return window.safeAreaInsets
        } else {
            return UIEdgeInsets()
        }
    }()
    
    // Style factory
    var styleFactory: StyleFactory = StyleFactory()
    
    
    // NavBar buttons
    private let changeItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(PCalcViewController.changeConversionButtonTapped))
    private let keypadItem = UIBarButtonItem(image: UIImage(named: "keypadIcon-bitwise"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(PCalcViewController.switchKeypad))
    private let settingsItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                              style: .plain,
                                                              target: self,
                                                              action: #selector(PCalcViewController.settingsButtonTapped))
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        // update colors by style
        updateStyle()
    }
    
    func setViews() {
        self.backgroundColor = .clear
        self.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: getViewHeight())
        // add navigation bar
        self.addSubview(navigationBar)
        // add labels
        self.addSubview(labelsStack)
        self.addSubview(mainLabel.infoSubLabel)
        self.addSubview(converterLabel.infoSubLabel)
        
        navigationBar.subviews.forEach({ $0.isExclusiveTouch = true })
        
        setupLayout()
    }
    
    func updateStyle() {
        // Apply style
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        
        // Set colors
        // Labels
        mainLabel.textColor = style.labelTextColor
        converterLabel.textColor = style.labelTextColor
        mainLabel.infoSubLabel.textColor = .systemGray
        converterLabel.infoSubLabel.textColor = .systemGray
        // NavBar items
        changeItem.tintColor = style.tintColor
        keypadItem.tintColor = style.tintColor
        settingsItem.tintColor = style.tintColor
        changeWordSizeButton.tintColor = style.tintColor
    }
    
    func hideConverterLabel() {
        // hide
        mainLabel.isHidden = false
        converterLabel.infoSubLabel.isHidden = true
        converterLabel.isHidden = true
        // bigger font for mainLabel
        mainLabel.font = mainLabel.font.withSize(82.0)
        mainLabel.numberOfLines = 2
    }
    
    func showConverterLabel() {
        // unhide
        mainLabel.isHidden = false
        converterLabel.infoSubLabel.isHidden = false
        converterLabel.isHidden = false
        // default font for mainLabel
        mainLabel.font = mainLabel.font.withSize(70.0)
    }
    
    func freezeNavBar(by duration: CGFloat) {
        navigationBar.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
            self.navigationBar.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - Views
    
    // Set change word size button
    lazy var changeWordSizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: navBarHeight*2, height: navBarHeight)
        // title adjustments
        button.setTitle("QWORD", for: .normal)
        // change font size
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
    
        button.sizeToFit()
        
        button.addTarget(nil, action: #selector(PCalcViewController.changeWordSizeButtonTapped), for: .touchUpInside)
        
        // for UI tests
        button.accessibilityIdentifier = "ChangeWordSizeButton"
        
        return button
    }()
    
    // Set navigation bar
    fileprivate lazy var navigationBar: UINavigationBar = {
        // Set navigation bar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let navItem = UINavigationItem()
        let font = UIFont.systemFont(ofSize: 42.0)
        self.settingsItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        // add buttons to navigation item
        navItem.leftBarButtonItems = [changeItem, keypadItem]
        navItem.rightBarButtonItem = settingsItem
        
        // title view for middle button "Change word size"
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44*2, height: 44))
        navItem.titleView = titleView

        // set navigation items
        navBar.setItems([navItem], animated: false)
        // set transparent
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true

        return navBar
    }()
   
    // Label wich shows user input
    lazy var mainLabel: CalcualtorLabel = {
        let label = CalcualtorLabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.backgroundColor = .clear
        // set font size, font family, allignment
        label.font = UIFont(name: label.fontName, size: 70.0)
        label.textAlignment = .right
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        
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
        label.font = UIFont(name: label.fontName, size: 70.0)
        label.textAlignment = .right
        // resizeble text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
   
        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [self.mainLabel, self.converterLabel])
        // Display settings for labels UIStackView
        labels.axis = .vertical
        labels.distribution = .fillEqually
        
        labels.spacing = self.mainLabel.infoSubLabel.frame.height
        
        return labels
    }()
    

    // MARK: - Layout
    
    private func setupLayout() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.infoSubLabel.translatesAutoresizingMaskIntoConstraints = false
        converterLabel.infoSubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for portrait orientation
        portrait = [
            navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: navBarHeight),
            navigationBar.widthAnchor.constraint(equalTo: self.widthAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            labelsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            labelsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95),
            labelsStack.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            
            mainLabel.infoSubLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            mainLabel.infoSubLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor, constant: -5),
            
            converterLabel.infoSubLabel.topAnchor.constraint(equalTo: converterLabel.bottomAnchor),
            converterLabel.infoSubLabel.trailingAnchor.constraint(equalTo: converterLabel.trailingAnchor, constant: -5),
            
        ]
        
        // Constraints for landscape orientation
        landscape = [
            labelsStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            labelsStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: getScreenBounds().width * 0.05),
            labelsStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: getScreenBounds().width * -0.05),
            labelsStack.heightAnchor.constraint(equalToConstant: getScreenBounds().width * 0.85),
            
            mainLabel.infoSubLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            mainLabel.infoSubLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor, constant: -5),
            
            converterLabel.infoSubLabel.topAnchor.constraint(equalTo: converterLabel.bottomAnchor),
            converterLabel.infoSubLabel.trailingAnchor.constraint(equalTo: converterLabel.trailingAnchor, constant: -5),
        ]
        
        // Constraints for landscape orientation (with bitwise keypad enabled)
        landscapeWithBitKeypad = [
            labelsStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: getScreenBounds().width * 0.05),
            labelsStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: getScreenBounds().width * -0.05),
            labelsStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: margin),
            labelsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3, constant: -margin*3),
            
            mainLabel.infoSubLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            mainLabel.infoSubLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor, constant: -5),
            
            converterLabel.infoSubLabel.topAnchor.constraint(equalTo: converterLabel.bottomAnchor),
            converterLabel.infoSubLabel.trailingAnchor.constraint(equalTo: converterLabel.trailingAnchor, constant: -5),
        ]
        
        // Additional setups
        // add changeWordSizeButton to navigationBar title view(in center)
        navigationBar.items?.first?.titleView?.addSubview(changeWordSizeButton)
        changeWordSizeButton.center =  (navigationBar.items?.first?.titleView!.center)!

    }
    
    // MARK: - Calculated heights
    
    func getViewHeight() -> CGFloat {
        return UIScreen.main.bounds.height / 3 - 2
    }
    
    func getScreenBounds() -> CGRect {
        
        // caclculation for landscape and portrait orientations
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let width = screenWidth < screenHeight ? screenWidth : screenHeight
        let height = screenHeight > screenHeight ? screenHeight : screenWidth
        
        
        return CGRect(x: 0, y: 0, width: width, height: height)
    }

}




