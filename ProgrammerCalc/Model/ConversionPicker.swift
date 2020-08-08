//
//  ConversionPicker.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionPicker: UIPickerView {
    var systemsModel: ConversionModel!
    let screenWidth = UIScreen.main.bounds.width
    
}

extension ConversionPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return systemsModel.conversionSystems.count
    }
}

extension ConversionPicker: UIPickerViewDelegate {
    
    
    // Process element from array to create picker row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return systemsModel.conversionSystems[row]
    }
    
    // Picker row width
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        print((screenWidth * 0.95) / 2 - 30)
        return (screenWidth * 0.95) / 2 - 30
    }
    
    // Picker row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    
    // Adjusting view for each row
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        let label = UILabel()
        
        // Row bounds
        view.frame = CGRect(x: 0, y: 0, width: (screenWidth * 0.95) / 2 - 35, height: 30)
        label.frame = CGRect(x: 0, y: 0, width: (screenWidth * 0.95) / 2 - 35, height: 30)
        
        // Picker row text style
        label.text = self.pickerView(self, titleForRow: row, forComponent: component)
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        //label.font = UIFont(name: "HelveticaNeue-Thin", size: 22.0)
        label.textAlignment = .center
        
        view.addSubview(label)
        
        
        return view
    }

}

