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
    var wireframe: LoginWireframeInterface!
}

extension LoginPresenter: LoginModuleInterface {
    
    func login(email: String, password: String) {
        interactor.login(email: email, password: password)
    }
    
    func presentErrorAlert(message: String) {
        wireframe.showErrorAlert(title: "Login Error", message: message, from: view.controller)
    }
}

extension LoginPresenter: LoginInteractorOutput {
    
    func loginDidFail(error: AuthenticationServiceError) {
        view.didReceiveError(message: error.message)
    }
    
    func loginDidSucceed(user: User) {
        view.didLoginOk()
    }
}
