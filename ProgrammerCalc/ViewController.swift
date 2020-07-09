//
//  ViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let mainLabel: UILabel = UILabel()
    let converterLabel: UILabel = UILabel()
    weak var numButtonsView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.

        showInputLabel()
        showConverterLabel()
        showAllButtons()
        //convertToBinary(decNumStr: "5")

        
        

    }
    
    // =======
    // Methods
    // =======
    
    
    func createButtons() -> [UIButton] {
        
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
                button.setActions(viewcontroller: self, buttonType: .numeric)
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
            button.setActions(viewcontroller: self, buttonType: .numeric)
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
            button.setActions(viewcontroller: self, buttonType: .numeric)
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
                button.setActions(viewcontroller: self, buttonType: .sign)
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
                    button.setActions(viewcontroller: self, buttonType: .sign)
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
    
    // ============
    // Label output
    // ============
    
    func showInputLabel() {
        mainLabel.frame = CGRect( x: Double(0), y: Double(20), width: 372.0, height: 100.0)
        mainLabel.text = "0"
        mainLabel.backgroundColor = .white
        // set font size, font family
        //mainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        mainLabel.font = UIFont.systemFont(ofSize: 72.0, weight: UIFont.Weight.thin)
        mainLabel.textAlignment = .right
        // set borders
        mainLabel.layer.borderWidth = 0.5
        mainLabel.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        mainLabel.layer.cornerRadius = 0.0
        // resizeble text
        mainLabel.minimumScaleFactor = 0.5
        mainLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(mainLabel)
    }
    
    func showConverterLabel() {
        converterLabel.frame = CGRect( x: Double(0), y: Double(120), width: 372.0, height: 100.0)
        converterLabel.text = "0"
        converterLabel.backgroundColor = .white
        // set font size, font family
        //mainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 72.0)
        converterLabel.font = UIFont.systemFont(ofSize: 62.0, weight: UIFont.Weight.thin)
        converterLabel.textAlignment = .right
        // set borders
        converterLabel.layer.borderWidth = 0.5
        converterLabel.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        converterLabel.layer.cornerRadius = 0.0
        // resizeble text
        converterLabel.minimumScaleFactor = 0.5
        converterLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(converterLabel)
    }
    
    
    // =====================
    // Output of all buttons
    // =====================
    
    func showAllButtons()  {
        let allButtons = createButtons()
        for button in allButtons {
            self.view.addSubview(button)
        }
        
    }
    
    // ==========
    // VC Methods
    // ==========
    
    func convertToBinary( decNumStr: String) -> String {
        var binaryStr: String
        
        if let decNumInt: Int = Int(decNumStr) {
            binaryStr = String(decNumInt, radix: 2)
        } else {
            
            decNumStr.divideToFloatInt()
            //let numberDouble: Double = ( decNumStr as NSString).doubleValue
            //
            //doubleToBinary(number: numberDouble)
            binaryStr = ""
            
        }
        
        
        
        print(binaryStr)
        
        return binaryStr
    }
    
    func doubleToBinary( number: Double) -> Double {
        let resultBinary: Double
        var resultStrBinary: String
        let decNumDouble:Double = number
        let decNumDouble_Int: Int
        let decNumDouble_Reminder: () -> (Int)
        
        decNumDouble_Int = Int(decNumDouble)
        decNumDouble_Reminder = {
            let reminder: Int = 0
            let dblBuff = decNumDouble - (Double(decNumDouble_Int))
            
            print(dblBuff)
            
            
            
            return reminder
        }
        decNumDouble_Reminder()
        
        resultStrBinary = String(decNumDouble_Int, radix: 2) + "."
        
        
        return 1.0
    }
    
    // =======
    // Actions
    // =======
    
    @objc func toucUhpOutsideAction(sender: UIButton) {
        //print("touchUpOutside")
        //sender.isHighlighted = false
    }
    
    // Numeric buttons actions
    
    @objc func numericButtonTapped(sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        let convertLabel = converterLabel
        // tag for AC/C button
        let acButton = self.view.viewWithTag(100) as! UIButton
        //print(acButton)
        
        
        print("Button \(buttonText) touched")
        
        switch label.text! {
        case "0":
            
            if buttonText.contains(".") {
                label.text! += buttonText
                convertLabel.text! += buttonText
                acButton.setTitle("C", for: .normal)
            } else if buttonText != "0" {
                label.text! = buttonText
                acButton.setTitle("C", for: .normal)
            }
            // if 0 pressed then does nothing
            

        default:
            if label.text!.contains(".") && buttonText == "." {
                break
            } else {
                label.text! += buttonText
                convertLabel.text! += buttonText
            }
            acButton.setTitle("C", for: .normal)
        }
        
        if buttonText != "." {
            convertLabel.text = convertToBinary(decNumStr: label.text!)
        }
        // Uptade converter label with converted number
        
    }
    
    // Sign buttons actions
    
    @objc func signButtonTapped(sender: UIButton) {
        let button = sender
        let buttonText = button.titleLabel!.text ?? ""
        let label = mainLabel
        let convertLabel = converterLabel
        
        //print("Button \(buttonText) touched")
        
        switch buttonText {
        case "AC":
            label.text! = "0"
            convertLabel.text! = "0"
        case "C":
            label.text! = "0"
            convertLabel.text! = "0"
            
            button.setTitle("AC", for: .normal)
        default:
            break
        }
        
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

// ==========
// Extensions
// ==========

extension String {
    
    // Dividing string variable and converting it to double without loss of precision
    func divideToFloatInt() -> (Int, Int)? {
        let str = self
        var numberInt: Int = 0
        var numberFract: Int = 0
        var pointPos: String.Index
        var counter: Int = 0
        var iterator: Int = 0
        var multiplier: Int = 1
 
        // check for floating point
        guard str.contains(".") else {
            return nil
        }
        
        // search index of floating pos
        pointPos = str.firstIndex(of: ".")!
        
        // fill numberInt
        counter = str.distance(from: str.startIndex, to: pointPos)
        multiplier = 1
        iterator = -1
        while counter > 0 {
            
            // TODO Erorr handling
            let newIndex: String.Index = str.index(pointPos, offsetBy: iterator)
            let strCharInt: String = String(str[newIndex])
            let num: Int = Int(strCharInt)!
            numberInt += num  * multiplier
            multiplier *= 10
            counter -= 1
            iterator -= 1
        }
        
        // fill numberFract
        counter = str.distance(from: str.endIndex, to: pointPos)
        counter = abs(counter)
        multiplier = 1
        iterator = counter - 1
        while counter > 1 {
            
            // TODO Erorr handling
            let newIndex: String.Index = str.index(pointPos, offsetBy: iterator)
            let strCharInt: String = String(str[newIndex])
            let num: Int = Int(strCharInt)!
            numberFract += num  * multiplier
            multiplier *= 10
            counter -= 1
            iterator -= 1
        }
        
        
        print(" \(numberInt)...\(numberFract)")
        return (numberInt, numberFract)
    }
    
}


