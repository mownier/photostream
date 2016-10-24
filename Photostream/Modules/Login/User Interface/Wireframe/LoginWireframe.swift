//
//  LoginWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class LoginWireframe: LoginWireframeInterface {

    var loginPresenter: LoginPresenterInterface
    var rootWireframe: RootWireframe!

    required init(view: LoginViewInterface) {
        let presenter = LoginPresenter()
        let service = AuthenticationServiceProvider()
        let interactor = LoginInteractor(service: service)
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.view = view
        view.presenter = presenter

        self.loginPresenter = presenter
        self.loginPresenter.wireframe = self
    }
    
    func attachAsNavigationRoot(in window: UIWindow) {
        guard let controller = loginPresenter.view?.controller else {
            return
        }
        
        rootWireframe.showRootViewController(controller, window: window)
    }
    
    func showErrorAlert(title: String, message: String) {
        guard let controller = loginPresenter.view?.controller else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
}

extension LoginWireframe: LoginWireframeModuleNavigator {
    
    func navigateToRegistration() {
        guard let controller = loginPresenter.view?.controller else {
            return
        }
        
        let registrationWireframe = RegistrationWireframe()
        registrationWireframe.navigateRegistrationInterfaceFromViewController(controller)
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
