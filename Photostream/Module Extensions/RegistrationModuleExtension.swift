//
//  RegistrationModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension RegistrationModuleInterface {
    
    fileprivate var presenter: RegistrationPresenterInterface? {
        return self as? RegistrationPresenterInterface
    }
    
    func exit() {
        presenter?.wireframe.pop(controller: presenter?.view.controller)
    }
    
    func presentHome() {
        let viewController = presenter?.view.controller
        presenter?.wireframe.changeHomeAsRoot(in: viewController?.view.window)
    }
}

extension RegistrationWireframe {
    
    static func createViewController() -> RegistrationViewController {
        let sb = UIStoryboard(name: "RegistrationModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegistrationViewController")
        return vc as! RegistrationViewController
    }
}

extension RegistrationWireframeInterface {
    
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
        
        let vc = HomeWireframe.viewController
        let wireframe = HomeWireframe(root: root, view: vc)
        wireframe.attachRoot(with: vc, in: window!)
        wireframe.loadModuleDependency(with: vc)
    }
}
