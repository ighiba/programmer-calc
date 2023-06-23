//
//  ConversionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, ConversionInput {
    
    // MARK: - Properties
    
    var output: ConversionOutput!

    lazy var conversionView = ConversionView()
    lazy var picker: ConversionPicker = conversionView.mainPicker
    lazy var slider: UISlider = conversionView.digitsAfterSlider
    lazy var labelValue: UILabel = conversionView.sliderValueDigit
    private var sliderOldValue: Float = 2.0

    // Haptic feedback generator
    let generator = UIImpactFeedbackGenerator(style: .medium)

    
    // MARK: - Layout
    
    override func loadView() {
        self.view = conversionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
        output.obtainConversionSettings()
        conversionView.animateIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveConversionSettings()
        AppDelegate.AppUtility.unlockPortraitOrientation()
    }
    
    // MARK: - Methods
    
    private func setupGestures() {
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
    
    func mainPickerSelect(row: Int) {
        picker.selectRow(row, inComponent: 0, animated: false)
    }
    
    func converterPickerSelect(row: Int) {
        picker.selectRow(row, inComponent: 1, animated: false)
    }
    
    func setLabelValueText(_ text: String) {
        labelValue.text = text
    }
    
    func setSliderValue(_ value: Float) {
        slider.value = value
        sliderOldValue = slider.value
    }
    
    func hapticImpact() {
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func saveConversionSettings() {
        let mainRow = picker.selectedRow(inComponent: 0)
        let selectedRow = picker.selectedRow(inComponent: 1)
        let sliderValue = slider.value.rounded()
        output.saveConversionSettings(mainRow: mainRow, converterRow: selectedRow, sliderValue: sliderValue)
    }
    
    private func dismissVC() {
        conversionView.animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func isGestureNotInContainer( gesture: UIGestureRecognizer) -> Bool {
        conversionView.container.updateConstraints()
        let currentLocation: CGPoint = gesture.location(in: conversionView.container)
        let containerBounds: CGRect = conversionView.container.bounds

        return !containerBounds.contains(currentLocation)
    }
    
    // MARK: - Actions
    
    @objc func doneButtonTapped( sender: UIButton) {
        dismissVC()
    }
    
    // Swipe up to exit
    @objc func handleSwipe( sender: UISwipeGestureRecognizer) {
        let swipeNotInContainer: Bool = isGestureNotInContainer(gesture: sender)
        if swipeNotInContainer {
            dismissVC()
        }
    }
    
    @objc func tappedOutside( sender: UITapGestureRecognizer) {
        let taphNotInContainer: Bool = isGestureNotInContainer(gesture: sender)
        if taphNotInContainer {
            dismissVC()
        }
    }

    @objc func sliderValueChanged( sender: UISlider) {
        let sliderNewValue = sender.value.rounded()
        if sliderOldValue != sliderNewValue {
            output.sliderValueDidChanged(sliderNewValue)
            sliderOldValue = sliderNewValue
        }
    }
}
