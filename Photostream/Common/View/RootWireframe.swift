//
//  RootWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class RootWireframe: AnyObject {

    func showRootViewController(_ viewController: UIViewController, window: UIWindow) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.setNavigationBarHidden(true, animated: false)
        window.rootViewController = nav
    }

    func navigateCommentsModule(_ viewController: UIViewController, shouldComment: Bool) {
        let wireframe = CommentWireframe()
        wireframe.rootWireframe = self
        wireframe.navigateCommentInterfaceFromViewController(viewController, shouldComment: shouldComment)
    }
}
