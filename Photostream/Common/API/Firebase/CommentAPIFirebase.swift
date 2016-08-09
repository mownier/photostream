//
//  CommentAPIFirebase.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class CommentAPIFirebase: CommentServiceSource {

    func isOK() -> (String?, NSError?) {
        var uid: String?
        var error: NSError?
        if let auth = FIRAuth.auth() {
            if let user = auth.currentUser {
                uid = user.uid
            } else {
                error = NSError(domain: "CommentAPIFirebase", code: 1, userInfo: ["message": "User not found."])
            }
        } else {
            error = NSError(domain: "CommentAPIFirebase", code: 0, userInfo: ["message": "Unauthorized."])
        }
        return (uid, error)
    }
    
    func get(postId: String!, offset: UInt!, limit: UInt!, callback: CommentServiceCallback!) {
        let (_, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let root = FIRDatabase.database().reference()
            let comments = root.child("comments")
            let posts = root.child("posts")
            let users = root.child("users")
            let ref = posts.child(postId).child("comments")
            ref.queryLimitedToFirst(limit).observeSingleEventOfType(.Value, withBlock: { (data) in
                var list = [Comment]()
                for snap in data.children {
                    comments.child(snap.key).observeSingleEventOfType(.Value, withBlock: { (data2) in
                        let userId = data2.childSnapshotForPath("uid").value as! String
                        users.child(userId).observeSingleEventOfType(.Value, withBlock: { (data3) in
                            var user = User()
                            user.id = userId
                            user.firstName = data3.childSnapshotForPath("firstname").value as! String
                            user.lastName = data3.childSnapshotForPath("lastname").value as! String
                            
                            var comment = Comment()
                            comment.user = user
                            comment.id = data2.childSnapshotForPath("id").value as! String
                            comment.message = data2.childSnapshotForPath("message").value as! String
                            comment.timestamp = data2.childSnapshotForPath("timestamp").value as! Double
                            
                            list.append(comment)
                            
                            if UInt(list.count) == data.childrenCount {
                                callback(list, nil)
                            }
                        })
                    })
                }
            })
        }
    }
    
    func post(postId: String!, message: String!, user: User!, callback: CommentServiceCallback!) {
        let (_, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let ref = FIRDatabase.database().reference()
            let key = ref.child("comments").childByAutoId().key
            let path1 = "comments/\(key)"
            let path2 = "posts/\(postId)/\(path1)"
            let path3 = "users/\(user.id)/\(path1)"
            let data = [
                "id": key,
                "uid": user.id,
                "pid": postId,
                "message": message,
                "timestamp": FIRServerValue.timestamp()
            ]
            let updates: [String: AnyObject] = [path1: data, path2: true, path3: true]
            ref.updateChildValues(updates)
            ref.child(path1).observeSingleEventOfType(.Value, withBlock: { (data) in
                var new = Comment()
                new.id = key
                new.message = message
                new.user = user
                new.timestamp = data.childSnapshotForPath("timestamp").value as! Double
                callback([new], nil)
            })
        }
    }
}
