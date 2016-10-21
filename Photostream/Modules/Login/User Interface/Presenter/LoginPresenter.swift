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

    func loginDidSucceed(_ user: User!) {
        wireframe.navigateHomeInterface()
    }

    func loginDidFail(_ error: AuthenticationServiceError) {
        view.showLoginError(error)
    }

    func login(_ email: String!, password: String!) {
        interactor.login(email, password: password)
    }

    func showRegistration() {
        wireframe.navigateRegistrationInterface()
    }

    func showErrorAlert(_ error: AuthenticationServiceError) {
        wireframe.navigateLoginErrorAlert(error)
    }
}
