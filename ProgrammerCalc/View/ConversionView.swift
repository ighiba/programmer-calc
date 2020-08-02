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
        let screenWidth = UIScreen.main.bounds.width
        
        self.backgroundColor = .red
        
        // set main view corners
        self.layer.cornerRadius = screenWidth / 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Set navigation bar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let navItem = UINavigationItem(title: "Change conversion")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(ConversionViewController.doneButtonTapped))
        // add done button to navigation item
        navItem.rightBarButtonItem = doneItem
        // set navigation items
        navBar.setItems([navItem], animated: false)
        // set round top corners
        navBar.layer.cornerRadius = screenWidth / 10
        navBar.clipsToBounds = true
        navBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
        self.addSubview(navBar)
        
        //
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
