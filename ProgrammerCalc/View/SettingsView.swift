//
//  SettingsView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsView: UITableView {
    
    // SettingsViewController delegate
    var controllerDelegate: SettingsViewControllerDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    
    // Number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard controllerDelegate != nil else {
            return 0
        }
        
        switch section {
        case 1:
            return controllerDelegate!.otherSection.count
        default:
            return controllerDelegate!.firstSection.count
        }
    }
    
    // Returns cell for section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SettingsCell()
        
        guard controllerDelegate != nil else {
            return cell
        }

        // init cell by arrays
        switch indexPath {
        case [0,0]:
            // Appearance cell
            cell = controllerDelegate!.firstSection[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        case [0,1], [0,2]:
            // Tapping sound, Haptics
            cell = controllerDelegate!.firstSection[indexPath.row]
        case [1,0]:
            // About app
            cell = controllerDelegate!.otherSection[indexPath.row]
        default:
            // return empty cell
            break
        }
        
        return cell
    }
    // Numer of sections Main + other
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard controllerDelegate != nil else {
            return
        }
        
        // Tap on cell handling
        switch indexPath {
        case [0,0]:
            // Appearance
            controllerDelegate!.openAppearance()
            break
        case [1,0]:
            // About app
            controllerDelegate!.openAbout()
            break
        default:
            // do nothing
            break
        }
        
        // Handle deselection of row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

