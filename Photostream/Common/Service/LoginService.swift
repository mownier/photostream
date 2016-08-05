//
//  LoginService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias LoginServiceResultCallback = (User?, NSError?) -> Void

class LoginService: AnyObject {

    var source: LoginServiceSource!

    init(source: LoginServiceSource!) {
        self.source = source
    }

    func login(email: String!, password: String!, callback: LoginServiceResultCallback!) {
        source.login(email, password: password) { (user, error) in
            callback(user, error)
        }
    }
}

protocol LoginServiceSource: class {

    func login(email: String!, password: String!, callback: LoginServiceResultCallback!)
}
