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
    
    // Sound of tapping bool setting
    // and
    // Haptic feedback setting
    let settings = Settings.shared
    // Taptic feedback generator
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    var delegate: PCalcViewControllerDelegate?
    
    init(buttonsPage: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.view = buttonsPage
        self.view.isExclusiveTouch = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let delegate = delegate else { return }
        // handling label when tappging on PCalcViewController
        delegate.unhighlightLabels()
    }
    
    // MARK: - Methods
    
    func showWithAnimation() {
        view.layoutSubviews()
        UIView.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseOut, animations: {
            self.view.alpha = 1
            self.view.isHidden = false
        }, completion: nil )
    }
    
    func hideWithAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
            self.view.alpha = 0
            self.view.isHidden = true
        }, completion: nil )
    }
    
    // MARK: - Actions
    
    @objc func tappingSoundHandler(_ sender: CalculatorButton) {
        if settings.tappingSounds {
            // play KeyPressed
            AudioServicesPlaySystemSound(1104)
        }
    }
    
    // Haptic feedback action for all buttons
    @objc func hapticFeedbackHandler(_ sender: CalculatorButton) {
        if settings.hapticFeedback {
            generator.prepare()
            // impact
            generator.impactOccurred()
        }
    }
}
