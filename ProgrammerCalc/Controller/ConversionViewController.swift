//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    // ==================
    // MARK: - Properties
    // ==================
    
    lazy var conversionView = ConversionView()
    lazy var picker: ConversionPicker = conversionView.mainPicker
    lazy var slider: UISlider = conversionView.digitsAfterSlider
    lazy var labelValue: UILabel = conversionView.sliderValueDigit
    var sliderOldValue: Float = 2.0
    
    
    // links to storages
    private var settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private var conversionStorage: ConversionStorageProtocol = ConversionStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = conversionView
        
        // tap outside popup(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        tap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        // swipe up
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // load data from UserDefaults to picker and slider
        getConversionSettings()
        // animate popover
        conversionView.animateIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save conversion data to UserDefaults
        saveConversionSettings()
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Update conversion values
    fileprivate func getConversionSettings() {
        // get data from UserDefaults
        if let conversionSettings = conversionStorage.loadData() {
            // TODO: Error handling
            
            let mainRow: Int = ConversionSystemsEnum.allCases.firstIndex(of: ConversionSystemsEnum(rawValue: conversionSettings.systemMain)!)!
            let converterRow: Int = ConversionSystemsEnum.allCases.firstIndex(of: ConversionSystemsEnum(rawValue: conversionSettings.systemConverter)!)!
            // Picker component
            // 0 - main
            // 1 - converter
            picker.selectRow(mainRow, inComponent: 0, animated: false)
            picker.selectRow(converterRow, inComponent: 1, animated: false)
            
            // Slider label
            labelValue.text = "\(Int(conversionSettings.numbersAfterPoint))"
            
            // Slider
            slider.value = conversionSettings.numbersAfterPoint / 4
            sliderOldValue = slider.value
        }  else {
            print("no settings")
            // Save default settings 
            let systems = ConversionSystemsEnum.self
            let newConversionSettings = ConversionSettings(systMain: systems.dec.rawValue, systConverter: systems.bin.rawValue, number: 8.0)
            conversionStorage.saveData(newConversionSettings)
        }
    }
    
    fileprivate func saveConversionSettings() {
        // TODO: Error handling
        // Picker  component
        // 0 - main
        // 1 - converter
        let mainSelectedRow = picker.selectedRow(inComponent: 0)
        let converterSelectedRow = picker.selectedRow(inComponent: 1)
        let systemMainNew = picker.pickerView(picker, titleForRow: mainSelectedRow, forComponent: 0)
        let systemConverterNew = picker.pickerView(picker, titleForRow: converterSelectedRow, forComponent: 1)
        // Slider
        let sliderValue = slider.value.rounded()
        
        // root vc fo handling changing of mainSystem
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? PCalcViewController
        guard rootVC != nil else {
            // set data to UserDefaults
            let newConversionSettings = ConversionSettings(systMain: systemMainNew!, systConverter: systemConverterNew!, number: sliderValue * 4)
            conversionStorage.saveData(newConversionSettings)
            return
        }
        
        // set last mainLabel system buffer
        let conversionSettings = conversionStorage.loadData()
        let buffSavedMainLabel = conversionSettings?.systemMain
        // set data to UserDefaults
        let newConversionSettings = ConversionSettings(systMain: systemMainNew!, systConverter: systemConverterNew!, number: sliderValue * 4)
        conversionStorage.saveData(newConversionSettings)
        // set data to rootVC state vars
        rootVC?.systemMain = ConversionSystemsEnum(rawValue: systemMainNew!)
        rootVC?.systemConverter = ConversionSystemsEnum(rawValue: systemConverterNew!)
        // Handle changing of systems
        // TODO: Error handling
        if buffSavedMainLabel != systemMainNew! {
            // set labels to 0 and update
            rootVC!.clearLabels()
        } else {
            // if systemMain == last value of systemMain then just update values
            // update layout
            rootVC!.updateAllLayout()
        }
        
        rootVC!.handleDisplayingMainLabel()
        rootVC!.updateButtons()
        
    }
    
    // ViewConvtroller dismissing
    fileprivate func dismissVC() {
        // anation
        conversionView.animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    fileprivate func isGestureNotInContainer( gesture: UIGestureRecognizer) -> Bool {
        conversionView.container.updateConstraints()
        let currentLocation: CGPoint = gesture.location(in: conversionView.container)
        let containerBounds: CGRect = conversionView.container.bounds

        return !containerBounds.contains(currentLocation)
    }
    
    // ===============
    // MARK: - Actions
    // ===============
    
    // Done button / Exit button
    @objc func doneButtonTapped( sender: UIButton) {
        dismissVC()
    }
    
    // Swipe up to exit
    @objc func handleSwipe( sender: UISwipeGestureRecognizer) {
        let notInContainer: Bool = isGestureNotInContainer(gesture: sender)
        
        if notInContainer {
            // does not contains
            // dismiss vc
            dismissVC()
        }
    }
    
    @objc func tappedOutside( sender: UITapGestureRecognizer) {
        let notInContainer: Bool = isGestureNotInContainer(gesture: sender)
        
        if notInContainer {
            // does not contains
            // dismiss vc
            dismissVC()
        }
    }

    // Changing value of slider
    @objc func sliderValueChanged( sender: UISlider) {
        let sliderNewValue = sender.value.rounded()

        if sliderOldValue == sliderNewValue {
            // do nothing
        } else {
            // taptic feedback generator
            let settings = settingsStorage.loadData()
            if (settings?.hapticFeedback ?? false) {
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
