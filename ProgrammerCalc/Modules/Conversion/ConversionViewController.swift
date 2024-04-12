//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

protocol ConversionInput: AnyObject {
    func inputPickerSelectRow(atIndex index: Int)
    func outputPickerSelectRow(atIndex index: Int)
    func setFractionalWidthLabelText(_ text: String)
    func setFractionalWidthSliderValue(_ value: Float)
    func hapticImpact()
}

final class ConversionViewController: ModalViewController, ConversionInput {

    var presenter: ConversionOutput!
    
    private let conversionView = ConversionView()
    
    private var sliderOldValue: Float = 2.0

    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Init
    
    init() {
        super.init(modalView: conversionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveConversionSettings()
    }
    
    override func setupTargets() {
        super.setupTargets()
        
        conversionView.fractionalWidthSlider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
    }
    
    func inputPickerSelectRow(atIndex index: Int) {
        conversionView.conversionSystemsPicker.selectRow(index, inComponent: 0, animated: false)
    }
    
    func outputPickerSelectRow(atIndex index: Int) {
        conversionView.conversionSystemsPicker.selectRow(index, inComponent: 1, animated: false)
    }
    
    func setFractionalWidthLabelText(_ text: String) {
        conversionView.fractionalWidthLabel.text = text
    }
    
    func setFractionalWidthSliderValue(_ value: Float) {
        conversionView.fractionalWidthSlider.value = value
        sliderOldValue = conversionView.fractionalWidthSlider.value
    }
    
    func hapticImpact() {
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
    }
    
    private func saveConversionSettings() {
        let inputPickerSelectedRow = conversionView.conversionSystemsPicker.selectedRow(inComponent: 0)
        let outputPickerSelectedRow = conversionView.conversionSystemsPicker.selectedRow(inComponent: 1)
        let sliderValue = conversionView.fractionalWidthSlider.value.rounded()
        presenter.saveConversionSettings(inputPickerSelectedRow: inputPickerSelectedRow, outputPickerSelectedRow: outputPickerSelectedRow, sliderValue: sliderValue)
    }
}

// MARK: - Actions

extension ConversionViewController {
    @objc func sliderValueDidChange(_ sender: UISlider) {
        let sliderNewValue = sender.value.rounded()
        if sliderOldValue != sliderNewValue {
            presenter.sliderValueDidChange(sliderNewValue)
            sliderOldValue = sliderNewValue
        }
    }
}
