//
//  AboutViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 19.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

protocol AboutViewControllerDelegate: AnyObject {
    func openDescription()
    func rateApp()
    func openContactForm()
    func getIconTint() -> UIColor
}

// MARK: - About VC

class AboutViewController: PCalcTableViewController, AboutViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    // Table view
    lazy var aboutView = AboutView(frame: CGRect(), style: .insetGrouped)
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup title
        self.title = NSLocalizedString("About app", comment: "")
        
        aboutView.controllerDelegate = self
        self.tableView = aboutView
        self.tableView.tintColor = self.navigationController?.navigationBar.tintColor
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
    }
    
    // MARK: - Methods
    
    func getIconTint() -> UIColor {
        let styleType = StyleSettings.shared.currentStyle
        let styleFactory = StyleFactory()
        let style = styleFactory.get(style: styleType)
        return style.tintColor
    }
    
    // Present Description
    func openDescription() {
        let vc = DescriptionViewController()
        vc.title = NSLocalizedString("Description", comment: "")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Rate app button
    func rateApp() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive} ) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }

    }

    // Contact us cell touch
    func openContactForm() {
        // Check mail services aviability
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            let model = UIDevice.current.model
            let systemVersion = UIDevice.current.systemVersion
            let appVersion = UIApplication.appVersion ?? "1.0"
            let buildNumber = UIApplication.buildNumber ?? "1"
            
            // Configure the fields of the interface
            composeVC.setToRecipients(["ighiba.dev@gmail.com"])
            composeVC.setSubject("Programmer's Calculator support")
            composeVC.setMessageBody("Model - \(model), OS - \(systemVersion), App version - \(appVersion)(\(buildNumber))", isHTML: false)
            
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Mail services are not available")
            return
        }
    }
    
    // Dismissing contact us form
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
