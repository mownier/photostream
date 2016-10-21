//
//  AuthenticationServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthenticationServiceProvider: AuthenticationService {

    func login(_ email: String!, password: String!, callback: AuthenticationServiceCallback!) {
        if let auth = FIRAuth.auth() {
            auth.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    callback(nil, error as NSError)
                } else {
                    guard let user = user else {
                        callback(nil, NSError(domain: "LoginAPIFirebase", code: 1, userInfo: ["message": "FIRUser is nil."]))
                        return
                    }

                    let id = user.uid
                    let ref = FIRDatabase.database().reference()
                    let path = "users/\(id)"
                    ref.child(path).observeSingleEvent(of: .value, with: { (data) in
                        guard let value = data.value as? [String: AnyObject] else {
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

    func register(_ email: String!, password: String!, firstname: String!, lastname: String!, callback: AuthenticationServiceCallback!) {
        if let auth = FIRAuth.auth() {
            auth.createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    callback(nil, error as NSError)
                } else {
                    guard let user = user else {
                        callback(nil, NSError(domain: "RegistrationAPIFirebase", code: 1, userInfo: ["message": "FIRUser is nil."]))
                        return
                    }
                    let ref = FIRDatabase.database().reference()
                    let id = user.uid
                    let userInfo = ["firstname": firstname, "lastname": lastname, "id": id, "email": email]
                    ref.child("users/\(id)").setValue(userInfo)

                    var u = User()
                    u.email = email
                    u.firstName = firstname
                    u.lastName = lastname
                    u.id = id

                    callback(u, nil)
                }
            })
        } else {
            callback(nil, NSError(domain: "RegistrationAPIFirebase", code: 0, userInfo: ["message": "Firebase auth is nil."]))
        }
    }
}
