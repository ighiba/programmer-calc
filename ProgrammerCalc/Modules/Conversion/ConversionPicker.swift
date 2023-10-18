//
//  ConversionPicker.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionPicker: UIPickerView {
    var pickerWidth: CGFloat { modalViewContainerWidth / 2 - 35 }
}

// MARK: - DataSource

extension ConversionPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConversionSystemsEnum.allCases.count
    }
}

// MARK: - Delegate

extension ConversionPicker: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConversionSystemsEnum.allCases[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerWidth + 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        let label = UILabel()
        
        view.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: 30)
        label.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: 30)
        
        label.text = self.pickerView(self, titleForRow: row, forComponent: component)
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        
        view.addSubview(label)
        
        return view
    }
}
