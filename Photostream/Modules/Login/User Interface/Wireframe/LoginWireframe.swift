//
//  LoginWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class LoginWireframe: LoginWireframeInput {

    weak var loginViewController: LoginViewController!
    var loginPresenter: LoginPresenter!
    var rootWireframe: RootWireframe!
    
    init() {
        let presenter = LoginPresenter()
        let service = AuthenticationAPIFirebase()
        let interactor = LoginInteractor(service: service)
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        
        self.loginPresenter = presenter
    }
    
    func navigateLoginInterfaceFromWindow(window: UIWindow!) {
        let sb = UIStoryboard(name: "LoginModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginViewController = vc
        loginPresenter.view = vc
        vc.presenter = loginPresenter
        rootWireframe.showRootViewController(vc, window: window)
    }
    
    func navigateHomeInterface() {
        // TODO: Present home interface
    }
    
    func navigateRegistrationInterface() {
        let registrationWireframe = RegistrationWireframe()
        registrationWireframe.navigateRegistrationInterfaceFromViewController(loginViewController)
    }
}
