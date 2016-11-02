//
//  RegistrationInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 05/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol RegistrationInteractorOutput: class {

    func registrationDidSucceed(user: User)
    func registrationDidFail(error: AuthenticationServiceError)
}
