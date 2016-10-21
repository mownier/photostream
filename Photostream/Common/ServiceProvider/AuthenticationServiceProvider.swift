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

    func login(data: AuthentationServiceLoginData, callback: ((AuthenticationServiceResult) -> Void)?) {
        var result = AuthenticationServiceResult()
        if let auth = FIRAuth.auth() {
            auth.signIn(withEmail: data.email, password: data.password) { (user, error) in
                if let _ = error {
                    result.error = .invalidLoginCredentials(message: "Invalid login credentials")
                    callback?(result)
                } else {
                    guard let authUser = user else {
                        result.error = .authenticatedUserNotFound(message: "Authenticated user not found")
                        callback?(result)
                        return
                    }

                    let id = authUser.uid
                    let ref = FIRDatabase.database().reference()
                    let path = "users/\(id)"
                    ref.child(path).observeSingleEvent(of: .value, with: { (data) in                        
                        var u = User()
                        u.email = data.childSnapshot(forPath: "email").value as! String
                        u.id = data.childSnapshot(forPath: "id").value as! String
                        u.firstName = data.childSnapshot(forPath: "firstname").value as! String
                        u.lastName = data.childSnapshot(forPath: "lastname").value as! String
                        if data.hasChild("username") {
                            u.username = data.childSnapshot(forPath: "username").value as! String
                        }
                        
                        result.user = u
                        callback?(result)
                    })
                }
            }
        } else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
        }
    }

    func register(data: AuthenticationServiceRegisterData, callback: ((AuthenticationServiceResult) -> Void)?) {
        var result = AuthenticationServiceResult()
        if let auth = FIRAuth.auth() {
            auth.createUser(withEmail: data.email, password: data.password, completion: { (user, error) in
                if let _ = error {
                    result.error = .invalidRegisterCredentials(message: "Invalid registration credentials. It might be that username or email already exists already.")
                    callback?(result)
                } else {
                    guard let authUser = user else {
                        result.error = .authenticatedUserNotFound(message: "Authenticated user not found.")
                        callback?(result)
                        return
                    }
                    
                    let id = authUser.uid
                    let userInfo = ["firstname": data.firstName, "lastname": data.lastName, "id": id, "email": data.email]
                    let ref = FIRDatabase.database().reference()
                    let path = "users/\(id)"
                    ref.child(path).setValue(userInfo)

                    var u = User()
                    u.id = id
                    u.email = data.email
                    u.firstName = data.firstName
                    u.lastName = data.lastName
                    
                    result.user = u
                    callback?(result)
                }
            })
        } else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)

        }
    }
}
