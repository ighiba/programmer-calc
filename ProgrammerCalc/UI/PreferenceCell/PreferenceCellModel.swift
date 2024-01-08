//
//  PreferenceCellModel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

// MARK: - Default

class PreferenceCellModel: Identifiable {
    
    var id: String
    var text: String
    var icon: UIImage?

    init(id: String, text: String, icon: UIImage? = nil) {
        self.id = id
        self.text = text
        self.icon = icon
    }
    
    func setupAccessoryView(forCell cell: PreferenceCell) {
        cell.accessoryType = .none
    }
}

// MARK: - Switch

final class SwitchPreferenceCellModel: PreferenceCellModel {
    
    var isOn: Bool
    var switchValueDidChange: ((Bool) -> Void)?
    
    init(id: String, text: String, icon: UIImage? = nil, isOn: Bool = false, switchValueDidChange: ((Bool) -> Void)? = nil) {
        self.isOn = isOn
        self.switchValueDidChange = switchValueDidChange
        super.init(id: id, text: text, icon: icon)
    }
    
    override func setupAccessoryView(forCell cell: PreferenceCell) {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
        switcher.isOn = isOn
        cell.accessoryView = switcher
        cell.selectionStyle = .none
    }
    
    @objc func switcherValueChanged(_ sender: UISwitch) {
        isOn = sender.isOn
        switchValueDidChange?(sender.isOn)
    }
}

// MARK: - Checkmark

final class CheckmarkPreferenceCellModel: PreferenceCellModel {
    
    var isCheckmarked: Bool
    
    init(id: String, text: String, icon: UIImage? = nil, isCheckmarked: Bool = false) {
        self.isCheckmarked = isCheckmarked
        super.init(id: id, text: text, icon: icon)
    }
    
    override func setupAccessoryView(forCell cell: PreferenceCell) {
        cell.accessoryType = isCheckmarked ? .checkmark : .none
    }
}

// MARK: - Push

final class PushPreferenceCellModel: PreferenceCellModel {
    override func setupAccessoryView(forCell cell: PreferenceCell) {
        cell.accessoryType = .disclosureIndicator
    }
}
