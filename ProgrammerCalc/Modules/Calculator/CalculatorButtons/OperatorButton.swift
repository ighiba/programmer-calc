//
//  OperatorButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

final class OperatorButton: CalculatorButton {
    
    enum OperatorType {
        case unary(UnaryOperator)
        case binary(BinaryOperator)
        
        fileprivate var title: String {
            switch self {
            case .unary(let unaryOperator):
                return unaryOperator.rawValue
            case .binary(let binaryOperator):
                return binaryOperator.rawValue
            }
        }
        
        fileprivate var isBitwise: Bool {
            switch self {
            case .unary(_):
                return true
            case .binary(let binaryOperator):
                return binaryOperator.isBitwise
            }
        }
    }
    
    // MARK: - Properties
    
    override var buttonStyleType: ButtonStyleType { .action }
    
    private var verticalAlignment: UIControl.ContentVerticalAlignment { operatorType.isBitwise ? .center : .top }
    
    let operatorType: OperatorButton.OperatorType
    
    // MARK: - Init
    
    init(_ operatorType: OperatorButton.OperatorType) {
        self.operatorType = operatorType
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func setupButton() {
        setTitle(operatorType.title, for: .normal)
        
        contentVerticalAlignment = verticalAlignment
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.operatorButtonDidPress), for: .touchUpInside)
    }
}
