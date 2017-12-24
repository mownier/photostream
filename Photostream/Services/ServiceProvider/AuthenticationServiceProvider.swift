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

struct AuthenticationServiceProvider: AuthenticationService {

    func login(data: AuthentationServiceLoginData, callback: ((AuthenticationServiceResult) -> Void)?) {
        var result = AuthenticationServiceResult()
        let auth = Auth.auth()
        
        auth.signIn(withEmail: data.email, password: data.password) { (user, error) in
            guard error == nil else {
                result.error = .invalidLoginCredentials(message: "Invalid login credentials")
                callback?(result)
                return
            }
            
            guard let authUser = user else {
                result.error = .authenticatedUserNotFound(message: "Authenticated user not found")
                callback?(result)
                return
            }
            
            let id = authUser.uid
            let ref = Database.database().reference()
            let path = "users/\(id)"
            ref.child(path).observeSingleEvent(of: .value, with: { (data) in
                
                // Get user value
                var u = User()
                let value = data.value as? NSDictionary
                u.email = value?["email"] as? String ?? ""
                u.id = value?["id"] as? String ?? ""
                u.firstName = value?["firstname"] as? String ?? ""
                u.lastName = value?["lastname"] as? String ?? ""

                // UserName
                let userName = value?["username"] as? String ?? ""
                
                if userName.length>0 {
                    u.username = userName
                }
                
                result.user = u
                callback?(result)
            })
        }
    }

    func register(data: AuthenticationServiceRegisterData, callback: ((AuthenticationServiceResult) -> Void)?) {
        var result = AuthenticationServiceResult()
        let auth = Auth.auth()
        
        auth.createUser(withEmail: data.email, password: data.password, completion: { (user, error) in
            guard error == nil else {
                result.error = .invalidRegisterCredentials(message: "Invalid registration credentials. It might be that username or email already exists already.")
                callback?(result)
                return
            }
            
            guard let authUser = user else {
                result.error = .authenticatedUserNotFound(message: "Authenticated user not found.")
                callback?(result)
                return
            }
            
            let id = authUser.uid
            let userInfo = ["firstname": data.firstName, "lastname": data.lastName, "id": id, "email": data.email]
            let ref = Database.database().reference()
            let path = "users/\(id)"
            ref.child(path).setValue(userInfo)
            
            var u = User()
            u.id = id
            u.email = data.email
            u.firstName = data.firstName
            u.lastName = data.lastName
            
            result.user = u
            callback?(result)
        })
    }

    func logout(callback: ((AuthenticationServiceError?) -> Void)?) {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            callback?(nil)
        } catch {
            callback?(.unableToLogout(message: "Failed to log out"))
        }
    }
}
