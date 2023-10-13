//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionViewController: ModalViewController, ConversionInput {

    var output: ConversionOutput!
    
    private let conversionView: ConversionView
    
    private var sliderValueOld: Float = 2.0

    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    init() {
        self.conversionView = ConversionView()
        super.init(modalView: conversionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.obtainConversionSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveConversionSettings()
    }
    
    override func setupTargets() {
        super.setupTargets()
        conversionView.slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
    }
    
    // MARK: - Methods
    
    func mainPickerSelectRow(_ row: Int) {
        conversionView.numberSystemsPicker.selectRow(row, inComponent: 0, animated: false)
    }
    
    func converterPickerSelectRow(_ row: Int) {
        conversionView.numberSystemsPicker.selectRow(row, inComponent: 1, animated: false)
    }
    
    func setLabelValueText(_ text: String) {
        conversionView.sliderValueLabel.text = text
    }
    
    func setSliderValue(_ value: Float) {
        conversionView.slider.value = value
        sliderValueOld = conversionView.slider.value
    }
    
    func hapticImpact() {
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
    }
    
    private func saveConversionSettings() {
        let mainSystemSelectedRow = conversionView.numberSystemsPicker.selectedRow(inComponent: 0)
        let converterSystemSelectedRow = conversionView.numberSystemsPicker.selectedRow(inComponent: 1)
        let sliderValue = conversionView.slider.value.rounded()
        output.saveConversionSettings(mainRow: mainSystemSelectedRow, converterRow: converterSystemSelectedRow, sliderValue: sliderValue)
    }
    
    // MARK: - Actions

    @objc func sliderValueDidChange(_ sender: UISlider) {
        let sliderValueNew = sender.value.rounded()
        if sliderValueOld != sliderValueNew {
            output.sliderValueDidChanged(sliderValueNew)
            sliderValueOld = sliderValueNew
        }
    }
}
