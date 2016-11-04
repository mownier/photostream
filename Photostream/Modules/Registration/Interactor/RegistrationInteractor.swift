//
//  RegistrationInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 05/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class RegistrationInteractor: RegistrationInteractorInterface {

    weak var output: RegistrationInteractorOutput?
    var service: AuthenticationService!

    required init(service: AuthenticationService) {
        self.service = service
    }
}

extension RegistrationInteractor: RegistrationInteractorInput {
    
    func register(email: String, password: String, firstName: String, lastName: String) {
        var data = AuthenticationServiceRegisterData()
        data.email = email
        data.password = password
        data.firstName = firstName
        data.lastName = lastName
        service.register(data: data) { (result) in
            if let error = result.error {
                self.output?.registrationDidFail(error: error)
            } else {
                self.output?.registrationDidSucceed(user: result.user!)
            }
        }
    }
}
