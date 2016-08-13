//
//  AppDependency.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class AppDependency: AnyObject {

    var loginWireframe: LoginWireframe!
    var rootWireframe: RootWireframe!
    
    init() {
        let rootWireframe = RootWireframe()
        let loginWireframe = LoginWireframe()
        loginWireframe.rootWireframe = rootWireframe
        
        self.rootWireframe = rootWireframe
        self.loginWireframe = loginWireframe
    }
    
    func attachRootViewControllerInWindow(window: UIWindow!) {
        loginWireframe.navigateLoginInterfaceFromWindow(window)
    }
}
