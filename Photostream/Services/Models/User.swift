//
//  User.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import Firebase

struct User {

    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var avatarUrl: String

    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }

    var displayName: String {
        get {
            if !username.isEmpty {
                return username
            } else {
                return firstName
            }
        }
    }

    init() {
        id = ""
        username = ""
        firstName = ""
        lastName = ""
        email = ""
        avatarUrl = ""
    }
}

extension User: SnapshotParser {
    
    init(with snapshot: FIRDataSnapshot, exception: String...) {
        self.init()
        
        if snapshot.hasChild("id") && !exception.contains("id") {
            id = snapshot.childSnapshot(forPath: "id").value as! String
        }
        
        if snapshot.hasChild("firstname") && !exception.contains("firstname") {
            firstName = snapshot.childSnapshot(forPath: "firstname").value as! String
        }
        
        if snapshot.hasChild("lastname") && !exception.contains("lastname") {
            lastName = snapshot.childSnapshot(forPath: "lastname").value as! String
        }
        
        if snapshot.hasChild("email") && !exception.contains("email") {
            email = snapshot.childSnapshot(forPath: "email").value as! String
        }
        
        if snapshot.hasChild("username") && !exception.contains("username") {
            username = snapshot.childSnapshot(forPath: "username").value as! String
        }
        
        if snapshot.hasChild("avatar_url") && !exception.contains("avatar_url") {
            avatarUrl = snapshot.childSnapshot(forPath: "avatar_url").value as! String
        }
    }
}
