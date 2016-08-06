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
    
    func get(offset: UInt, limit: UInt, callback: PostServiceCallback!) {
        let (uid, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let userId = uid as String!
            let ref = FIRDatabase.database().reference()
            let path = "user-posts/\(userId)"
            ref.child(path).queryLimitedToFirst(limit).observeSingleEventOfType(.Value, withBlock: { (data) in
                let posts = [Post]()
                if let value = data.value as? [String: AnyObject] {
                    print("posts:", value)
                }
                callback(posts, nil)
            })
        }
    }
    
    func post(post: Post!, callback: PostServiceCallback!) {
        let (uid, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let userId = uid as String!
            let ref = FIRDatabase.database().reference()
            let key = ref.child("posts").childByAutoId().key
            let newPost: [String: AnyObject] = [
                "id": key,
                "uid": userId,
                "image": post.image,
                "timestamp": FIRServerValue.timestamp()
            ]
            let path1 = "posts/\(key)"
            let path2 = "user-posts/\(userId)/\(key)"
            let updates = [path1: newPost, path2: newPost]
            
            ref.updateChildValues(updates)
            ref.child("posts/\(key)").observeSingleEventOfType(.Value, withBlock: { (data) in
                if let value = data.value {
                    var new = Post()
                    new.image = value["image"] as! String
                    new.timestamp = value["timestamp"] as! Double
                    new.id = value["id"] as! String
                    new.user = User()
                    new.user.id = value["uid"] as! String
                    callback([new], nil)
                } else {
                    callback(nil, nil)
                }
            })
        }
    }
}
