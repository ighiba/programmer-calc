//
//  PreferenceCell.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

final class PreferenceCell: UITableViewCell {

    private let preferenceModel: PreferenceCellModel

    init(preferenceModel: PreferenceCellModel) {
        self.preferenceModel = preferenceModel
        super.init(style: .default, reuseIdentifier: preferenceModel.id)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        preferenceModel.setupAccessoryView(forCell: self)
    
        textLabel?.text = preferenceModel.text
        imageView?.image = preferenceModel.icon
    }
}
