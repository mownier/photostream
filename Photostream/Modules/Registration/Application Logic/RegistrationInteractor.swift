//
//  RegistrationInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 05/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class RegistrationInteractor: RegistrationInteractorInput {

    var output: RegistrationInteractorOutput!
    var service: AuthenticationService!

    init(service: AuthenticationService!) {
        self.service = service
    }

    func register(email: String!, password: String!, firstname: String!, lastname: String!) {
        service.register(email, password: password, firstname: firstname, lastname: lastname) { (user, error) in
            if let error = error {
                self.output.registrationDidFail(error)
            } else {
                self.output.registrationDidSucceed(user)
            }
        }
    }
}
