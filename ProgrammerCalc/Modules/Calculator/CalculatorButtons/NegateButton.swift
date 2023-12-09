//
//  NegateButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

final class NegateButton: CalculatorButton_ {
    override func setupButton() {
        setTitle("±", for: .normal)
        
        tag = negateButtonTag
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.negateButtonDidPress), for: .touchUpInside)
    }
}
