//
//  ConversionView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionView: UIView {
    
    private let margin: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    func setViews() {
        self.frame = UIScreen.main.bounds
        
        // TODO: Themes
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)

        self.addSubview(container)
        container.addSubview(popoverTitle)
        container.addSubview(mainPicker)
        mainPicker.addSubview(arrow)
        container.addSubview(digitsAfterLabel)
        digitsAfterLabel.addSubview(sliderValueDigit)
        container.addSubview(digitsAfterSlider)
        container.addSubview(doneButton)

        setupLayout()
    }
    
    
    // Setup layout
    func setupLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        popoverTitle.translatesAutoresizingMaskIntoConstraints = false
        mainPicker.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        sliderValueDigit.translatesAutoresizingMaskIntoConstraints = false
        digitsAfterLabel.translatesAutoresizingMaskIntoConstraints = false
        digitsAfterSlider.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate([
            // Set constraints for main container
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.57),
            
            // Set constraints for label
            popoverTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: margin),
            popoverTitle.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.1),
            popoverTitle.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            popoverTitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            
            // Set constraints for picker
            mainPicker.topAnchor.constraint(equalTo: popoverTitle.topAnchor, constant: 2*margin),
            mainPicker.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.52),
            mainPicker.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            mainPicker.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            // Set contraints for picker's arrow
            arrow.centerYAnchor.constraint(equalTo: mainPicker.centerYAnchor),
            arrow.centerXAnchor.constraint(equalTo: mainPicker.centerXAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 30),
            arrow.heightAnchor.constraint(equalToConstant: 30),
            
            // Set constraints for digitsAfterLabel
            digitsAfterLabel.topAnchor.constraint(equalTo: mainPicker.bottomAnchor),
            digitsAfterLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -margin),
            digitsAfterLabel.heightAnchor.constraint(equalToConstant: 35),
            // and slider value
            sliderValueDigit.topAnchor.constraint(equalTo: digitsAfterLabel.topAnchor),
            sliderValueDigit.bottomAnchor.constraint(equalTo: digitsAfterLabel.bottomAnchor),
            sliderValueDigit.leftAnchor.constraint(equalTo: digitsAfterLabel.rightAnchor, constant: margin),
            sliderValueDigit.heightAnchor.constraint(equalTo: digitsAfterLabel.heightAnchor),
            
            // Set constraints for slider
            digitsAfterSlider.topAnchor.constraint(equalTo: digitsAfterLabel.bottomAnchor),
            digitsAfterSlider.bottomAnchor.constraint(equalTo: doneButton.topAnchor),
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

        view.backgroundColor = .white
        view.layer.cornerRadius = 24

        return view
    }()
    
    // Done button for saving and dismissing vc
    fileprivate let doneButton: UIButton = {
        let button = PopoverDoneButton(frame: CGRect())
        
        button.addTarget(nil, action: #selector(ConversionViewController.doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // Popover title
    fileprivate let popoverTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Conversion settings"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    // Picker for mainLabel
    let mainPicker: ConversionPicker = {
        let picker = ConversionPicker()
        
        picker.delegate = picker
        picker.dataSource = picker
        
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
        
        return label
    }()
    
    // Label with info of current digits after point
    fileprivate let digitsAfterLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.text = "Max number of digits after point: "
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        //label.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
        
        return label
    }()
    
    // Label for showing current value of the slider
    let sliderValueDigit: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        // default value
        label.text = "8"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    // Slider for changing number of digits after point
    let digitsAfterSlider: UISlider = {
        let slider = UISlider()
        
        // TODO: Multiple values up to 16 ( 1 * 4 = 4 digits after point etc)
        slider.minimumValue = 1
        slider.maximumValue = 4
        
        // Initial value
        slider.value = 3
        
        // TODO: Theme
        slider.tintColor = .systemGreen
        
        slider.addTarget(nil, action: #selector(ConversionViewController.sliderValueChanged), for: .valueChanged)
        
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
    func animateOut( finished: @escaping () -> Void) {
        // transforms for concatenating
        let moveUp = CGAffineTransform(translationX: 0, y: -300)
        let scaleDown = CGAffineTransform(scaleX: 0.01, y: 0.01)

        let transform = scaleDown.concatenating(moveUp)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.container.transform = transform
            self.container.alpha = 0.01
            self.alpha = 0
        }, completion: { (completed) in
            //print("completed")
            // dismiss vc
            finished()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
