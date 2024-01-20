//
//  CalculatorView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

final class CalculatorView: StyledView {
    
    // MARK: - Properties
    
    private let verticalSpacing: CGFloat = 10
    private let horizontalSpacing: CGFloat = -5
    private let navBarHeight: CGFloat = UIDevice.current.deviceType == .iPad ? 50 : 44
    
    var screenBounds: CGRect { CGRect(origin: .zero, size: UIScreen.main.portraitSize) }
    
    var verticalOffsetFromTop: CGFloat { screenBounds.height / 3 - 2 }
    
    var portrait: [NSLayoutConstraint]?
    var landscape: [NSLayoutConstraint]?
    var landscapeWithBitKeypad: [NSLayoutConstraint]?
    
    let windowSafeAreaInsets: UIEdgeInsets = {
        if let window = UIApplication.shared.windows.first {
            return window.safeAreaInsets
        } else {
            return UIEdgeInsets()
        }
    }()
    
    private let changeItem = UIBarButtonItem(
        image: UIImage(systemName: "arrow.up.arrow.down.circle"),
        style: .plain,
        target: nil,
        action: #selector(CalculatorViewController.changeConversionButtonDidPress)
    )
    
    private let keypadItem = UIBarButtonItem(
        image: UIImage(named: "keypadIcon-bitwise"),
        style: .plain,
        target: nil,
        action: #selector(CalculatorViewController.switchKeypadButtonDidPress)
    )
    
    private let settingsItem = UIBarButtonItem(
        image: UIImage(systemName: "gearshape"),
        style: .plain,
        target: nil,
        action: #selector(CalculatorViewController.settingsButtonDidPress)
    )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func styleWillUpdate(with style: Style) {
        super.styleWillUpdate(with: style)
        
        updateStyle(with: style)
    }
    
    // MARK: - Methods
    
    func setupView() {
        backgroundColor = .clear
        addSubview(navigationBar)
        addSubview(labelsStack)
        addSubview(inputLabel.conversionSystemLabel)
        addSubview(outputLabel.conversionSystemLabel)
        
        navigationBar.subviews.forEach { $0.isExclusiveTouch = true }
        
        setupLayout()
    }
    
    private func setupLayout() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.conversionSystemLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.conversionSystemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        portrait = [
            navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: navBarHeight),
            
            labelsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: self.topAnchor, constant: verticalOffsetFromTop + verticalSpacing),
            labelsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95),
            labelsStack.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            
            inputLabel.conversionSystemLabel.topAnchor.constraint(equalTo: inputLabel.bottomAnchor),
            inputLabel.conversionSystemLabel.trailingAnchor.constraint(equalTo: inputLabel.trailingAnchor, constant: horizontalSpacing),
            
            outputLabel.conversionSystemLabel.topAnchor.constraint(equalTo: outputLabel.bottomAnchor),
            outputLabel.conversionSystemLabel.trailingAnchor.constraint(equalTo: outputLabel.trailingAnchor, constant: horizontalSpacing),
        ]
        
        landscape = [
            labelsStack.topAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.topAnchor, constant: screenBounds.width * 0.05),
            labelsStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: screenBounds.width * 0.05),
            labelsStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: screenBounds.width * -0.05),
            labelsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85),
            
            inputLabel.conversionSystemLabel.topAnchor.constraint(equalTo: inputLabel.bottomAnchor),
            inputLabel.conversionSystemLabel.trailingAnchor.constraint(equalTo: inputLabel.trailingAnchor, constant: horizontalSpacing),
            
            outputLabel.conversionSystemLabel.topAnchor.constraint(equalTo: outputLabel.bottomAnchor),
            outputLabel.conversionSystemLabel.trailingAnchor.constraint(equalTo: outputLabel.trailingAnchor, constant: horizontalSpacing),
        ]
        
        landscapeWithBitKeypad = [
            labelsStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: screenBounds.width * 0.05),
            labelsStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: screenBounds.width * -0.05),
            labelsStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing),
            labelsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3, constant: -verticalSpacing * 3),
            
            inputLabel.conversionSystemLabel.topAnchor.constraint(equalTo: inputLabel.bottomAnchor),
            inputLabel.conversionSystemLabel.trailingAnchor.constraint(equalTo: inputLabel.trailingAnchor, constant: horizontalSpacing),
            
            outputLabel.conversionSystemLabel.topAnchor.constraint(equalTo: outputLabel.bottomAnchor),
            outputLabel.conversionSystemLabel.trailingAnchor.constraint(equalTo: outputLabel.trailingAnchor, constant: horizontalSpacing),
        ]
    }
    
    private func setupGestures() {
        changeWordSizeButton.addTarget(nil, action: #selector(CalculatorViewController.changeWordSizeButtonDidPress), for: .touchUpInside)
    }
    
    func updateStyle(with style: Style) {
        inputLabel.textColor = style.labelTextColor
        outputLabel.textColor = style.labelTextColor
        inputLabel.conversionSystemLabel.textColor = .systemGray
        outputLabel.conversionSystemLabel.textColor = .systemGray
        changeItem.tintColor = style.tintColor
        keypadItem.tintColor = style.tintColor
        settingsItem.tintColor = style.tintColor
        changeWordSizeButton.tintColor = style.tintColor
    }
    
    func showOutputLabel() {
        inputLabel.isHidden = false
        outputLabel.isHidden = false
        outputLabel.conversionSystemLabel.isHidden = false
        
        inputLabel.font = inputLabel.font.withSize(70.0)
    }
    
    func hideOutputLabel() {
        inputLabel.isHidden = false
        outputLabel.isHidden = true
        outputLabel.conversionSystemLabel.isHidden = true

        inputLabel.font = inputLabel.font.withSize(82.0)
        inputLabel.numberOfLines = 2
    }
    
    func freezeNavigationBar(duration: TimeInterval) {
        navigationBar.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak self] _ in
            self?.navigationBar.isUserInteractionEnabled = true
        })
    }
    
    func showNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        setNavigationBar(isHidden: false)
    }
    
    func hideNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = true
        setNavigationBar(isHidden: true)
    }
    
    func setWordSizeButtonTitle(_ title: String) {
        changeWordSizeButton.setTitle(title, for: .normal)
    }
    
    private func setNavigationBar(isHidden: Bool) {
        navigationBar.isHidden = isHidden
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
        let width = UIScreen.main.portraitSize.width
        let frame = CGRect(
            x: 0,
            y: 0,
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
    
    lazy var labelsStack: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [inputLabel, outputLabel])
        labels.axis = .vertical
        labels.distribution = .fillEqually
        
        labels.spacing = inputLabel.conversionSystemLabel.frame.height
        
        return labels
    }()
    
    lazy var inputLabel: CalculatorLabel = {
        let label = CalculatorLabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.backgroundColor = .clear
        label.font = .calculatorLabelFont
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        
        label.accessibilityIdentifier = "InputLabel"
        
        return label
    }()
    
    lazy var outputLabel: CalculatorLabel = {
        let label = CalculatorLabel()
        
        label.frame = CGRect()
        label.text = "0"
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.font = .calculatorLabelFont
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        
        label.accessibilityIdentifier = "OutputLabel"

        return label
    }()
}
