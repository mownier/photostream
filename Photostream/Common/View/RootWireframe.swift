//
//  RootWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class RootWireframe: AnyObject {

    func showRootViewController(viewController: UIViewController, window: UIWindow) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.setNavigationBarHidden(true, animated: false)
        window.rootViewController = nav
    }
}
