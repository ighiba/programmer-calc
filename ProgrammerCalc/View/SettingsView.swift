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
    
    // First section array
    let firstSection = [ NSLocalizedString("Appearance", comment: ""),
                         NSLocalizedString("Tapping sounds", comment: ""),
                         NSLocalizedString("Haptic feedback", comment: "")]
    // Second section array
    let otherSection = [NSLocalizedString("About app", comment: "")]
    
    
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
        switch section {
        case 1:
            return otherSection.count
        default:
            return firstSection.count
        }
    }
    // Returns cell for section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AppSettingsCell()
        let title = indexPath.section == 0 ? firstSection[indexPath.row] : otherSection[indexPath.row]
        
        // init cell w or w/o switcher
        switch indexPath {
        case [0,0]:
            // Appearance cell
            cell = AppSettingsCell(style: .default, reuseIdentifier: "cellId", label: title, switcher: false)
            cell.accessoryType = .disclosureIndicator
        case [0,1], [0,2]:
            // Tapping sound, Haptics
            cell = AppSettingsCell(style: .default, reuseIdentifier: "cellId", label: title, switcher: true)
        default:
            // About app
            cell = AppSettingsCell(style: .default, reuseIdentifier: "cellId", label: title, switcher: false)
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
        
        // Section 1 handling
        switch indexPath {
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

