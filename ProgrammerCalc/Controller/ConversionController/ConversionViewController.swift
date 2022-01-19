//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    // MARK: - Properties
    
    // PCalcViewController delegate
    weak var delegate: PCalcViewControllerDelegate?
    
    lazy var conversionView = ConversionView()
    lazy var picker: ConversionPicker = conversionView.mainPicker
    lazy var slider: UISlider = conversionView.digitsAfterSlider
    lazy var labelValue: UILabel = conversionView.sliderValueDigit
    var sliderOldValue: Float = 2.0
    
    // links to storages
    private var settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private var conversionStorage: ConversionStorageProtocol = ConversionStorage()
    
    // Haptic feedback generator
    let generator = UIImpactFeedbackGenerator(style: .medium)
    // Hapting settings
    lazy var hapticFeedback = settingsStorage.safeGetData().hapticFeedback
    
    var updaterHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = conversionView
        
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // lock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        // load data from UserDefaults to picker and slider
        getConversionSettings()
        // animate popover
        conversionView.animateIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save conversion data to UserDefaults
        saveConversionSettings()
        // unlock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.allButUpsideDown, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    // MARK: - Methods
    
    fileprivate func setupGestures() {
        // tap outside popup(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        // swipe up for dismiss
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        swipeUp.cancelsTouchesInView = false
        self.view.addGestureRecognizer(swipeUp)
    }
    
    // Update conversion values
    fileprivate func getConversionSettings() {
        // get data from UserDefaults
        let conversionSettings = conversionStorage.safeGetData()
        let mainRow: Int = ConversionSystemsEnum.allCases.firstIndex(of: conversionSettings.systemMain) ?? 1 // default decimal for main
        let converterRow: Int = ConversionSystemsEnum.allCases.firstIndex(of: conversionSettings.systemConverter) ?? 0 // default binary for converter
        // Picker component
        // 0 - main
        // 1 - converter
        picker.selectRow(mainRow, inComponent: 0, animated: false)
        picker.selectRow(converterRow, inComponent: 1, animated: false)
        
        // Slider label
        labelValue.text = "\(Int(conversionSettings.numbersAfterPoint))"
        
        // Slider
        slider.value = Float(conversionSettings.numbersAfterPoint) / 4
        sliderOldValue = slider.value
    }
    
    fileprivate func saveConversionSettings() {
        // Picker  component
        // 0 - main
        // 1 - converter
        let mainSelectedRow = picker.selectedRow(inComponent: 0)
        let converterSelectedRow = picker.selectedRow(inComponent: 1)
        let systemMainNew = ConversionSystemsEnum(rawValue: picker.pickerView(picker, titleForRow: mainSelectedRow, forComponent: 0)!)
        let systemConverterNew = ConversionSystemsEnum(rawValue: picker.pickerView(picker, titleForRow: converterSelectedRow, forComponent: 1)!)
        // Slider
        let sliderValue = slider.value.rounded()
        
        // PCalcViewController delegate fo handling changing of mainSystem
        guard delegate != nil else {
            // set data to UserDefaults
            let newConversionSettings = ConversionSettings(systMain: systemMainNew!, systConverter: systemConverterNew!, number: Int(sliderValue) * 4)
            conversionStorage.saveData(newConversionSettings)
            return
        }
        
        // set last mainLabel system buffer
        let conversionSettings = conversionStorage.loadData()
        let buffSavedMainLabel = conversionSettings?.systemMain
        // set data to UserDefaults
        let newConversionSettings = ConversionSettings(systMain: systemMainNew!, systConverter: systemConverterNew!, number: Int(sliderValue) * 4)
        conversionStorage.saveData(newConversionSettings)
        // set data to PCalcViewController system states
        delegate?.updateSystemMain(with: systemMainNew!)
        delegate?.updateSystemCoverter(with: systemConverterNew!)
        // Handle changing of systems
        if buffSavedMainLabel != systemMainNew! {
            // set labels to 0 and update
            delegate!.clearLabels()
        } else {
            // if systemMain == last value of systemMain then just update values
            // update layout
            delegate!.updateAllLayout()
        }
        
        updaterHandler!()
        
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
    
    // MARK: - Actions
    
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

            if hapticFeedback {
                
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
