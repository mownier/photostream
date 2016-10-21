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

    func register(_ email: String!, password: String!, firstname: String!, lastname: String!) {
        var data = AuthenticationServiceRegisterData()
        data.email = email
        data.password = password
        data.firstName = firstname
        data.lastName = lastname
        service.register(data: data) { (result) in
            if let error = result.error {
                self.output.registrationDidFail(error)
            } else {
                self.output.registrationDidSucceed(result.user)
            }
        }
    }
}
