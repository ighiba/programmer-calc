//
//  PopoverDoneButton.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 18.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

private let labelFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
private let popoverDoneButtonColor: UIColor = UIColor(named: "PopoverDoneButtonColor")!
private let popoverDoneButtonColorPressed: UIColor = UIColor(named: "PopoverDoneButtonColorPressed")!

class PopoverDoneButton: UIButton {
    
    static let defaultHeight: CGFloat = 50
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = popoverDoneButtonColorPressed
            } else {
                transitionToDefaultBackgroundColor()
            }
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
        frame = CGRect(x: 0, y: 0, width: 100, height: PopoverDoneButton.defaultHeight)
        
        setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = labelFont
        
        backgroundColor = .systemGreen
        
        layer.cornerRadius = 16
    }
    
    private func transitionToDefaultBackgroundColor(duration: TimeInterval = 0.3) {
        UIView.transition(
            with: self,
            duration: duration,
            options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
            animations: { self.backgroundColor = popoverDoneButtonColor },
            completion: nil
        )
    }
}
