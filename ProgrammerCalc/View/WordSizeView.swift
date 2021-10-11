//
//  WordSizeView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class WordSizeView: UIView {
    
    let margin: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    func setViews() {
        //let screenWidth = UIScreen.main.bounds.width
        self.frame = UIScreen.main.bounds
        
        // TODO: Themes
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
//        mainPicker.addSubview(arrow)
        container.addSubview(containerStack)
        self.addSubview(container)

        setupLayout()
    }
    
    
    // Setup layout
    func setupLayout() {
        //let screenWidth = UIScreen.main.bounds.width
        let popoverTitleHeight: CGFloat = (popoverTitle.font.pointSize+1)
        let tableRowHeight: CGFloat = 44
        let doneButtonHeight: CGFloat = 50
        // calculate container stack height
        let containerStackHeight: CGFloat =  popoverTitleHeight + margin*2 + tableRowHeight*4 + doneButtonHeight
        
        popoverTitle.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        wordSizeTable.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        // Activate constraints
        NSLayoutConstraint.activate([
            popoverTitle.heightAnchor.constraint(equalToConstant: popoverTitleHeight),
            
            // Set constraints for table
            wordSizeTable.heightAnchor.constraint(equalToConstant: tableRowHeight*4),
            
            // Set contraints for done button
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight),
            
            // Set constraints for main container
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //container.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: (self.frame.height/8) * -1),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            //container.centerYAnchor.constrain(equalTo: self.centerXAnchor, multiplier: -0.2),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            //container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.47),
            container.heightAnchor.constraint(equalToConstant: containerStackHeight+margin*2),
            
            // Set constraints for done button
            containerStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            containerStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.90),
            //containerStack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.90),
            containerStack.heightAnchor.constraint(equalToConstant: containerStackHeight),
            
//            // Set constraints for main container
//            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            //container.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: (self.frame.height/8) * -1),
//            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            //container.centerYAnchor.constrain(equalTo: self.centerXAnchor, multiplier: -0.2),
//            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
//            //container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.47),
//            container.heightAnchor.constraint(equalToConstant: containerStackHeight+margin*2),
//
//            // Set constraints for label
//            popoverTitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            popoverTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: margin),
//            popoverTitle.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
//            popoverTitle.heightAnchor.constraint(equalToConstant: popoverTitleHeight),
//
//            // Set constraints for table
//            wordSizeTable.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            wordSizeTable.topAnchor.constraint(equalTo: popoverTitle.bottomAnchor, constant: margin),
//            wordSizeTable.heightAnchor.constraint(equalToConstant: tableRowHeight*4),
//            wordSizeTable.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
//
//            // Set contraints for done button
//            doneButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            doneButton.topAnchor.constraint(equalTo: wordSizeTable.bottomAnchor, constant: margin),
//            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight),
//            doneButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),

        ])
    }
    
    let container: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.layer.cornerRadius = 24

        return view
    }()
    
    // Table view with word sizes
    let wordSizeTable: UITableView = {
        let table = UITableView(frame: CGRect(), style: .plain)
        
        // disable scrolling
        table.isScrollEnabled = false
        
        return table
    }()
    
    // Done button for saving and dismissing vc
    fileprivate let doneButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 100)
        
        button.setTitle("Done", for: .normal)
        // TODO: Themes
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        
        button.addTarget(nil, action: #selector(WordSizeViewController.doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // Popover title
    fileprivate let popoverTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Change word size"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    // stack with title and table. done button
    fileprivate lazy var containerStack: UIStackView = {
        // form stack with views
        let stack = UIStackView(arrangedSubviews: [popoverTitle,wordSizeTable,doneButton])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        let containerStackHeight = ((UIScreen.main.bounds.height * 0.55) * 0.9) * 0.9
        
        // Custom spacings
        // after label
        stack.setCustomSpacing(margin, after: self.popoverTitle)
        // after table
        stack.setCustomSpacing(margin, after: self.wordSizeTable)
//        // after slider label
//        stack.setCustomSpacing(containerStackHeight * 0.05, after: self.horizontalInfoStack)
//        // after slider
//        stack.setCustomSpacing(containerStackHeight * 0.1, after: self.digitsAfterSlider)
        
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
