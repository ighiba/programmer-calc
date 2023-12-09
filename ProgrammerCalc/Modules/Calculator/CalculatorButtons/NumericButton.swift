//
//  NumericButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

final class NumericButton: CalculatorButton_ {
    
    enum Digit {
        case single(Character)
        case double(Character, Character)
        
        fileprivate var title: String {
            switch self {
            case .single(let digit):
                return String(digit)
            case .double(let firstDigit, let secondDigit):
                return String(firstDigit) + String(secondDigit)
            }
        }
        
        var digitsToAppend: [Character] {
            switch self {
            case .single(let singleDigit):
                return [singleDigit]
            case .double(let firstDigit, let secondDigit):
                return [firstDigit, secondDigit]
            }
        }
    }
    
    enum Size {
        case single
        case double
    }
    
    // MARK: - Properties
    
    override var buttonStyleType: ButtonStyleType { .numeric }
    
    let digit: NumericButton.Digit
    let size: NumericButton.Size
    
    // MARK: - Init
    
    init(_ digit: NumericButton.Digit, size: NumericButton.Size = .single) {
        self.digit = digit
        self.size = size
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func setupButton() {
        setTitle(digit.title, for: .normal)
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.numericButtonDidPress), for: .touchUpInside)
    }
    
    override func calculateFontSize() -> CGFloat {
        return defaultFontSize
    }
    
    override func constrainedButtonWidth(withSpacing spacing: CGFloat) -> CGFloat {
        switch size {
        case .single:
            return buttonWidth
        case .double:
            return buttonWidth * 2 + spacing
        }
    }
}
