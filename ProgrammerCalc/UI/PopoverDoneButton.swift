//
//  PopoverDoneButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 18.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class PopoverDoneButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            changeButtonHighlightAnimated(isHighlighted: isHighlighted)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        setTitleColor(.white, for: .normal)
        
        backgroundColor = .systemGreen
        
        layer.cornerRadius = 16
    }
    
    private func changeButtonHighlightAnimated(isHighlighted: Bool) {
        if isHighlighted {
            backgroundColor = .popoverDoneButtonColorPressed
        } else {
            UIView.transition(
                with: self,
                duration: 0.3,
                options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                animations: { self.backgroundColor = .popoverDoneButtonColor },
                completion: nil
            )
        }
    }
}
