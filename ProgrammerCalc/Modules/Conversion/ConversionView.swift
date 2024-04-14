//
//  ConversionView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

final class ConversionView: UIView, ModalView {
    
    // MARK: - Properties
    
    private let margin: CGFloat = 18
    private let verticalSpacing: CGFloat = 10
    private let sliderHeight: CGFloat = 50
    private let labelStackHeight: CGFloat = 35
    private let doneButtonHeight: CGFloat = PopoverDoneButton.defaultHeight
    private let containerCornerRadius: CGFloat = 24
    private let containerMinimalHeight: CGFloat = 400
    
    private let titleString = NSLocalizedString("Conversion settings", comment: "")
    private let fractionalTitleString = NSLocalizedString("Max number of digits after point: ", comment: "")
    
    // MARK: - Views
    
    lazy var container = UIView(withCornerRadius: containerCornerRadius)
    lazy var conversionSystemsPicker = ConversionPicker(withArrowSymbol: true)
    lazy var doneButton: UIButton = PopoverDoneButton()
    lazy var fractionalLabelsStack = configureFractionalLabelsStack()
    lazy var fractionalWidthLabel = configureFractionalWidthLabel()
    lazy var fractionalWidthSlider = configureFractionalWidthSlider()
    private lazy var fractionalWidthTitle = configureFractionalWidthTitleLabel(withText: fractionalTitleString)
    private lazy var titleLabel = configureTitleLabel(withText: titleString)
    private lazy var contentStack = configureContentStack()
    
    // MARK: - Init
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.setupViews()
        self.setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        let blurredBackgroundView = configureBlurredBackgroundView()
        insertSubview(blurredBackgroundView, at: 0)
        
        addSubview(container)
        container.addSubview(contentStack)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        fractionalLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        fractionalWidthSlider.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: modalViewContainerWidth),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: containerMinimalHeight),
            
            contentStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: margin),
            contentStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -margin),
            contentStack.topAnchor.constraint(equalTo: container.topAnchor, constant: margin),
            contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -margin),
            
            fractionalLabelsStack.heightAnchor.constraint(equalToConstant: labelStackHeight),
            fractionalWidthTitle.widthAnchor.constraint(equalTo: fractionalLabelsStack.widthAnchor, multiplier: 0.9),
            fractionalWidthLabel.widthAnchor.constraint(equalTo: fractionalLabelsStack.widthAnchor, multiplier: 0.1),
            
            fractionalWidthSlider.heightAnchor.constraint(equalToConstant: sliderHeight),
            
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight)
        ])
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        
        container.backgroundColor = .systemGray6

        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)

        conversionSystemsPicker.backgroundColor = .systemGray6
        
        fractionalWidthTitle.textColor = .label
        fractionalWidthTitle.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        fractionalWidthLabel.textColor = .label
        fractionalWidthLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        fractionalWidthSlider.tintColor = .systemGreen
    }
    
    // MARK: - Views Configuration
    
    private func configureFractionalLabelsStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [fractionalWidthTitle, fractionalWidthLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }
    
    private func configureTitleLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        return label
    }
    
    private func configureFractionalWidthTitleLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        return label
    }
    
    private func configureFractionalWidthLabel() -> UILabel {
        let label = UILabel()
        label.text = "8"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }
    
    private func configureFractionalWidthSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 4
        slider.value = 3
        return slider
    }
    
    private func configureContentStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            conversionSystemsPicker,
            fractionalLabelsStack,
            fractionalWidthSlider,
            doneButton
        ])
        
        stack.axis = .vertical
        
        return stack
    }
}

extension UIView {
    convenience init(withCornerRadius cornerRadius: CGFloat) {
        self.init()
        self.layer.cornerRadius = cornerRadius
    }
}
