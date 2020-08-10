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
        if let data = SavedData.conversionSettings {
            // TODO: Error handling
            let mainRow: Int = picker.systemsModel.conversionSystems.firstIndex(of: data.systemMain)!
            let converterRow: Int = picker.systemsModel.conversionSystems.firstIndex(of: data.systemConverter)!
            // Picker component
            // 0 - main
            // 1 - converter
            picker.selectRow(mainRow, inComponent: 0, animated: false)
            picker.selectRow(converterRow, inComponent: 1, animated: false)
            
            // Slider label
            labelValue.text = "\(Int(data.numbersAfterPoint))"
            
            // Slider
            slider.value = data.numbersAfterPoint / 4
            sliderOldValue = slider.value
        }  else {
            print("no settings")
            // Save default settings (all true)
            let systems = ConversionModel.ConversionSystemsEnum.self
            SavedData.conversionSettings = ConversionSettingsModel(systMain: systems.dec.rawValue, systConverter: systems.bin.rawValue, number: 8.0)
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
        
        // root vc fo handling changing of mainSystem
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? PCalcViewController
        guard rootVC != nil else {
            // set data to UserDefaults
            SavedData.conversionSettings = ConversionSettingsModel(systMain: mainSelectedString!, systConverter: converterSelectedString!, number: sliderValue * 4)
            return
        }
        
        // set last mainLabel system buffer
        let buffSavedMainLabel = SavedData.conversionSettings?.systemMain
        // set data to UserDefaults
        SavedData.conversionSettings = ConversionSettingsModel(systMain: mainSelectedString!, systConverter: converterSelectedString!, number: sliderValue * 4)
        // Handle changing of systems
        // TODO: Error handling
        if buffSavedMainLabel != mainSelectedString! {
            // set labels to 0 and update
            rootVC!.resetAllLabels()
        } else {
            // if systemMain == last vaulue of systemMain then just update values
            rootVC!.updateConverterLabel()
        }
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
            if (SavedData.appSettings?.hapticFeedback ?? false) {
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
