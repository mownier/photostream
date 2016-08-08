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
            let ref = FIRDatabase.database().reference()
            let path = "post-comments/\(postId)"
            ref.child(path).queryLimitedToFirst(10).observeSingleEventOfType(.Value, withBlock: { (data) in
                // TODO: Parse data for comments
                var temp = [Comment]()
                if let value = data.value as? [String: AnyObject]{
                    for (_, info) in value {
                        var new = Comment()
                        new.id = info["id"] as! String
                        new.message = info["message"] as! String
                        new.timestamp = info["timestamp"] as! Double
                        
                        let uid = info["uid"] as! String
                        var user = User()
                        user.id = uid
                        new.user = user
                        temp.append(new)
                    }
                    
                }
                
                let count = temp.count
                var comments = [Comment]()
                var i = 0
                for comment in temp {
                    let path = "users/\(comment.user.id)"
                    ref.child(path).observeSingleEventOfType(.Value, withBlock: { (data) in
                        var user = User()
                        user.id = comment.user.id
                        if let value = data.value {
                            user.email = value["email"] as! String
                            user.lastName = value["lastname"] as! String
                            user.firstName = value["firstname"] as! String
                        }
                        
                        var new = Comment()
                        new.user = user
                        new.id = comment.id
                        new.timestamp = comment.timestamp
                        new.message = comment.message
                        
                        comments.append(new)
                        
                        // TODO: Fix weird count and temp :D
                        i += 1
                        
                        if i == count {
                            callback(comments, nil)
                        }
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
            let path2 = "post-comments/\(postId)/\(key)"
            let path3 = "user-comments/\(user.id)/\(key)"
            let data = [
                "id": key,
                "uid": user.id,
                "pid": postId,
                "message": message,
                "timestamp": FIRServerValue.timestamp()
            ]
            let updates = [path1: data, path2: data, path3: data]
            ref.updateChildValues(updates)
            ref.child(path1).observeSingleEventOfType(.Value, withBlock: { (data) in
                var new = Comment()
                if let value = data.value {
                    new.id = key
                    new.message = message
                    new.user = user
                    new.timestamp = value["timestamp"] as! Double
                }
                callback([new], nil)
            })
        }
    }
}
