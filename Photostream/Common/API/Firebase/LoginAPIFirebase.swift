//
//  LoginAPIFirebase.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginAPIFirebase: LoginAPI {

    func login(email: String!, password: String!, callback: LoginServiceResultCallback!) {
        if let auth = FIRAuth.auth() {
            auth.signInWithEmail(email, password: password) { (user, error) in
                if let error = error {
                    callback(nil, error)
                } else {
                    let userModel = User()
                    callback(userModel, error)
                }
            }
        } else {
            callback(nil, NSError(domain: "LoginAPIFirebase", code: 0, userInfo: ["message": "Firebase auth is nil."]))
        }
    }
}
