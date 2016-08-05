//
//  LoginAPIFirebase.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class LoginAPIFirebase: LoginServiceSource {

    func login(email: String!, password: String!, callback: LoginServiceResultCallback!) {
        if let auth = FIRAuth.auth() {
            auth.signInWithEmail(email, password: password) { (user, error) in
                if let error = error {
                    callback(nil, error)
                } else {
                    guard let user = user else {
                        callback(nil, NSError(domain: "LoginAPIFirebase", code: 1, userInfo: ["message": "FIRUser is nil."]))
                        return
                    }
                    
                    let id = user.uid
                    let ref = FIRDatabase.database().reference()
                    let path = "users/\(id)"
                    ref.child(path).observeSingleEventOfType(.Value, withBlock: { (data) in
                        guard let value = data.value else {
                            callback(nil, NSError(domain: "LoginAPIFirebase", code: 2, userInfo: ["message": "FIRDataSnapshot is nil."]))
                            return
                        }
                        var u = User()
                        u.email = value["email"] as! String
                        u.id = value["id"] as! String
                        u.firstName = value["firstname"] as! String
                        u.lastName = value["lastname"] as! String
                        callback(u, nil)
                    })
                }
            }
        } else {
            callback(nil, NSError(domain: "LoginAPIFirebase", code: 0, userInfo: ["message": "Firebase auth is nil."]))
        }
    }
}
