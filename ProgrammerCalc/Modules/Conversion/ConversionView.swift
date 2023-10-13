//
//  ConversionView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionView: UIView, ModalView {
    
    private let margin: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    func setViews() {
        self.frame = UIScreen.main.bounds
        
        self.backgroundColor = .clear

        self.addSubview(container)
        container.addSubview(popoverTitle)
        container.addSubview(mainPicker)
        mainPicker.addSubview(arrow)
        container.addSubview(labelStack)
        container.addSubview(digitsAfterSlider)
        container.addSubview(doneButton)
        
        container.bringSubviewToFront(popoverTitle)
        
        setupLayout()
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 0)
    }
    
    // Setup layout
    func setupLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        popoverTitle.translatesAutoresizingMaskIntoConstraints = false
        mainPicker.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        sliderValueDigit.translatesAutoresizingMaskIntoConstraints = false
        digitsAfterLabel.translatesAutoresizingMaskIntoConstraints = false
        digitsAfterSlider.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate([
            // Set constraints for main container
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: modalViewContainerWidth),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),
            
            // Set constraints for label
            popoverTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: margin),
            popoverTitle.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.1),
            popoverTitle.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            popoverTitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            // Set constraints for picker
            mainPicker.topAnchor.constraint(equalTo: popoverTitle.topAnchor, constant: 2 * margin),
            mainPicker.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.52),
            mainPicker.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            mainPicker.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            // Set contraints for picker's arrow
            arrow.centerYAnchor.constraint(equalTo: mainPicker.centerYAnchor),
            arrow.centerXAnchor.constraint(equalTo: mainPicker.centerXAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 30),
            arrow.heightAnchor.constraint(equalToConstant: 30),
            
            // Set constraints for digitsAfterLabel
            labelStack.topAnchor.constraint(equalTo: mainPicker.bottomAnchor),
            labelStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            labelStack.heightAnchor.constraint(equalToConstant: 35),
            labelStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            
            digitsAfterLabel.widthAnchor.constraint(equalTo: labelStack.widthAnchor, multiplier: 0.9),
            sliderValueDigit.widthAnchor.constraint(equalTo: labelStack.widthAnchor, multiplier: 0.1),
            
            // Set constraints for slider
            digitsAfterSlider.topAnchor.constraint(equalTo: labelStack.bottomAnchor, constant: margin),
            digitsAfterSlider.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -margin * 1.7),
            digitsAfterSlider.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            digitsAfterSlider.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            // Set contraints for done button
            doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -margin * 1.7),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            doneButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        ])
    }
    
    let container: UIView = {
        let view = UIView()

        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 24

        return view
    }()
    
    // Done button for saving and dismissing vc
    var doneButton: UIButton = {
        return PopoverDoneButton()
    }()
    
    // Popover title
    fileprivate let popoverTitle: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("Conversion settings", comment: "")
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        
        return label
    }()
    
    // Picker for mainLabel
    let mainPicker: ConversionPicker = {
        let picker = ConversionPicker()
        
        picker.delegate = picker
        picker.dataSource = picker
        
        picker.backgroundColor = .systemGray6
        
        let selected = picker.selectedRow(inComponent: 0)
        
        return picker
    }()
    
    // Dummy spacer for mainPicker components
    fileprivate let arrow: UILabel = {
        let label = UILabel()

        label.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        label.text = "→"
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 22.0)
        label.textAlignment = .center
        label.textColor = .label
        
        return label
    }()
    
    // Label with info of current digits after point
    fileprivate let digitsAfterLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.text = NSLocalizedString("Max number of digits after point: ", comment: "")
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.15
        label.textColor = .label
        
        return label
    }()
    
    // Label for showing current value of the slider
    let sliderValueDigit: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        // default value
        label.text = "8"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.textColor = .label
        
        return label
    }()
    
    // Stack for label
    lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [digitsAfterLabel, sliderValueDigit])
        stack.axis = .horizontal
        stack.alignment = .fill
        
        return stack
    }()
    
    // Slider for changing number of digits after point
    let digitsAfterSlider: UISlider = {
        let slider = UISlider()
        
        slider.minimumValue = 1
        slider.maximumValue = 4
        
        // Initial value
        slider.value = 3
        
        slider.tintColor = .systemGreen
        
        return slider
    }()
    
    // Animation for presenting view
    func animateIn() {
        let moveUp = CGAffineTransform(translationX: 0, y: -300)
        let scaleDown = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let transform = scaleDown.concatenating(moveUp)

        // preparing container for animation
        // making it hidden
        self.container.transform = transform
        self.alpha = 0
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        }, completion: nil)
    }


    // Animation for dismissing view
    func animateOut(completion: @escaping () -> Void) {
        // transforms for concatenating
        let moveUp = CGAffineTransform(translationX: 0, y: -300)
        let scaleDown = CGAffineTransform(scaleX: 0.01, y: 0.01)

        let transform = scaleDown.concatenating(moveUp)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.container.transform = transform
            self.container.alpha = 0.01
            self.alpha = 0
        }, completion: { _ in
            // dismiss vc
            completion()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
