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
    func refreshCalcButtons() // implement if UIPageViewController
    func updateButtonsIsEnabled(by forbiddenValues: Set<String>)
}

// MARK: - iPhone

class ButtonsViewControllerPhone: UIPageViewController, ButtonsContainerControllerProtocol {

    // MARK: - Properties
    
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
    
    // MARK: - Init
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)

        self.setViewControllers([calcButtonsViewControllers[1]], direction: .forward, animated: false, completion: nil)
        self.dataSource = self
        self.delegate = self
        
        // Allow interaction with content(buttons) without delay
        self.delaysContentTouches = false
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.currentPageIndicatorTintColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSubviews() {
        for controller in calcButtonsViewControllers {
            controller.view.layoutSubviews()
        }
    }
    
    // MARK: - Methods
    
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
        arrayButtonsStack.forEach { page in
            page.updateButtonIsEnabled(by: forbiddenValues)
        }
    }
}

// MARK: - DataSource

extension ButtonsViewControllerPhone: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Load vc before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //touchHandleLabelHighlight()
        
        guard let viewController = viewController as? CalcButtonsViewController else { return nil }
        if let index = calcButtonsViewControllers.firstIndex(of: viewController), index > 0 {
            return calcButtonsViewControllers[index - 1]
        }

        return nil
    }
    
    // Load vc after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // handle highlighting of labels when page changes
        //touchHandleLabelHighlight()
        
        guard let viewController = viewController as? CalcButtonsViewController else { return nil }
        if let index = calcButtonsViewControllers.firstIndex(of: viewController), index < arrayButtonsStack.count - 1 {
            return calcButtonsViewControllers[index + 1]
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
            view.subviews.compactMap { $0 as? UIScrollView }.forEach { isAllowed = $0.delaysContentTouches }
            return isAllowed
        }
        set {
            view.subviews.compactMap { $0 as? UIScrollView }.forEach { $0.delaysContentTouches = newValue }
        }
    }
    
    // Change page control visibility by bool
    func setPageControl(visibile: Bool) {
        view.subviews.compactMap { $0 as? UIPageControl }.forEach { $0.isHidden = !visibile }
    }
    
    // Change page control current page
    func setPageControlCurrentPage(count currentPage: Int) {
        view.subviews.compactMap { $0 as? UIPageControl }.forEach { $0.currentPage = currentPage }
    }
}

