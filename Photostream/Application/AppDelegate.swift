//
//  AppDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 02/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()

        let dependency = AppDependency()
        dependency.appWireframe.window = window!
        dependency.attachRootViewControllerInWindow(window)

        Fabric.with([Crashlytics.self])
        return true
    }
}
