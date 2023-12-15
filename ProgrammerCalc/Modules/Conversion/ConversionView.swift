//
//  ConversionView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

private let verticalSpacing: CGFloat = 10
private let arrowSymbolWidth: CGFloat = 30
private let labelStackHeight: CGFloat = 35
private let doneButtonHeight: CGFloat = PopoverDoneButton.defaultHeight
private let containerItemsWidthMultiplier: CGFloat = 0.9
private let containerCornerRadius: CGFloat = 24
private let containerMinimalHeight: CGFloat = 400

final class ConversionView: UIView, ModalView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.setupView()
        self.setupLayout()
        self.setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setupView() {
        let blurredBackgroundView = configureBlurredBackgroundView()
        insertSubview(blurredBackgroundView, at: 0)
        
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(conversionSystemsPicker)
        container.addSubview(fractionalLabelsStack)
        container.addSubview(fractionalWidthSlider)
        container.addSubview(doneButton)
        container.bringSubviewToFront(titleLabel)
        
        conversionSystemsPicker.addSubview(arrowSymbol)
    }
    
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        conversionSystemsPicker.translatesAutoresizingMaskIntoConstraints = false
        arrowSymbol.translatesAutoresizingMaskIntoConstraints = false
        fractionalLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        fractionalWidthTitle.translatesAutoresizingMaskIntoConstraints = false
        fractionalWidthLabel.translatesAutoresizingMaskIntoConstraints = false
        fractionalWidthSlider.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: verticalSpacing),
            titleLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.1),
            titleLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),

            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: modalViewContainerWidth),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: containerMinimalHeight),

            conversionSystemsPicker.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            conversionSystemsPicker.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 2 * verticalSpacing),
            conversionSystemsPicker.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.52),
            conversionSystemsPicker.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),

            arrowSymbol.centerYAnchor.constraint(equalTo: conversionSystemsPicker.centerYAnchor),
            arrowSymbol.centerXAnchor.constraint(equalTo: conversionSystemsPicker.centerXAnchor),
            arrowSymbol.widthAnchor.constraint(equalToConstant: arrowSymbolWidth),
            arrowSymbol.heightAnchor.constraint(equalToConstant: arrowSymbolWidth),

            fractionalLabelsStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            fractionalLabelsStack.topAnchor.constraint(equalTo: conversionSystemsPicker.bottomAnchor),
            fractionalLabelsStack.heightAnchor.constraint(equalToConstant: labelStackHeight),
            fractionalLabelsStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),
            
            fractionalWidthTitle.widthAnchor.constraint(equalTo: fractionalLabelsStack.widthAnchor, multiplier: containerItemsWidthMultiplier),
            
            fractionalWidthLabel.widthAnchor.constraint(equalTo: fractionalLabelsStack.widthAnchor, multiplier: 0.1),
            
            fractionalWidthSlider.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            fractionalWidthSlider.topAnchor.constraint(equalTo: fractionalLabelsStack.bottomAnchor, constant: verticalSpacing),
            fractionalWidthSlider.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -verticalSpacing * 1.7),
            fractionalWidthSlider.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),

            doneButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -verticalSpacing * 1.7),
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight),
            doneButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),
        ])
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        
        container.backgroundColor = .systemGray6

        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)

        conversionSystemsPicker.backgroundColor = .systemGray6
        
        arrowSymbol.textColor = .label
        arrowSymbol.font = UIFont(name: "HelveticaNeue-Thin", size: 22.0)
        
        fractionalWidthTitle.textColor = .label
        fractionalWidthTitle.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        fractionalWidthLabel.textColor = .label
        fractionalWidthLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        fractionalWidthSlider.tintColor = .systemGreen
    }
    
    // MARK: - Views
    
    let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = containerCornerRadius
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Conversion settings", comment: "")
        label.textAlignment = .center
        return label
    }()
    
    let conversionSystemsPicker: ConversionPicker = {
        let picker = ConversionPicker()
        picker.delegate = picker
        picker.dataSource = picker
        return picker
    }()
    
    private let arrowSymbol: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: arrowSymbolWidth, height: arrowSymbolWidth))
        label.text = "→"
        label.textAlignment = .center
        return label
    }()
    
    lazy var fractionalLabelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fractionalWidthTitle, fractionalWidthLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }()
    
    private let fractionalWidthTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Max number of digits after point: ", comment: "")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        return label
    }()

    let fractionalWidthLabel: UILabel = {
        let label = UILabel()
        label.text = "8"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()

    let fractionalWidthSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 4
        slider.value = 3
        return slider
    }()

    var doneButton: UIButton = {
        return PopoverDoneButton()
    }()
}
