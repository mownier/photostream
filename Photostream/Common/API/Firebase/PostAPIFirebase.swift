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

class PostAPIFirebase: PostService {

    private func isOK() -> (String?, NSError?) {
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
    
    private func fetch(path: String, userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        let (_, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let root = FIRDatabase.database().reference()
            let users = root.child("users")
            let posts = root.child("posts")
            let ref = users.child(userId).child(path)
            ref.queryLimitedToFirst(limit).observeSingleEventOfType(.Value, withBlock: { (data) in
                var postList = [Post]()
                var postUsers = [String: User]()
                for snap in data.children {
                    posts.child(snap.key).observeSingleEventOfType(.Value, withBlock: { (data2) in
                        users.child(userId).observeSingleEventOfType(.Value, withBlock: { (data3) in
                            if postUsers[userId] == nil {
                                var user = User()
                                user.id = data3.childSnapshotForPath("id").value as! String
                                user.firstName = data3.childSnapshotForPath("firstname").value as! String
                                user.lastName = data3.childSnapshotForPath("lastname").value as! String
                                postUsers[userId] = user
                            }
                            
                            var post = Post()
                            post.userId = userId
                            post.id = data2.childSnapshotForPath("id").value as! String
                            post.image = data2.childSnapshotForPath("imageUrl").value as! String
                            post.timestamp = data2.childSnapshotForPath("timestamp").value as! Double
                            postList.append(post)
                            
                            if UInt(postList.count) == data.childrenCount {
                                var result = PostServiceResult()
                                result.posts = postList
                                result.users = postUsers
                                callback(result, nil)
                            }
                        })
                    })
                }
            })
        }
    }
    
    func fetchNewsFeed(userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        fetch("feed", userId: userId, offset: offset, limit: limit, callback: callback)
    }
    
    
    func fetchPosts(userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        fetch("posts", userId: userId, offset: offset, limit: limit, callback: callback)
    }
    
    func writePost(userId: String!, imageUrl: String!, callback: PostServiceCallback!) {
        let (_, error) = isOK()
        if let error = error {
            callback(nil, error)
        } else {
            let ref = FIRDatabase.database().reference()
            let key = ref.child("posts").childByAutoId().key
            let data: [String: AnyObject] = [
                "id": key,
                "uid": userId,
                "imageUrl": imageUrl,
                "timestamp": FIRServerValue.timestamp()
            ]
            let path1 = "posts/\(key)"
            let path2 = "users/\(userId)/\(path1)"
            let path3 = "users/\(userId)/feed/\(key)"
            let updates: [String: AnyObject] = [path1: data, path2: true, path3: true]
            
            ref.updateChildValues(updates)
            ref.child(path1).observeSingleEventOfType(.Value, withBlock: { (data) in
                ref.child("users/\(userId)").observeSingleEventOfType(.Value, withBlock: { (data2) in
                    var user = User()
                    user.id = userId
                    user.firstName = data2.childSnapshotForPath("firstname").value as! String
                    user.lastName = data2.childSnapshotForPath("lastname").value as! String
                    
                    var post = Post()
                    post.image = imageUrl
                    post.id = key
                    post.userId = userId
                    post.timestamp = data.childSnapshotForPath("timestamp").value as! Double

                    var posts = [Post]()
                    posts.append(post)
                    
                    var users = [String: User]()
                    users[userId] = user
                    
                    var result = PostServiceResult()
                    result.posts = posts
                    result.users = users
                    
                    callback(result, nil)

                })
            })
        }
    }
}
