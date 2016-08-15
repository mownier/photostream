//
//  LoginPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class LoginPresenter: LoginModuleInterface, LoginInteractorOutput {

    weak var view: LoginViewInterface!
    var interactor: LoginInteractorInput!
    var wireframe: LoginWireframe!

    func loginDidSucceed(user: User!) {
        wireframe.navigateHomeInterface()
    }

    func loginDidFail(error: NSError!) {
        view.showLoginError(error)
    }

    func login(email: String!, password: String!) {
        interactor.login(email, password: password)
    }

    func showRegistration() {
        wireframe.navigateRegistrationInterface()
    }

    func showErrorAlert(error: NSError!) {
        wireframe.navigateLoginErrorAlert(error)
    }
}
