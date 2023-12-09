//
//  ClearButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

final class ClearButton: CalculatorButton_ {
    
    enum State: String {
        case inputNotStarted = "AC"
        case inputStarted = "C"
    }

    var buttonState: ClearButton.State = .inputNotStarted {
        didSet {
            setTitle(buttonState.rawValue, for: .normal)
        }
    }

    override func setupButton() {
        setTitle(buttonState.rawValue, for: .normal)
        
        tag = clearButtonTag
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.clearButtonDidPress), for: .touchUpInside)
    }
    
    override func calculateFontSize() -> CGFloat {
        return buttonWidth / 2
    }
    
    func changeButtonTitle(_ buttonState: ClearButton.State) {
        self.buttonState = buttonState
    }
}
