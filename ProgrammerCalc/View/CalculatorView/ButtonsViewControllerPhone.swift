//
//  ButtonsViewControllerPhone.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol ButtonsContainerControllerProtocol: UIViewController {
    func layoutSubviews()
    func refreshCalcButtons()
    func updateButtonsIsEnabled(by forbiddenValues: Set<String>)
}

// MARK: - iOS

class ButtonsViewControllerPhone: UIPageViewController, ButtonsContainerControllerProtocol {

    let arrayButtonsStack: [CalcButtonsPage] = [ CalcButtonsAdditional(), CalcButtonsMain() ]
    lazy var calcButtonsViewControllers: [CalcButtonsViewController] = {
        var buttonsVC = [CalcButtonsViewController]()
        for buttonsPage in arrayButtonsStack {
            let vc = CalcButtonsViewController(buttonsPage: buttonsPage)
            //vc.delegate = self
            buttonsVC.append(vc)
        }
        return buttonsVC
    }()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)

        self.setViewControllers([calcButtonsViewControllers[1]], direction: .forward, animated: false, completion: nil)
        self.dataSource = self
        self.delegate = self
        
        // Allow interaction with content(buttons) without delay
        self.delaysContentTouches = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSubviews() {
        for controller in calcButtonsViewControllers {
            controller.view.layoutSubviews()
        }
    }
    
    func refreshCalcButtons() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [self] in
            let currentPage = (viewControllers?.first as? CalcButtonsViewController) ?? calcButtonsViewControllers[1]
            let currentPageCount = calcButtonsViewControllers.firstIndex(of: currentPage) ?? 1

            setViewControllers([currentPage], direction: .forward, animated: false, completion: nil)
            // update selected dot for uipagecontrol
            setPageControlCurrentPage(count: currentPageCount)
        })
    }
    
    func updateButtonsIsEnabled(by forbiddenValues: Set<String>) {
        for page in arrayButtonsStack {
            page.updateButtonIsEnabled(by: forbiddenValues)
        }
    }
}

// MARK: - DataSource

extension ButtonsViewControllerPhone: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Load vc before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // handle highlighting of labels when page changes
        //touchHandleLabelHighlight()
        
        guard let viewController = viewController as? CalcButtonsViewController else {return nil}
        if let index = calcButtonsViewControllers.firstIndex(of: viewController) {
            if index > 0 {
                return calcButtonsViewControllers[index - 1]
            }
        }

        return nil
    }
    
    // Load vc after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // handle highlighting of labels when page changes
        //touchHandleLabelHighlight()
        
        guard let viewController = viewController as? CalcButtonsViewController else {return nil}
        if let index = calcButtonsViewControllers.firstIndex(of: viewController) {
            if index < arrayButtonsStack.count - 1 {
                return calcButtonsViewControllers[index + 1]
            }
        }
        
        return nil
    }
    
    // How much pages will be
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayButtonsStack.count
    }
    
    // Starting index for dots
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
}

// MARK: - UIPageViewController

extension ButtonsViewControllerPhone {
    // Allows or disallows scroll pages and interact with content
    var delaysContentTouches: Bool {
        get {
            var isAllowed: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isAllowed = subView.delaysContentTouches
                }
            }
            return isAllowed
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.delaysContentTouches = newValue
                }
            }
        }
    }
    
    // Change page control visibility by bool
    func setPageControl(visibile: Bool) {
        for case let pageControl in self.view.subviews where pageControl is UIPageControl {
            if visibile {
                pageControl.isHidden = false
            } else {
                pageControl.isHidden = true
            }
        }
    }
    
    // Change page control current page
    func setPageControlCurrentPage(count currentPage: Int) {
        for case let pageControl in self.view.subviews where pageControl is UIPageControl {
            (pageControl as! UIPageControl).currentPage = currentPage
        }
    }
}

