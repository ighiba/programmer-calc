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
        self.frame = UIScreen.main.bounds
        
        // TODO: Themes
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
        container.addSubview(doneButton)
        self.addSubview(container)

        setupLayout()
    }
    
    func setupLayout() {
        
        // Set constraints for main container
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        // Set constraints for done button
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate let container : UIView = {
        let view = UIView()
        
        view.backgroundColor = .red
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: #selector(ConversionViewController.doneButtonTapped2), for: .touchUpInside)
        
        return button
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
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    
    // Animation for dismissing view
    func animateOut( finished: @escaping () -> Void) {
        // transforms for concatenating
        let moveUp = CGAffineTransform(translationX: 0, y: -300)
        let scaleDown = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        let transform = scaleDown.concatenating(moveUp)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
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
