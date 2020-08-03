//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    let conv = ConversionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = conv
        print("did loaded popover")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conv.animateIn()
    }
    
    
    // =======
    // Actions
    // =======
    
    @objc func doneButtonTapped2( sender: UIButton) {
        print("done")
        
        // save conversion settings and close popover
        conv.animateOut {
            self.dismiss(animated: false, completion: nil)
        }
        
        
    }
    
    
    
}
