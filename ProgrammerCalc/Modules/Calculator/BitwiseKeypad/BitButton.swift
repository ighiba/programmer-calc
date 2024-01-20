//
//  BitButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 27.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import UIKit

class BitButton: UIButton {
    
    enum State: UInt8 {
        case off = 0
        case on = 1
        
        var boolValue: Bool { self == .on ? true : false }
        var stringValue: String { self == .on ? "1" : "0" }
    }
    
    // MARK: - Properties
    
    var bitState: BitButton.State = .off {
        didSet {
            setBitLabelText(bitState.stringValue)
            isSelected = bitState.boolValue
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                bitState = .off
            }
        }
    }
    
    let bitIndex: Int
    
    // MARK: - Initialization
    
    init(bitIndex: Int) {
        self.bitIndex = bitIndex
        super.init(frame: .zero)
        self.setTitle(State.off.stringValue, for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func toggleState() {
        bitState = bitState == .on ? .off : .on
    }

    private func setBitLabelText(_ text: String) {
        guard titleLabel?.text != text else { return }
        setTitle(text, for: .normal)
    }
}
