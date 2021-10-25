//
//  AboutViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 19.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit
import MessageUI

protocol AboutViewControllerDelegate {
    // App version number
    var appVersion: String { get set }
    func openDescription()
    func openContactForm()
}

// MARK: - About VC

class AboutViewController: UITableViewController, AboutViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    // App version number
    var appVersion: String = "0.8"
    
    // Table view
    lazy var aboutView = AboutView(frame: CGRect(), style: .grouped)
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup title
        self.title = NSLocalizedString("About app", comment: "")
        
        aboutView.controllerDelegate = self
        self.tableView = aboutView
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // lock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)        
    }
    
    // MARK: - Methods
    
    // Present Description
    func openDescription() {
        let vc = DescriptionViewController()
        vc.title = NSLocalizedString("Description", comment: "")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // Contact us cell touch
    func openContactForm() {
        // Check mail services aviability
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            let model = UIDevice.current.model
            let systemVersion = UIDevice.current.systemVersion
            
            // Configure the fields of the interface
            composeVC.setToRecipients(["ighiba.dev@gmail.com"])
            composeVC.setSubject("ProgrammerCalc support")
            composeVC.setMessageBody("Model - \(model), OS - \(systemVersion), App version - \(appVersion)", isHTML: false)
            
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


// MARK: - Description VC

class DescriptionViewController: UIViewController {
    
    let margin: CGFloat = 20

    let descriptionText: String = NSLocalizedString("DescriptionFullText", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = .white
        
        // add text to label
        descriptionLabel.text = descriptionText
        
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.sizeToFit()
    }
    
    // MARK: - Label
    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: margin, y: margin+self.view.safeAreaInsets.top+44, width: UIScreen.main.bounds.width - margin*2, height: UIScreen.main.bounds.height - margin*2))
        
        // set attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 5.0
        paragraphStyle.hyphenationFactor = 1.0
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
        ]
        // set string
        let attributedString = NSAttributedString(string: descriptionText, attributes: attributes)
        label.attributedText = attributedString

        // set multiple lines
        label.numberOfLines = 0

        return label
    }()
    
    // MARK: - Setup Views
    
    func setupViews() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Constraints for description label
            descriptionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: margin + 44),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -margin),
        ])
    }
}

class HowToConvertViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = .white
    }
    
}

