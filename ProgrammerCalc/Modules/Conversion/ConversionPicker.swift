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
    private let itemLabelHeight: CGFloat = 30
    
    private lazy var arrowSymbol = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(withArrowSymbol: Bool) {
        self.init(frame: .zero)
        self.setupArrowSymbol()
    }
    
    private func setupArrowSymbol() {
        arrowSymbol.text = "→"
        arrowSymbol.textAlignment = .center
        arrowSymbol.textColor = .label
        arrowSymbol.font = UIFont(name: "HelveticaNeue-Thin", size: 22.0)
        
        addSubview(arrowSymbol)
        
        arrowSymbol.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            arrowSymbol.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowSymbol.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowSymbol.widthAnchor.constraint(equalToConstant: itemLabelHeight),
            arrowSymbol.heightAnchor.constraint(equalToConstant: itemLabelHeight)
        ])
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
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return rowWidth + 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelFrame = CGRect(x: 0, y: 0, width: rowWidth, height: itemLabelHeight)
        let label = UILabel(frame: labelFrame)
        
        label.text = ConversionSystem.allCases[row].title
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }
}
