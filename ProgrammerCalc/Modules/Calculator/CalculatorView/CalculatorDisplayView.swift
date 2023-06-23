//
//  CalculatorDisplayView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class CalculatorDisplayView: StyledView {
    
    // MARK: - Properties
    
    private let margin: CGFloat = 10
    private let navBarHeight: CGFloat = UIDevice.currentDeviceType == .iPad ? 50 : 44
    
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
    
    private let changeItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"),
                                                            style: .plain,
                                                            target: nil,
                                                            action: #selector(CalculatorView.changeConversionButtonTapped))
    private let keypadItem = UIBarButtonItem(image: UIImage(named: "keypadIcon-bitwise"),
                                                            style: .plain,
                                                            target: nil,
                                                            action: #selector(CalculatorView.switchKeypad))
    private let settingsItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                              style: .plain,
                                                              target: nil,
                                                              action: #selector(CalculatorView.settingsButtonTapped))
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func styleWillUpdate(with style: Style) {
        super.styleWillUpdate(with: style)
        updateStyle(with: style)
    }
    
    // MARK: - Methods
    
    func setViews() {
        self.backgroundColor = .clear
        self.frame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: getViewHeight())
        self.addSubview(navigationBar)
        self.addSubview(labelsStack)
        self.addSubview(mainLabel.infoSubLabel)
        self.addSubview(converterLabel.infoSubLabel)
        
        navigationBar.subviews.forEach({ $0.isExclusiveTouch = true })

        changeWordSizeButton.addTarget(nil, action: #selector(CalculatorView.changeWordSizeButtonTapped), for: .touchUpInside)
        
        setupLayout()
    }
    
    func updateStyle(with style: Style) {
        mainLabel.textColor = style.labelTextColor
        converterLabel.textColor = style.labelTextColor
        mainLabel.infoSubLabel.textColor = .systemGray
        converterLabel.infoSubLabel.textColor = .systemGray
        changeItem.tintColor = style.tintColor
        keypadItem.tintColor = style.tintColor
        settingsItem.tintColor = style.tintColor
        changeWordSizeButton.tintColor = style.tintColor
    }
    
    func hideConverterLabel() {
        mainLabel.isHidden = false
        converterLabel.infoSubLabel.isHidden = true
        converterLabel.isHidden = true

        mainLabel.font = mainLabel.font.withSize(82.0)
        mainLabel.numberOfLines = 2
    }
    
    func showConverterLabel() {
        mainLabel.isHidden = false
        converterLabel.infoSubLabel.isHidden = false
        converterLabel.isHidden = false
        
        mainLabel.font = mainLabel.font.withSize(70.0)
    }
    
    func freezeNavBar(by duration: CGFloat) {
        navigationBar.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
            self.navigationBar.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - Views
    
    lazy var changeWordSizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: navBarHeight * 2, height: navBarHeight)

        button.setTitle("\(WordSizeType.qword.title)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
        button.sizeToFit()
       
        button.accessibilityIdentifier = "ChangeWordSizeButton"
        
        return button
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let width = UIScreen.mainRealSize().width
        let frame = CGRect(
            x: self.windowSafeAreaInsets.left,
            y: self.windowSafeAreaInsets.top,
            width: width,
            height: navBarHeight
        )
        let navBar = UINavigationBar(frame: frame)
        let navItem = UINavigationItem()
        let font = UIFont.systemFont(ofSize: 42.0)
        settingsItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        navItem.leftBarButtonItems = [changeItem, keypadItem]
        navItem.rightBarButtonItem = settingsItem
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: navBarHeight * 2, height: navBarHeight))
        navItem.titleView = changeWordSizeButton

        navBar.setItems([navItem], animated: false)
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true

        return navBar
    }()
   
    // Label wich shows user input
    lazy var mainLabel: CalculatorLabel = {
        let label = CalculatorLabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.backgroundColor = .clear
        label.font = UIFont(name: label.fontName, size: 70.0)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        
        label.accessibilityIdentifier = "MainLabel"
        
        return label
    }()
    
    // Label wich shows converted values from user input
    lazy var converterLabel: CalculatorLabel = {
        let label = CalculatorLabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.font = UIFont(name: label.fontName, size: 70.0)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        
        label.accessibilityIdentifier = "ConverterLabel"

        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [mainLabel, converterLabel])
        labels.axis = .vertical
        labels.distribution = .fillEqually
        
        labels.spacing = mainLabel.infoSubLabel.frame.height
        
        return labels
    }()

    // MARK: - Layout
    
    private func setupLayout() {
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.infoSubLabel.translatesAutoresizingMaskIntoConstraints = false
        converterLabel.infoSubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for portrait orientation
        portrait = [
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
            labelsStack.topAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.topAnchor, constant: getScreenBounds().width * 0.05),
            labelsStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: getScreenBounds().width * 0.05),
            labelsStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: getScreenBounds().width * -0.05),
            labelsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85),
            
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
            labelsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3, constant: -margin * 3),
            
            mainLabel.infoSubLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            mainLabel.infoSubLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor, constant: -5),
            
            converterLabel.infoSubLabel.topAnchor.constraint(equalTo: converterLabel.bottomAnchor),
            converterLabel.infoSubLabel.trailingAnchor.constraint(equalTo: converterLabel.trailingAnchor, constant: -5),
        ]
    }
    
    // MARK: - Methods
    
    func showNavigationBar() {
        setNavigationBarIsHidden(false)
    }
    
    func hideNavigationBar() {
        setNavigationBarIsHidden(true)
    }
    
    func updateCnageWordSizeButton(with wordSize: WordSize) {
        self.changeWordSizeButton.setTitle(wordSize.value.title, for: .normal)
    }
    
    private func setNavigationBarIsHidden(_ isHidden: Bool) {
        navigationBar.isHidden = isHidden
    }
    
    // MARK: - Calculated heights
    
    func getViewHeight() -> CGFloat {
        return UIScreen.main.bounds.height / 3 - 2
    }
    
    func getScreenBounds() -> CGRect {
        return CGRect(origin: CGPoint(), size: UIScreen.mainRealSize())
    }
}
