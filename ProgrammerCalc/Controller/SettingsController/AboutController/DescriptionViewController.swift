//
//  DescriptionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 03.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    let margin: CGFloat = 20

    let descriptionText: String = NSLocalizedString("DescriptionFullText", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = .systemBackground
        
        // add text to label
        descriptionLabel.text = descriptionText
        self.view.addSubview(descriptionLabel)
        descriptionLabel.sizeToFit()
    }
    
    // Updating navbar tint color if user changed system appearance
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Style factory
        let styleFactory: StyleFactory = StyleFactory()
        // change navbar tint
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        self.navigationController?.navigationBar.tintColor = style.tintColor
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
        
        label.textColor = .label

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


