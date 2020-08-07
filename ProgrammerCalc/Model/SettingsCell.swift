//
//  SettingsCell.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, label: String, switcher: Bool) {
        super.init(style: style, reuseIdentifier: label)
        
        // switchers for first section
        if switcher {
            let switcher = UISwitch(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            switcher.addTarget(nil, action: #selector(SettingsViewController.switcherToggled), for: .valueChanged)
            // default state true
            switcher.isOn = true
            self.accessoryView = switcher
            // disable selection style
            self.selectionStyle = .none
        }
        self.textLabel?.text = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
