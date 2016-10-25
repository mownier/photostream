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
    
    func navigateToRegistration() {
        guard let controller = loginPresenter.view?.controller else {
            return
        }
        
        let vc = RegistrationWireframe.createViewController()
        let registrationWireframe = RegistrationWireframe(view: vc)
        registrationWireframe.rootWireframe = rootWireframe
        registrationWireframe.push(from: controller)
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

