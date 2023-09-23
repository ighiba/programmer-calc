//
//  DescriptionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 03.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class DescriptionViewController: StyledViewController {
    
    private let margin: CGFloat = 20
    private let navBarHeight: CGFloat = 44

    private let descriptionText = NSLocalizedString("DescriptionFullText", comment: "")

    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: CGRect(
            x: margin,
            y: margin + view.safeAreaInsets.top + navBarHeight,
            width: UIScreen.main.bounds.width - margin * 2,
            height: UIScreen.main.bounds.height - margin * 2)
        )

        let paragraphStyle = makeParagraphStyle()

        let attributedString = NSAttributedString(string: descriptionText, attributes: [.paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureViews()
    }
    
    private func setupViews() {
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .systemBackground
        
        view.addSubview(descriptionLabel)
    }
    
    private func configureViews() {
        descriptionLabel.text = descriptionText
        descriptionLabel.sizeToFit()
    }
    
    private func makeParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 5.0
        paragraphStyle.hyphenationFactor = 1.0
        return paragraphStyle
    }
}
