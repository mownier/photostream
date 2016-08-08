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

    func isOK() -> (String?, NSError?) {
        var uid: String?
        var error: NSError?
        if let auth = FIRAuth.auth() {
            if let user = auth.currentUser {
                uid = user.uid
            } else {
                error = NSError(domain: "PostAPIFirebase", code: 1, userInfo: ["message": "User not found."])
            }
        } else {
            error = NSError(domain: "PostAPIFirebase", code: 0, userInfo: ["message": "Unauthorized."])
        }
        return (uid, error)
    }
    
    func get(userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        let (_, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let ref = FIRDatabase.database().reference()
            let path = "user-posts/\(userId)"
            ref.child(path).queryLimitedToFirst(limit).observeSingleEventOfType(.Value, withBlock: { (data) in
                let posts = [Post]()
                if let value = data.value as? [String: AnyObject] {
                    print("posts:", value)
                    // TODO: Parse posts
                }
                callback(posts, nil)
            })
        }
    }
    
    func post(imageUrl: String!, user: User!, callback: PostServiceCallback!) {
        let (_, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let ref = FIRDatabase.database().reference()
            let key = ref.child("posts").childByAutoId().key
            let data: [String: AnyObject] = [
                "id": key,
                "uid": user.id,
                "imageUrl": imageUrl,
                "timestamp": FIRServerValue.timestamp()
            ]
            let path1 = "posts/\(key)"
            let path2 = "user-posts/\(user.id)/\(key)"
            let updates = [path1: data, path2: data]
            
            ref.updateChildValues(updates)
            ref.child(path1).observeSingleEventOfType(.Value, withBlock: { (data) in
                var new = Post()
                if let value = data.value {
                    new.image = imageUrl
                    new.id = key
                    new.user = user
                    new.timestamp = value["timestamp"] as! Double
                    callback([new], nil)
                }
                callback([new], nil)
            })
        }
    }
}
