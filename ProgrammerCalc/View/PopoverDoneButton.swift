//
//  PopoverDoneButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 18.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class PopoverDoneButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        
        self.setTitle("Done", for: .normal)
        // TODO: Themes
        self.backgroundColor = .systemGreen
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 16
    }
    
    override open var isHighlighted: Bool {
        // if variable state changed
        // change background color for calulator buttons while they pressed
        didSet {
            if isHighlighted {
                // create button animation when button pressed
                self.backgroundColor = #colorLiteral(red: 0.1159710638, green: 0.6013326163, blue: 0.1974542897, alpha: 1).withAlphaComponent(0.8)
            } else {
                // create button animation when button unpressed
                UIView.transition(
                    with: self,
                    duration: 0.7,
                    options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .systemGreen },
                    completion: nil)
            }
        }
    }
}
