//
//  AppearanceViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol AppearanceViewControllerDelegate: AnyObject {
    var isSystemAppearance: Bool { get set }
    var currentStyle: StyleType { get set }
    var checkmarkedIndexPath: IndexPath { get set }
    func changeUseSystemStyle()
    func changeStyle(to: Int)
}

class AppearanceViewController: PCalcTableViewController, AppearanceViewControllerDelegate {
    
    // MARK: - Properties
    
    // Table view
    lazy var appearanceView = AppearanceView(frame: CGRect(), style: .insetGrouped)
    // Index of table checkmarks
    var checkmarkedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    // Appearance state
    var isSystemAppearance: Bool = false {
        didSet {
            // reload table
            self.tableView.reloadData()
        }
    }
    
    // Appearance style
    var currentStyle: StyleType {
        get {
            return styleStorage.safeGetStyleData()
        }
        set {
            return styleStorage.saveData(newValue)
        }
    }
    
    // Style storage
    var styleStorage: StyleStorageProtocol = StyleStorage()
    // Style factory
    var styleFactory: StyleFactory = StyleFactory()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup title
        self.title = NSLocalizedString("Appearance", comment: "")
        
        // get style state
        self.isSystemAppearance = styleStorage.safeGetSystemStyle()
        // get style
        self.currentStyle = styleStorage.safeGetStyleData()
        // get checkmark pos depends on style
        updateCheckMarkIndex()
        
        appearanceView.controllerDelegate = self
        self.tableView = appearanceView
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // lock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        // get style state
        self.isSystemAppearance = styleStorage.safeGetSystemStyle()
    }
        
    // MARK: - Methods
    
    func updateCheckMarkIndex() {
        let row = StyleType.allCases.firstIndex(of: currentStyle) ?? 1
        checkmarkedIndexPath = IndexPath(row: row, section: 1)
    }

    @objc func changeUseSystemStyle() {
        isSystemAppearance.toggle()
        // save new value to storage
        styleStorage.saveState(isSystemAppearance)
        
        // change style depends on state
        if isSystemAppearance {
            updateStyleBy(UIScreen.main.traitCollection.userInterfaceStyle)
        }
        updateCheckMarkIndex()
        self.tableView.reloadData()
        self.view.layoutSubviews()
        // change navbar tint
        let style = styleFactory.get(style: currentStyle)
        self.navigationController?.navigationBar.tintColor = style.tintColor
        // update PCalcView
        updateRootViewLayoutSubviews()
    }
    
    func changeStyle(to number: Int) {
        // change style in storage
        let styleTypeArray = StyleType.allCases
        let styleType = styleTypeArray[number]
        styleStorage.saveData(styleType)
        updateStyle()
    }
    
    private func updateStyleBy(_ interface: UIUserInterfaceStyle) {
        switch interface {
        case .light, .unspecified:
            // light mode detected
            styleStorage.saveData(.light)
        case .dark:
            // dark mode detected
            styleStorage.saveData(.dark)
        @unknown default:
            // light mode if unknown
            styleStorage.saveData(.light)
        }
        self.view.window?.overrideUserInterfaceStyle = .unspecified
    }
    
    func updateStyle() {
        // Apply style
        let styleName = styleStorage.safeGetStyleData()
        let style = styleFactory.get(style: styleName)
        
        let interfaceStyle: UIUserInterfaceStyle
        // change style depends on state
        if isSystemAppearance {
            updateStyleBy(UIScreen.main.traitCollection.userInterfaceStyle)
            self.view.window?.layoutIfNeeded()
        } else {
            if styleName == .light {
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

