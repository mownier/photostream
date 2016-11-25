//
//  PhotoPickerViewDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoPickerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex > 0 else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        return pages[previousIndex]
    }
}
