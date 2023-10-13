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

class ConversionView: UIView, ModalView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setupView() {
        let blurredBackgroundView = makeBlurredBackgroundView()
        insertSubview(blurredBackgroundView, at: 0)
        
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(numberSystemsPicker)
        container.addSubview(sliderLabelsStack)
        container.addSubview(slider)
        container.addSubview(doneButton)
        container.bringSubviewToFront(titleLabel)
        
        numberSystemsPicker.addSubview(arrowSymbol)
    }
    
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        numberSystemsPicker.translatesAutoresizingMaskIntoConstraints = false
        arrowSymbol.translatesAutoresizingMaskIntoConstraints = false
        sliderLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        sliderTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
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

            numberSystemsPicker.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            numberSystemsPicker.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 2 * verticalSpacing),
            numberSystemsPicker.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.52),
            numberSystemsPicker.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),

            arrowSymbol.centerYAnchor.constraint(equalTo: numberSystemsPicker.centerYAnchor),
            arrowSymbol.centerXAnchor.constraint(equalTo: numberSystemsPicker.centerXAnchor),
            arrowSymbol.widthAnchor.constraint(equalToConstant: arrowSymbolWidth),
            arrowSymbol.heightAnchor.constraint(equalToConstant: arrowSymbolWidth),

            sliderLabelsStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            sliderLabelsStack.topAnchor.constraint(equalTo: numberSystemsPicker.bottomAnchor),
            sliderLabelsStack.heightAnchor.constraint(equalToConstant: labelStackHeight),
            sliderLabelsStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),
            
            sliderTitleLabel.widthAnchor.constraint(equalTo: sliderLabelsStack.widthAnchor, multiplier: containerItemsWidthMultiplier),
            
            sliderValueLabel.widthAnchor.constraint(equalTo: sliderLabelsStack.widthAnchor, multiplier: 0.1),
            
            slider.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            slider.topAnchor.constraint(equalTo: sliderLabelsStack.bottomAnchor, constant: verticalSpacing),
            slider.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -verticalSpacing * 1.7),
            slider.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerItemsWidthMultiplier),

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

        numberSystemsPicker.backgroundColor = .systemGray6
        
        arrowSymbol.textColor = .label
        arrowSymbol.font = UIFont(name: "HelveticaNeue-Thin", size: 22.0)
        
        sliderTitleLabel.textColor = .label
        sliderTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        sliderValueLabel.textColor = .label
        sliderValueLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        slider.tintColor = .systemGreen
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
    
    let numberSystemsPicker: ConversionPicker = {
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
    
    lazy var sliderLabelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sliderTitleLabel, sliderValueLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }()
    
    private let sliderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Max number of digits after point: ", comment: "")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        return label
    }()

    let sliderValueLabel: UILabel = {
        let label = UILabel()
        label.text = "8"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()

    let slider: UISlider = {
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
