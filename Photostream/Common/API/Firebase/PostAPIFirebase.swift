//
//  PostAPIFirebase.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class PostAPIFirebase: PostServiceSource {

    func get(offset: UInt, limit: UInt, callback: PostServiceCallback!) {
        if let auth = FIRAuth.auth() {
            guard let user = auth.currentUser else {
                callback(nil, NSError(domain: "PostAPIFirebase", code: 1, userInfo: ["message": "User not found."]))
                return
            }
            let ref = FIRDatabase.database().reference()
            let path = "posts/\(user.uid)"
            ref.child(path).queryOrderedByChild("timestamp").queryLimitedToFirst(limit).observeSingleEventOfType(.Value, withBlock: { (data) in
                let posts = [Post]()
                if let _ = data.value as? [AnyObject] {
                    // TODO: Parse posts here.
                }
                callback(posts, nil)
            })
            
        } else {
            callback(nil, NSError(domain: "PostAPIFirebase", code: 0, userInfo: ["message": "Unauthorized."]))
        }
    }
}
