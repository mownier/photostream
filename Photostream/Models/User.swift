//
//  User.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct User {

    var id: String!
    var username: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var fullName: String! {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    var displayName: String! {
        get {
            if let uname = username {
                return uname
            } else {
                return firstName
            }
        }
    }
}
