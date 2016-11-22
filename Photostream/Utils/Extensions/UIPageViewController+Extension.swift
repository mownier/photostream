//
//  UIPageViewController+Extension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UIPageViewController {
    
    var topViewController: UIViewController? {
        guard let controllers = viewControllers, controllers.count > 0 else {
            return nil
        }
        
        return controllers[0]
    }
}
