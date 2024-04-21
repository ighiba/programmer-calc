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
    private let doneButtonHeight: CGFloat = PopoverDoneButton.defaultHeight
    private let containerCornerRadius: CGFloat = 24
    private let containerMinimalHeight: CGFloat = 400
    private let fractionalWidthLabelHeight: CGFloat = 35
    private var fractionalWidthLabelMaximumWidth: CGFloat { modalViewContainerWidth - (2 * margin) }
    
    private let titleString = NSLocalizedString("Conversion settings", comment: "")
    private let fractionalWidthFormat = NSLocalizedString("Max number of digits after point:  %d", comment: "")
    
    // MARK: - Views
    
    lazy var container = UIView(withCornerRadius: containerCornerRadius)
    lazy var conversionSystemsPicker = ConversionPicker(withArrowSymbol: true)
    lazy var doneButton: UIButton = PopoverDoneButton()
    lazy var fractionalWidthSlider = configureFractionalWidthSlider()
    private lazy var fractionalWidthLabel = configureFractionalWidthLabel(withText: fractionalWidthFormat)
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
    
    func setFractionalWidthLabel(value: Int) {
        fractionalWidthLabel.text = makeFractionalWidthLabelText(withValue: value)
    }
    
    private func makeFractionalWidthLabelText(withValue value: Int) -> String {
        return String(format: fractionalWidthFormat, value)
    }
    
    private func setupViews() {
        let blurredBackgroundView = configureBlurredBackgroundView()
        insertSubview(blurredBackgroundView, at: 0)
        
        addSubview(container)
        container.addSubview(contentStack)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        fractionalWidthLabel.translatesAutoresizingMaskIntoConstraints = false
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
            
            fractionalWidthLabel.heightAnchor.constraint(equalToConstant: fractionalWidthLabelHeight),
            fractionalWidthSlider.heightAnchor.constraint(equalToConstant: sliderHeight),
            
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight)
        ])
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        container.backgroundColor = .systemGray6
        conversionSystemsPicker.backgroundColor = .systemGray6
        titleLabel.textColor = .label
        fractionalWidthLabel.textColor = .label
        fractionalWidthSlider.tintColor = .systemGreen
    }
    
    // MARK: - Views Configuration
    
    private func configureFractionalWidthLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = makeFractionalWidthLabelText(withValue: 16)
        label.font = .systemFont(ofSize: 21, weight: .light)
        label.adjustFontSize(forWidth: fractionalWidthLabelMaximumWidth)
        label.textAlignment = .left
        return label
    }

    private func configureTitleLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
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
            fractionalWidthLabel,
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

extension UILabel {
    func adjustFontSize(forWidth maxWidth: CGFloat) {
        guard let text = self.text, let currentFont = self.font else { return }
        
        var textWidth = text.size(withAttributes: [.font : currentFont]).width

        guard textWidth > maxWidth else { return }
        
        var resultFontSize = currentFont.pointSize
        while textWidth > maxWidth, resultFontSize > 1 {
            resultFontSize -= 1
            textWidth = text.size(withAttributes: [.font : currentFont.withSize(resultFontSize)]).width
        }
        
        self.font = currentFont.withSize(resultFontSize)
    }
}
