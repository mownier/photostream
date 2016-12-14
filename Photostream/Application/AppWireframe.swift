//
//  AppWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class AppWireframe: RootWireframeInterface, RootWireframe {
    
    var window: UIWindow!
    
    func showRoot(with viewController: UIViewController, in window: UIWindow) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.setNavigationBarHidden(true, animated: false)
        window.rootViewController = nav
    }
}
