//
//  CalculateButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

final class CalculateButton: CalculatorButton_ {
    
    override var buttonStyleType: ButtonStyleType { .action }
    
    override func setupButton() {
        setTitle("=", for: .normal)
        
        contentVerticalAlignment = .top
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.calculateButtonDidPress), for: .touchUpInside)
    }
}
