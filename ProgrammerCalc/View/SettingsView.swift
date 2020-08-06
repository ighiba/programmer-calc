//
//  SettingsView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsView: SettingsTable {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    // TODO: Themes
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

