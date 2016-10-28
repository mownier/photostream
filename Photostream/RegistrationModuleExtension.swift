//
//  RegistrationModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension RegistrationPresenter {
    
    var router: RegistrationWireframe? {
        return (wireframe as? RegistrationWireframe)
    }
    
    func exit() {
        router?.pop(controller: view.controller)
    }
    
    func presentHome() {
        router?.changeHomeAsRoot(in: view.controller?.view.window)
    }
}

extension RegistrationWireframe {
    
    static func createViewController() -> RegistrationViewController {
        let sb = UIStoryboard(name: "RegistrationModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegistrationViewController")
        return vc as! RegistrationViewController
    }
    
    func push(controller: UIViewController, from: UIViewController?) {
        guard let nav = from?.navigationController else {
            return
        }
    
        nav.pushViewController(controller, animated: true)
    }
    
    func pop(controller: UIViewController?) {
        guard let nav = controller?.navigationController else {
            return
        }
        
        let _ = nav.popViewController(animated: true)
    }
    
    func changeHomeAsRoot(in window: UIWindow?) {
        guard window != nil else {
            return
        }
        let homeWireframe = HomeWireframe()
        homeWireframe.rootWireframe = root
        homeWireframe.navigateHomeInterfaceFromWindow(window!)
    }
}
