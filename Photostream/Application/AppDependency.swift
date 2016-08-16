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

    var rootWireframe: RootWireframe!

    init() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {}

        self.rootWireframe = RootWireframe()
    }

    func attachRootViewControllerInWindow(window: UIWindow!) {
//        if isOK() {
//            let homeWireframe = HomeWireframe()
//            homeWireframe.rootWireframe = rootWireframe
//            homeWireframe.navigateHomeInterfaceFromWindow(window)
//        } else {
//            let loginWireframe = LoginWireframe()
//            loginWireframe.rootWireframe = rootWireframe
//            loginWireframe.navigateLoginInterfaceFromWindow(window)
//        }
        
        // Temporary
        let homeWireframe = HomeWireframe()
        homeWireframe.rootWireframe = rootWireframe
        homeWireframe.navigateHomeInterfaceFromWindow(window)
    }

    private func isOK() -> Bool {
        if let _ = FIRAuth.auth()?.currentUser {
            return true
        } else {
            return false
        }
    }
}
