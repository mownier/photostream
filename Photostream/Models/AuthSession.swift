//
//  AuthSession.swift
//  Photostream
//
//  Created by Mounir Ybanez on 12/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth

struct AuthSession {

    var user: User!

    init() {
        self.user = User()
        if let u = FIRAuth.auth()?.currentUser {
            user.id = u.uid
        }
    }

    func isValid() -> Bool {
        if let u = user,
            let _ = u.id {
            return true
        } else {
            return false
        }
    }
}
