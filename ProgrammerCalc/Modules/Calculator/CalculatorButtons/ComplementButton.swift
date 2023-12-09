//
//  ComplementButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

extension ComplementOperator {
    fileprivate var title: String { NSLocalizedString(self.rawValue, comment: "") }
}

final class ComplementButton: CalculatorButton {

    let operatorType: ComplementOperator
    
    init(_ operatorType: ComplementOperator) {
        self.operatorType = operatorType
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupButton() {
        setTitle(operatorType.title, for: .normal)
    }
    
    override func setupActions() {
        super.setupActions()
        
        addTarget(nil, action: #selector(CalculatorViewController.complementButtonDidPress), for: .touchUpInside)
    }
}
