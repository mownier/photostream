//
//  LoginModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginModuleInterface: class {

    func login(_ email: String!, password: String!)
    func showRegistration()
    func showErrorAlert(_ error: AuthenticationServiceError)
}
