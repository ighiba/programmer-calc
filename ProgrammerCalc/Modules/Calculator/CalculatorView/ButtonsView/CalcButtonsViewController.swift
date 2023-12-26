//
//  CalcButtonsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class CalcButtonsViewController: UIViewController {
    
    init(buttonsPage: CalcButtonsPage) {
        super.init(nibName: nil, bundle: nil)
        self.view = buttonsPage
        self.view.isExclusiveTouch = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func showWithAnimation() {
        view.layoutSubviews()
        UIView.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseOut, animations: { [weak self] in
            self?.view.alpha = 1
            self?.view.isHidden = false
        }, completion: nil)
    }
    
    func hideWithAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
            self?.view.alpha = 0
            self?.view.isHidden = true
        }, completion: nil)
    }
}
