//
//  SignedButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

final class SignedButton: CalculatorButton {
    
    enum State: String {
        case on = "Signed\nON"
        case off = "Signed\nOFF"
    }
    
    var buttonState: SignedButton.State = .off {
        didSet {
            setTitle(buttonState.rawValue, for: .normal)
        }
    }
    
    // MARK: - Methods
    
    override func setupButton() {
        setTitle(buttonState.rawValue, for: .normal)
        
        tag = signedButtonTag
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.signedButtonDidPress), for: .touchUpInside)
    }
    
    func changeButtonTitle(_ buttonState: SignedButton.State) {
        self.buttonState = buttonState
    }
}
