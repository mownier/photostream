//
//  AppDependency.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseAuth

class AppDependency: AnyObject {

    var appWireframe: AppWireframe!

    init() {
        self.appWireframe = AppWireframe()
    }

    func attachRootViewControllerInWindow(_ window: UIWindow!) {
        if isOK() {
            let vc = HomeWireframe.viewController
            let wireframe = HomeWireframe(root: appWireframe, view: vc)
            wireframe.attachRoot(with: vc, in: window)
            wireframe.loadModuleDependency(with: vc)
        } else {
            let vc = LoginWireframe.createViewController()
            let loginWireframe = LoginWireframe(root: appWireframe, view: vc)
            loginWireframe.attachRoot(with: vc, in: window)
        }
    }

    fileprivate func isOK() -> Bool {
        if let _ = FIRAuth.auth()?.currentUser {
            return true
        } else {
            return false
        }
    }
}
