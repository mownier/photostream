//
//  LoginModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension LoginPresenter {
    
    var router: LoginWireframe? {
        return wireframe as? LoginWireframe
    }
    
    func presentRegistration() {
        router?.navigateToRegistration()
    }
    
    func presentHome() {
        router?.navigateToHome()
    }
}

extension LoginWireframe {
    
    class func createViewController() -> LoginViewController {
        let sb = UIStoryboard(name: "LoginModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController")
        return vc as! LoginViewController
    }
    
    func navigateToRegistration() {
        guard let controller = loginPresenter.view?.controller else {
            return
        }
        
        let vc = RegistrationWireframe.createViewController()
        var wireframe = RegistrationWireframe(view: vc)
        wireframe.presenter.wireframe.root = rootWireframe
        vc.presenter = wireframe.presenter
        wireframe.push(from: controller)
    }
    
    func navigateToHome() {
        guard let controller = loginPresenter.view?.controller else {
            return
        }
        
        let homeWireframe = HomeWireframe()
        homeWireframe.rootWireframe = rootWireframe
        homeWireframe.navigateHomeInterfaceFromWindow(controller.view.window)
    }
}

