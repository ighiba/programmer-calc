//
//  CalcButtonsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import AudioToolbox

class CalcButtonsViewController: UIViewController {
    
    // Taptic feedback generator
    private let generator = UIImpactFeedbackGenerator(style: .light)
    // haptic feedback setting
    var hapticFeedback = false
    
    // Sound of tapping bool setting
    var tappingSounds = false
    
    // PCalcViewController delegate
    var delegate: PCalcViewControllerDelegate?
    
    init( buttonsPage: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.view = buttonsPage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // andling tappging on PCalcViewController
        guard delegate != nil else {
            return
        }
        
        delegate!.unhighlightLabels()
        
        print("touched began page out")
    }
    
    // MARK: - Actions
    
    @objc func tappingSoundHandler(_ sender: CalculatorButton) {
        if tappingSounds {
            // play KeyPressed
            AudioServicesPlaySystemSound(1104)
        }

    }
    
    // Haptic feedback action for all buttons
    @objc func hapticFeedbackHandler(_ sender: CalculatorButton) {
        if hapticFeedback {
            generator.prepare()
            // impact
            generator.impactOccurred()
        }
    }
}
