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
    var loginViewController: LoginViewController {
        let sb = UIStoryboard(name: "LoginModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController")
        return vc as! LoginViewController
    }

    init() {
        self.appWireframe = AppWireframe()
    }

    func attachRootViewControllerInWindow(_ window: UIWindow!) {
        if isOK() {
            let homeWireframe = HomeWireframe()
            homeWireframe.appWireframe = appWireframe
            homeWireframe.navigateHomeInterfaceFromWindow(window)
        } else {
            let loginWireframe = LoginWireframe(view: loginViewController)
            loginWireframe.appWireframe = appWireframe
            loginWireframe.attachAsNavigationRoot(in: window)
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
