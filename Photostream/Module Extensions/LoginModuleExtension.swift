//
//  LoginModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension LoginModuleInterface {
    
    fileprivate var presenter: LoginPresenterInterface? {
        return self as? LoginPresenterInterface
    }
    
    func presentRegistration() {
        presenter?.wireframe.pushRegistration(from: presenter?.view.controller)
    }
    
    func presentHome() {
        let viewController = presenter?.view.controller
        presenter?.wireframe.changeRootAsHome(in: viewController?.view.window)
    }
}

extension LoginWireframe {
    
    static func createViewController() -> LoginViewController {
        let sb = UIStoryboard(name: "LoginModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController")
        return vc as! LoginViewController
    }
}

extension LoginWireframeInterface {
    
    func pushRegistration(from controller: UIViewController?) {
        guard controller != nil else {
            return
        }
        
        let vc = RegistrationWireframe.createViewController()
        let wireframe = RegistrationWireframe(root: root, view: vc)
        wireframe.push(controller: vc, from: controller!)
    }
    
    func changeRootAsHome(in window: UIWindow?) {
        guard window != nil else {
            return
        }
        
        let vc = HomeWireframe.viewController
        let wireframe = HomeWireframe(root: root, view: vc)
        wireframe.attachRoot(with: vc, in: window!)
        wireframe.loadModuleDependency(with: vc)
    }
}

