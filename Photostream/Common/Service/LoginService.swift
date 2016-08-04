//
//  LoginService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginServiceResultCallback = (User?, NSError?) -> Void

class LoginService: AnyObject {

    var api: LoginAPI!

    init(api: LoginAPI!) {
        self.api = api
    }

    func login(email: String!, password: String!, callback: LoginServiceResultCallback!) {
        api.login(email, password: password, callback: callback)
    }
}

protocol LoginAPI: class {

    func login(email: String!, password: String!, callback: LoginServiceResultCallback!)
}
