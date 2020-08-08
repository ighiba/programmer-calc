//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    lazy var conv = ConversionView()
    lazy var picker: ConversionPicker = conv.mainPicker
    lazy var slider: UISlider = conv.digitsAfterSlider
    lazy var labelValue: UILabel = conv.sliderValueDigit
    var sliderOldValue: Float = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = conv
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // load data from UserDefaults to picker and slider
        getConversionSettings()
        // animate popover
        conv.animateIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // save conversion data to UserDefaults
        saveConversionSettings()
    }
    
    // =======
    // Methods
    // =======
    
    // Update conversion values
    fileprivate func getConversionSettings() {
        // get data from UserDefaults
        print(picker.selectedRow(inComponent: 1))
        if let settings = Settings.conversionSettings {
            // TODO: Error handling
            let mainRow: Int = picker.systemsModel.conversionSystems.firstIndex(of: settings.systemMain)!
            let converterRow: Int = picker.systemsModel.conversionSystems.firstIndex(of: settings.systemConverter)!
            // Picker component
            // 0 - main
            // 1 - converter
            picker.selectRow(mainRow, inComponent: 0, animated: false)
            picker.selectRow(converterRow, inComponent: 1, animated: false)
            
            // Slider label
            labelValue.text = String(Int(settings.numbersAfterPoint) * 4)
            
            // Slider
            slider.value = settings.numbersAfterPoint
            sliderOldValue = settings.numbersAfterPoint
        }  else {
            print("no settings")
            // Save default settings (all true)
            let systems = ConversionModel.ConversionSystemsEnum.self
            Settings.conversionSettings = ConversionSettingsModel(systMain: systems.dec.rawValue, systConverter: systems.bin.rawValue, number: 2.0)
        }
    }
    
    fileprivate func saveConversionSettings() {
        // TODO: Error handling
        // Picker  component
        // 0 - main
        // 1 - converter
        let mainSelectedRow = picker.selectedRow(inComponent: 0)
        let converterSelectedRow = picker.selectedRow(inComponent: 1)
        let mainSelectedString = picker.pickerView(picker, titleForRow: mainSelectedRow, forComponent: 0)
        let converterSelectedString = picker.pickerView(picker, titleForRow: converterSelectedRow, forComponent: 1)
        // Slider
        let sliderValue = slider.value.rounded()
        // set data to UserDefaults
        Settings.conversionSettings = ConversionSettingsModel(systMain: mainSelectedString!, systConverter: converterSelectedString!, number: sliderValue)
    }
    
    // =======
    // Actions
    // =======
    
    // Done button / Exit button
    @objc func doneButtonTapped( sender: UIButton) {
        print("done")
        conv.animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
    

    // Changing value of slider
    @objc func sliderValueChanged( sender: UISlider) {
        let sliderNewValue = sender.value.rounded()  

        if sliderOldValue == sliderNewValue {
            // do nothing
        } else {
            // taptic feedback generator
            if (Settings.appSettings?.hapticFeedback ?? false) {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                // impact
                generator.impactOccurred()
            }
            // show new value in label
            labelValue.text = String(Int(sliderNewValue) * 4)
            // update old value
            sliderOldValue = sliderNewValue
        }
    }
}
