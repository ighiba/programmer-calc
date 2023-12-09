//
//  DotButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

final class DotButton: CalculatorButton_ {
    
    override var buttonStyleType: ButtonStyleType { .numeric }
    
    override func setupButton() {
        setTitle(".", for: .normal)
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.dotButtonDidPress), for: .touchUpInside)
    }
}
