//
//  UIPageViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

extension UIPageViewController {
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
}
