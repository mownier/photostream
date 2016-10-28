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
        router?.pop()
    }
    
    func presentHome() {
        router?.navigateToHome()
    }
}

extension RegistrationWireframe {
    
    static func createViewController() -> RegistrationViewController {
        let sb = UIStoryboard(name: "RegistrationModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegistrationViewController")
        return vc as! RegistrationViewController
    }
    
    func push(from: UIViewController) {
        guard let nav = from.navigationController,
            let controller = registrationPresenter.view?.controller else {
            return
        }
    
        nav.pushViewController(controller, animated: true)
    }
    
    func pop() {
        guard let nav = registrationPresenter.view?.controller?.navigationController else {
            return
        }
        
        let _ = nav.popViewController(animated: true)
    }
    
    func navigateToHome() {
        guard let controller = registrationPresenter.view?.controller else {
            return
        }
        
        let homeWireframe = HomeWireframe()
        homeWireframe.rootWireframe = rootWireframe
        homeWireframe.navigateHomeInterfaceFromWindow(controller.view.window)
    }
}
