//
//  LoginInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class LoginInteractor: LoginInteractorInterface {

    var service: AuthenticationService!
    weak var output: LoginInteractorOutput?

    required init(service: AuthenticationService) {
        self.service = service
    }

    fileprivate func saveUser(_ user: User!) {
        // TODO: Save user into the keychain or any encrpted storage
    }
}

extension LoginInteractor: LoginInteractorInput {
    
    func login(email: String, password: String) {
        var data = AuthentationServiceLoginData()
        data.email = email
        data.password = password
        service.login(data: data) { (result) in
            if let error = result.error {
                self.output?.loginDidFail(error: error)
            } else {
                self.saveUser(result.user)
                self.output?.loginDidSucceed(user: result.user!)
            }
        }
    }
}
