//
//  RegistrationAPIFirebase.swift
//  Photostream
//
//  Created by Mounir Ybanez on 05/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RegistrationAPIFirebase: RegistrationServiceSource {

    func register(email: String!, password: String!, firstname: String!, lastname: String!, callback: RegistrationServiceCallback!) {
        if let auth = FIRAuth.auth() {
            auth.createUserWithEmail(email, password: password, completion: { (user, error) in
                if let error = error {
                    callback(nil, error)
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
