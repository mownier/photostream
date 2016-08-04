//
//  LoginInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class LoginInteractor: LoginInteractorInput {

    var service: LoginService!
    var output: LoginInteractorOutput!

    init(service: LoginService!) {
        self.service = service
    }

    func login(email: String!, password: String!) {
        service.login(email, password: password) { (user, error) in
            if let error = error {
                self.output.loginDidFail(error)
            } else {
                self.output.loginDidSucceed(user)
            }
        }
    }
}
