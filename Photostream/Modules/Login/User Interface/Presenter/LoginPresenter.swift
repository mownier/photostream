//
//  LoginPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class LoginPresenter: LoginPresenterInterface {

    weak var view: LoginViewInterface!
    var interactor: LoginInteractorInput!
    var wireframe: LoginWireframe!
    
    func login(email: String, password: String) {
        interactor.login(email, password: password)
    }

    func presentRegistration() {
        wireframe.navigateToRegistration()
    }

    func presentErrorAlert(message: String) {
        wireframe.showErrorAlert(title: "Login Error", message: message)
    }
}

extension LoginPresenter: LoginInteractorOutput {
    
    func loginDidFail(_ error: AuthenticationServiceError) {
        view.didReceiveError(message: error.message)
    }
    
    func loginDidSucceed(_ user: User!) {
        wireframe.navigateToHome()
    }
}
