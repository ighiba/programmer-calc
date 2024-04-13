//
//  ConversionPicker.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

final class ConversionPicker: UIPickerView {
    private var rowWidth: CGFloat { modalViewContainerWidth / 2 - 35 }
    private let rowHeight: CGFloat = 45
    private let titleLabelHeight: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource

extension ConversionPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConversionSystem.allCases.count
    }
}

// MARK: - Delegate

extension ConversionPicker: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConversionSystem.allCases[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return rowWidth + 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelFrame = CGRect(x: 0, y: 0, width: rowWidth, height: titleLabelHeight)
        let label = UILabel(frame: labelFrame)
        
        label.text = self.pickerView(self, titleForRow: row, forComponent: component)
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        
        return label
    }
}
