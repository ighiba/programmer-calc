//
//  ModalViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.10.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol ModalView: UIView {
    var container: UIView { get }
    var doneButton: UIButton { get }
    func animateIn()
    func animateOut(completion: @escaping () -> Void)
}

class ModalViewController: UIViewController {
    
    var modalView: ModalView
    
    init(modalView: ModalView) {
        self.modalView = modalView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
        modalView.animateIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.unlockPortraitOrientation()
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutside), cancelsTouchesInView: false)
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe), direction: .up, cancelsTouchesInView: false)
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeUpGesture)
        
        view.isUserInteractionEnabled = true
    }
    
    func setupTargets() {
        modalView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    private func isGestureNotInContainer(gesture: UIGestureRecognizer) -> Bool {
        modalView.container.updateConstraints()
        let currentLocation: CGPoint = gesture.location(in: modalView.container)
        let containerBounds: CGRect = modalView.container.bounds

        return !containerBounds.contains(currentLocation)
    }
    
    private func dismissViewController() {
        modalView.animateOut { [weak self] in
            self?.dismiss(animated: false)
            self?.updateHandler()
        }
    }
    
    func updateHandler() {
        
    }
    
    // MARK: - Actions

    @objc func doneButtonTapped( sender: UIButton) {
        dismissViewController()
    }
    
    @objc func tappedOutside(_ sender: UITapGestureRecognizer) {
        if isGestureNotInContainer(gesture: sender) {
            dismissViewController()
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if isGestureNotInContainer(gesture: sender) {
            dismissViewController()
        }
    }
}
