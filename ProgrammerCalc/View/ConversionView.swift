//
//  ConversionView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()

    }

    func setViews() {
        //let screenWidth = UIScreen.main.bounds.width
        self.frame = UIScreen.main.bounds
        
        // TODO: Themes
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
        mainPicker.addSubview(arrow)
        container.addSubview(containerStack)
        self.addSubview(container)

        setupLayout()
    }
    
    // Update values for picker, label and slider
    func updateValues() {
        
    }
    
    // Setup layout
    func setupLayout() {
        //let screenWidth = UIScreen.main.bounds.width
        
        // Set constraints for main container
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55).isActive = true
        
        // Set constraints for done button
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        containerStack.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        containerStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.90).isActive = true
        containerStack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.90).isActive = true
        
        
        // Set constraints for picker
        mainPicker.translatesAutoresizingMaskIntoConstraints = false
        //mainPicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        mainPicker.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        // Set contraints for picker's arrow
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.centerYAnchor.constraint(equalTo: mainPicker.centerYAnchor).isActive = true
        arrow.centerXAnchor.constraint(equalTo: mainPicker.centerXAnchor).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 30).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Set constraints for digitsAfterLabel
        digitsAfterLabel.translatesAutoresizingMaskIntoConstraints = false
        digitsAfterLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        
        // Set contraints for done button
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate let container: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.layer.cornerRadius = 24

        return view
    }()
    
    // Done button for saving and dismissing vc
    fileprivate let doneButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 100)
        
        button.setTitle("Done", for: .normal)
        // TODO: Themes
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        
        button.addTarget(nil, action: #selector(ConversionViewController.doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // Picker for mainLabel
    fileprivate let mainPicker: ConversionPicker = {
        let picker = ConversionPicker()
        
        //picker.frame = CGRect(x: 0, y: 0, width: 414, height: 250)
        
        var model = [ConversionModel]()
        
        // Add to picker all systems
        // TODO: Refactor this for multiple systems
        model.append(ConversionModel(system: .bin))
        model.append(ConversionModel(system: .oct))
        model.append(ConversionModel(system: .dec))
        model.append(ConversionModel(system: .hex))
        
        picker.systemsModel = model
        
        picker.delegate = picker
        picker.dataSource = picker
        
        let selected = picker.selectedRow(inComponent: 0)
        //print(picker.pickerView(picker, titleForRow: selected, forComponent: 0))
        
        return picker
    }()
    
    // Picker for converterLabel
    fileprivate let converterPicker: ConversionPicker = {
        let picker = ConversionPicker()
        
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
        label.text = "Number of digits after point: "
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
        
        return label
    }()
    
    // Slider for changing number of digits after point
    fileprivate let digitsAfterSlider: UISlider = {
        let slider = UISlider()
        
        // TODO: Multiple values up to 32
        slider.minimumValue = 0
        slider.maximumValue = 16
        
        // Initial value
        slider.value = 8
        
        // TODO: Theme
        slider.tintColor = .systemGreen
        
        slider.addTarget(nil, action: #selector(ConversionViewController.sliderValueChanged), for: .valueChanged)
        
        return slider
    }()
    
    // stack with pickers, slider and button
    fileprivate lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainPicker,digitsAfterLabel,digitsAfterSlider,doneButton])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        let containerStackHeight = ((UIScreen.main.bounds.height * 0.55) * 0.9) * 0.9
        
        // spacings after picker and before button
        stack.setCustomSpacing(containerStackHeight * 0.1, after: self.mainPicker)
        stack.setCustomSpacing(containerStackHeight * 0.1, after: self.digitsAfterSlider)
        
        return stack
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
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
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
            print("completed")
            // dismiss vc
            finished()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
