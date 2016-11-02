//
//  LoginInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginInteractorOutput: class {

    func loginDidSucceed(user: User)
    func loginDidFail(error: AuthenticationServiceError)
}
