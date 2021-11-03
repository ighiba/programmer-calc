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
        self.frame = UIScreen.main.bounds

        self.backgroundColor = .clear
        
        container.addSubview(containerStack)
        self.addSubview(container)

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
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            container.heightAnchor.constraint(equalToConstant: containerStackHeight+margin*2),
            
            // Set constraints for done button
            containerStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            containerStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.90),
            containerStack.heightAnchor.constraint(equalToConstant: containerStackHeight),
        ])
    }
    
    let container: UIView = {
        let view = UIView()

        view.backgroundColor = .systemGray6
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
        let button = PopoverDoneButton(frame: CGRect())
        
        button.addTarget(nil, action: #selector(WordSizeViewController.doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // Popover title
    fileprivate let popoverTitle: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("Change word size", comment: "")
        label.textColor = .label
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
        }, completion: { _ in
            // dismiss vc
            finished()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

