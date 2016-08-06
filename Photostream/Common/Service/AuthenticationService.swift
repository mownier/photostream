//
//  AuthenticationService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias AuthenticationServiceResultCallback = (User?, NSError?) -> Void

class AuthenticationService: AnyObject {

    var source: AuthenticationServiceSource!

    init(source: AuthenticationServiceSource!) {
        self.source = source
    }

    func login(email: String!, password: String!, callback: AuthenticationServiceResultCallback!) {
        source.login(email, password: password) { (user, error) in
            callback(user, error)
        }
    }
    
    func register(email: String!, password: String!, firstname: String!, lastname: String!, callback: AuthenticationServiceResultCallback) {
        source.register(email, password: password, firstname: firstname, lastname: lastname) { (user, error) in
            callback(user, error)
        }
    }
}

protocol AuthenticationServiceSource: class {

    func login(email: String!, password: String!, callback: AuthenticationServiceResultCallback!)
    func register(email: String!, password: String!, firstname: String!, lastname: String!, callback: AuthenticationServiceResultCallback!)
}
