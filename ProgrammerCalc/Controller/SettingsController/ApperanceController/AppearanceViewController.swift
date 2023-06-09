//
//  AppearanceViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol AppearanceViewControllerDelegate: AnyObject {
    var checkmarkedIndexPath: IndexPath { get set }
    func changeUseSystemStyle()
    func changeStyle(to: Int)
    func isUsingSystemAppearance() -> Bool
}

class AppearanceViewController: PCalcTableViewController, AppearanceViewControllerDelegate {
    
    // MARK: - Properties
    
    // Table view
    lazy var appearanceView = AppearanceView(frame: CGRect(), style: .insetGrouped)
    // Index of table checkmarks
    var checkmarkedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    // Style storage
    //var styleStorage: StyleStorageProtocol = StyleStorage()
    private let storage = CalculatorStorage()
    // Style factory
    var styleFactory: StyleFactory = StyleFactory()
    
    private let styleSettings: StyleSettings = StyleSettings.shared
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup title
        self.title = NSLocalizedString("Appearance", comment: "")
        
        // get checkmark pos depends on style
        updateCheckMarkIndex()
        
        appearanceView.controllerDelegate = self
        self.tableView = appearanceView
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
    }
        
    // MARK: - Methods
    
    func updateCheckMarkIndex() {
        let row = StyleType.allCases.firstIndex(of: styleSettings.currentStyle) ?? 1
        checkmarkedIndexPath = IndexPath(row: row, section: 1)
    }

    @objc func changeUseSystemStyle() {
        styleSettings.isUsingSystemAppearance.toggle()
        // save new value to storage
        storage.saveData(styleSettings)
        
        // change style depends on state
        if styleSettings.isUsingSystemAppearance {
            updateStyleBy(UIScreen.main.traitCollection.userInterfaceStyle)
        }
        updateCheckMarkIndex()
        self.tableView.reloadData()
        self.view.layoutSubviews()
        // change navbar tint
        let style = styleFactory.get(style: styleSettings.currentStyle)
        self.navigationController?.navigationBar.tintColor = style.tintColor
        // update PCalcView
        updateRootViewLayoutSubviews()
    }
    
    func changeStyle(to number: Int) {
        // change style in storage
        let styleTypeArray = StyleType.allCases
        let newStyle = styleTypeArray[number]
        // change in shared instance
        styleSettings.currentStyle = newStyle
        storage.saveData(styleSettings)
        updateStyle()
    }
    
    func isUsingSystemAppearance() -> Bool {
        return styleSettings.isUsingSystemAppearance
    }
    
    private func updateStyleBy(_ interface: UIUserInterfaceStyle) {
        switch interface {
        case .light, .unspecified:
            // light mode detected
            styleSettings.currentStyle = .light
        case .dark:
            // dark mode detected
            styleSettings.currentStyle = .dark
        @unknown default:
            // light mode if unknown
            styleSettings.currentStyle = .dark
        }
        storage.saveData(styleSettings)
        self.view.window?.overrideUserInterfaceStyle = .unspecified
    }
    
    func updateStyle() {
        // Apply style
        let styleType = styleSettings.currentStyle
        let style = styleFactory.get(style: styleType)
        
        let interfaceStyle: UIUserInterfaceStyle
        // change style depends on state
        if styleSettings.isUsingSystemAppearance {
            updateStyleBy(UIScreen.main.traitCollection.userInterfaceStyle)
            self.view.window?.layoutIfNeeded()
        } else {
            if styleType == .light {
                interfaceStyle = .light
            } else {
                interfaceStyle = .dark
            }
            
            // upddate all
            self.view.window?.overrideUserInterfaceStyle = interfaceStyle
            self.view.window?.layoutIfNeeded()
        }
        
        // change navbar tint
        self.navigationController?.navigationBar.tintColor = style.tintColor
        // update PCalcView
        UIView.animate(withDuration: 0.3, animations: {
            self.updateRootViewLayoutSubviews()
        })

    }
    
    private func updateRootViewLayoutSubviews() {
        if let PCalcVC = self.view.window?.rootViewController as? PCalcViewController {
            PCalcVC.view.layoutSubviews()
            PCalcVC.calcView.layoutSubviews()
            PCalcVC.calcButtonsViewControllers.forEach { vc in
                vc.view.layoutSubviews()
            }
        }
    }
}

// MARK: - TableViewDelegate

extension AppearanceViewController {
    // Actions on tap for section 1
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        if checkmarkedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        // set checkmark on new cell
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // remove from old
        tableView.cellForRow(at: checkmarkedIndexPath)?.accessoryType = .none
        
        // update checkmarkedIndexPath
        checkmarkedIndexPath = indexPath
        
        self.changeStyle(to: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

