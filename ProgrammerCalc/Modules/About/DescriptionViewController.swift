//
//  DescriptionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 03.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

private let margin: CGFloat = 20
private let navBarHeight: CGFloat = 44

class DescriptionViewController: StyledViewController {

    private let descriptionText = NSLocalizedString("DescriptionFullText", comment: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .systemBackground
        
        view.addSubview(descriptionLabel)
        
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
    
    // MARK: - Views
    
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
}
