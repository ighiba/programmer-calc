//
//  PCalcView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit



class PCalcView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setViews()
    }
    
    
    func setViews() {

        allViews.addSubview(mainLabel)
        allViews.addSubview(converterLabel)

    }
    
    let allViews: UIView = UIView()
    
    
    // main label
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect( x: Double(0), y: Double(20), width: 372.0, height: 100.0)
        label.text = "0"
        label.backgroundColor = .white
        // set font size, font family
        //mainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        label.font = UIFont.systemFont(ofSize: 72.0, weight: UIFont.Weight.thin)
        label.textAlignment = .right
        // set borders
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        label.layer.cornerRadius = 0.0
        // resizeble text
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    // converter label
    lazy var converterLabel: UILabel = {
        let label = UILabel()
        
         label.frame = CGRect( x: Double(0), y: Double(120), width: 372.0, height: 100.0)
         label.text = "0"
         label.backgroundColor = .white
         // set font size, font family
         //mainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
         label.font = UIFont.systemFont(ofSize: 62.0, weight: UIFont.Weight.thin)
         label.textAlignment = .right
         // set borders
         label.layer.borderWidth = 0.5
         label.layer.borderColor = UIColor.lightGray.cgColor
         // round corners
         label.layer.cornerRadius = 0.0
         // resizeble text
         label.minimumScaleFactor = 0.5
         label.adjustsFontSizeToFitWidth = true
         
         return label
    }()
    
    func createButtons(vc: ViewController) -> [UIButton] {
    
            var buttonLabel: Int = 9
            var buttons: [UIButton] = []
    
            let signs = [ "AC","\u{00B1}","%","\u{00f7}","X","-","+","="]
    
            // Numeric buttons
    
            for row in 0...2 {
                buttonLabel = buttonLabel - 2
                for column  in 0...2 {
    
                    let button = CalculatorButton.init(type: .custom)
                    button.setFrame(xMult: column, yMult: row, width: 75, height: 75)
    
                    // set actions for button
                    button.setActions(viewcontroller: vc, buttonType: .numeric)
                    // set title and style
                    button.setTitle(String(buttonLabel), for: .normal)
                    button.applyStyle()
                    buttonLabel += 1
    
                    // add element to array
                    buttons.append(button)
                }
                buttonLabel = buttonLabel - 4
            }
    
            // Zero and point/dot buttons
    
            let zeroButton: () -> (UIButton) = {
                // width multiple 2 + x
                let button = CalculatorButton.init(type: .custom)
                button.setFrame(xMult: 0, yMult: 3, width: 165.0, height: 75.0)
    
                // set actions for button
                button.setActions(viewcontroller: vc, buttonType: .numeric)
                // set title and style
                button.setTitle("0", for: .normal)
                button.applyStyle()
                //button.contentHorizontalAlignment = .left
    
                return button
            }
            let dotButton: () -> (UIButton) = {
                // normal width
                let button = CalculatorButton.init(type: .custom)
                button.setFrame(xMult: 2, yMult: 3, width: 75, height: 75)
    
                // set actions for button
                button.setActions(viewcontroller: vc, buttonType: .numeric)
                // set title and style
                button.setTitle(".", for: .normal)
                button.applyStyle()
    
                return button
            }
            buttons.append(dotButton())
            buttons.append(zeroButton())
    
    
            // Sign buttons
    
    
            for row in 0...3 {
                if row != 3 {
                    let button = CalculatorButton.init(type: .custom)
                    button.setFrame(xMult: row, yMult: -1, width: 75, height: 75)
                    // set actions for button
                    button.setActions(viewcontroller: vc, buttonType: .sign)
                    // set title and style
                    button.setTitle(signs[row], for: .normal)
                    button.tag = 100 + row
                    button.applyStyle()
                    //button.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.light)
                    buttons.append(button)
                } else {
                    for column in 0...4 {
                        let button = CalculatorButton.init(type: .custom)
                        button.setFrame(xMult: row, yMult: -1 + column, width: 75, height: 75)
                        // set actions for button
                        button.setActions(viewcontroller: vc, buttonType: .sign)
                        // set title and style
                        button.setTitle(signs[row+column], for: .normal)
                        button.tag = 100 + row + column
    
                        button.applyStyle()
                        //button.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin)
                        buttons.append(button)
                    }
                }
            }
            //
    
            // Logical buttons
    
            //
    
            return buttons
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// ==============================
// Class for calculator's buttons
// ==============================

class CalculatorButton: UIButton {
    private let _boundsExtension: CGFloat = 0
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
    
    
    // ============
    // Enumerations
    // ============
    
    enum buttonTypes {
        case numeric
        case sign
        case logical
    }
    
    
    // =======
    // Methods
    // =======
    
    // Apply Style method to the all buttons
    // TODO: Style protocol
    func applyStyle() {
        // set title and background
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .white
        // set font size, font family
        //self.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 45.0)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 45.0, weight: UIFont.Weight.thin)
        // set borders
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        self.layer.cornerRadius = 35.0
    }
    
    func setFrame(xMult: Int, yMult: Int, width fWidth: Double, height fHeight: Double) {
        self.frame = CGRect( x: Double(85*xMult + 20), y: Double(85*yMult + 320), width: fWidth, height: fHeight)
    }
    
    func setActions(viewcontroller: ViewController, buttonType: buttonTypes){
        self.addTarget(viewcontroller, action: #selector(viewcontroller.toucUhpOutsideAction), for: [.touchDragExit, .touchDragOutside])
        
        switch buttonType {
        case .numeric:
                self.addTarget(viewcontroller, action: #selector(viewcontroller.numericButtonTapped), for: .touchUpInside)
        case .sign:
            self.addTarget(viewcontroller, action: #selector(viewcontroller.signButtonTapped), for: .touchUpInside)
        default:
            break
        }
    }
    
}


