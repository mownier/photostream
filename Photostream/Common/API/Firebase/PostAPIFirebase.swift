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
            let root = FIRDatabase.database().reference()
            let users = root.child("users")
            let posts = root.child("posts")
            let ref = users.child(userId).child("posts")
            ref.queryLimitedToFirst(limit).observeSingleEventOfType(.Value, withBlock: { (data) in
                var list = [Post]()
                for snap in data.children {
                    posts.child(snap.key).observeSingleEventOfType(.Value, withBlock: { (data2) in
                        users.child(userId).observeSingleEventOfType(.Value, withBlock: { (data3) in
                            var user = User()
                            user.id = data3.childSnapshotForPath("id").value as! String
                            user.firstName = data3.childSnapshotForPath("firstname").value as! String
                            user.lastName = data3.childSnapshotForPath("lastname").value as! String
                            
                            var post = Post()
                            post.user = user
                            post.id = data2.childSnapshotForPath("id").value as! String
                            post.image = data2.childSnapshotForPath("imageUrl").value as! String
                            post.timestamp = data2.childSnapshotForPath("timestamp").value as! Double
                            
                            list.append(post)
                            
                            if UInt(list.count) == data.childrenCount {
                                callback(list, nil)
                            }
                        })
                    })
                }
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
            let path2 = "users/\(user.id)/\(path1)"
            let updates: [String: AnyObject] = [path1: data, path2: true]
            
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
