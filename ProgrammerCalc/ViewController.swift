//
//  ViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var buttons: [UIButton] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        let button = CalculatorButton.init(type: .system)
        button.frame = CGRect( x: 100, y: 100, width: 100.0, height: 100.0)
        button.setTitle("test", for: .normal)
        button.backgroundColor = .red
        
        /*
        button.addTarget(self, action: #selector(numButtonAction), for: .touchUpInside)
        
        button.addTarget(self, action: #selector(numButtonAnimDown), for: [.touchDown, .touchDragInside])
        button.addTarget(self, action: #selector(numButtonAnimUpInside), for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit])
        */
        
        self.view.addSubview(button)
        

    }
    @objc func numButtonAction(sender: UIButton!) {
        print("num button tapped")
    }
    /*
    @objc func numButtonAnimDown(sender: UIButton!) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction], animations: {
            sender.backgroundColor = .lightGray
        }, completion: nil)
    }
    @objc func numButtonAnimUpInside(sender: UIButton!) {
        UIView.transition(with: sender, duration: 0.3, options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                sender.backgroundColor = .white
            }, completion: nil)
    }
 */
    func createButtons() {
        for number  in 1...9 {
            //let button = UIButton.
            //buttons.append(UIButton.)
        }
    }


}

//
// Class for calculator's buttons
//

class CalculatorButton: UIButton {
    // override isHighlighted for calculator buttons
    override open var isHighlighted: Bool {
        // if variable state changed
        // change background color for calulator buttons while they pressed
        didSet {
            if isHighlighted {
                // create button animation when button pressed
                UIView.transition(
                    with: self,
                    duration: 0.1,
                    options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .lightGray },
                    completion: nil)
            } else {
                // create button animation when button unpressed
                UIView.transition(
                    with: self,
                    duration: 0.3,
                    options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .white },
                    completion: nil)
            }

            
        }
    }
}


