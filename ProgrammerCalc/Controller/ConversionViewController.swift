//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = ConversionView()
        print("did loaded popover")
    }
    
    
    // =======
    // Actions
    // =======
    
    @objc func doneButtonTapped( sender: UIButton) {
        print("done")
        
        // save conversion settings and close popover
        self.dismiss(animated: true, completion: nil)
    }
}
