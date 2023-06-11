//
//  BitButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 27.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import UIKit

class BitButton: UIButton {
    
    // MARK: - Properties
    
    private let BIT_ON: String = "1"
    private let BIT_OFF: String = "0"
    
    private var bitState: Bool = false {
        didSet {
            changeTitleByBitState()
            self.isSelected = bitState
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                bitState = false // disable bit state if button is disabled
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect())
        self.setTitle(BIT_OFF, for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    public func setBitState(_ bitState: Bool) {
        self.bitState = bitState
    }
    
    private func changeTitleByBitState() {
        if bitState {
            changeLabelText(with: BIT_ON)
        } else {
            changeLabelText(with: BIT_OFF)
        }
    }
    
    private func changeLabelText(with bit: String) {
        // do nothing if bit label already setted
        guard self.titleLabel?.text != bit else { return }
        self.setTitle(bit, for: .normal)
    }

}
