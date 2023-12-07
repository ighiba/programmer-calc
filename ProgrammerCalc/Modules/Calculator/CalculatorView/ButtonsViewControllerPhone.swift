//
//  ButtonsViewControllerPhone.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol ButtonsContainerControllerProtocol: UIViewController {
    func disableNumericButtons(withForbiddenDigits forbiddenDigits: Set<String>)
}

// MARK: - iPhone

class ButtonsViewControllerPhone: UIPageViewController, ButtonsContainerControllerProtocol {

    // MARK: - Properties
    
    let arrayButtonsStack: [CalcButtonsPage] = [CalcButtonsAdditional(), CalcButtonsMain()]
    let calcButtonsViewControllers: [CalcButtonsViewController]
    
    // MARK: - Init
    
    init() {
        self.calcButtonsViewControllers = arrayButtonsStack.map { CalcButtonsViewController(buttonsPage: $0) }
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.setViewControllers([calcButtonsViewControllers[1]], direction: .forward, animated: false, completion: nil)
        self.dataSource = self
        self.delegate = self
        self.delaysContentTouches = false
        
        //let pageControl = configurePageControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calcButtonsViewControllers.forEach { $0.view.layoutSubviews() }
    }

    // MARK: - Methods
    
    private func configurePageControl() -> UIPageControl {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.currentPageIndicatorTintColor = .systemGray
        
        return pageControl
    }
    
    func disableNumericButtons(withForbiddenDigits forbiddenDigits: Set<String>) {
        arrayButtonsStack.forEach { $0.disableNumericButtons(withForbiddenDigits: forbiddenDigits) }
    }
}

// MARK: - DataSource

extension ButtonsViewControllerPhone: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CalcButtonsViewController else { return nil }
        
        if let index = calcButtonsViewControllers.firstIndex(of: viewController), index > 0 {
            return calcButtonsViewControllers[index - 1]
        }

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CalcButtonsViewController else { return nil }
        
        if let index = calcButtonsViewControllers.firstIndex(of: viewController), index < arrayButtonsStack.count - 1 {
            return calcButtonsViewControllers[index + 1]
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayButtonsStack.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
}

// MARK: - UIPageViewController

extension ButtonsViewControllerPhone {
    
    var delaysContentTouches: Bool {
        get {
            var isAllowed = true
            view.subviews.compactMap({ $0 as? UIScrollView }).forEach({ isAllowed = $0.delaysContentTouches })
            return isAllowed
        }
        set {
            view.subviews.compactMap({ $0 as? UIScrollView }).forEach({ $0.delaysContentTouches = newValue })
        }
    }
    
    func setPageControl(isVisible: Bool) {
        view.subviews.compactMap({ $0 as? UIPageControl }).forEach({ $0.isHidden = !isVisible })
    }
    
    func setPageControl(currentPage: Int) {
        view.subviews.compactMap({ $0 as? UIPageControl }).forEach({ $0.currentPage = currentPage })
    }
}
