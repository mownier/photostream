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

    var session: AuthSession!
    
    required init(session: AuthSession!) {
        self.session = session
    }

    func fetchNewsFeed(offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let userId = session.user.id
            fetch("feed", userId: userId, offset: offset, limit: limit, callback: callback)
        }
    }

    func fetchPosts(userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            fetch("posts", userId: userId, offset: offset, limit: limit, callback: callback)
        }
    }

    func writePost(imageUrl: String!, callback: PostServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let userId = session.user.id
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
            let path4 = "users/\(userId)/profile/posts_count"
            let updates: [String: AnyObject] = [path1: data, path2: true, path3: true]
            
            ref.child(path4).runTransactionBlock({ (data) -> FIRTransactionResult in
                
                if let val = data.value as? Int {
                    data.value = val + 1
                } else {
                    data.value = 0
                }
                
                return FIRTransactionResult.successWithValue(data)
                
                }, andCompletionBlock: { (error, result, snap) in
                    
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
            })
        }
    }
    
    func like(postId: String!, callback: PostServiceLikeCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let userId = session.user.id
            let path1 = "posts/\(postId)/likes_count"
            let path2 = "posts/\(postId)/likes/\(userId)"
            let rootRef = FIRDatabase.database().reference()
            
            rootRef.child(path2).observeSingleEventOfType(.Value, withBlock: { (data) in
                
                if data.exists() {
                    callback(false, NSError(domain: "PostAPIFirebase", code: 0, userInfo: ["message": "Already liked."]))
                } else {
                    rootRef.child(path1).runTransactionBlock({ (data2) -> FIRTransactionResult in
                        
                        if let val = data2.value as? Int {
                            data2.value = val + 1
                        } else {
                            data2.value = 1
                        }
                        
                        return FIRTransactionResult.successWithValue(data2)
                        
                        }, andCompletionBlock: { (error, committed, snap) in
                            
                            if !committed {
                                callback(false, error)
                            } else {
                                rootRef.child(path2).setValue(true)
                                callback(true, nil)
                            }
                    })
                }
            })
        }
    }
    
    func unlike(postId: String!, callback: PostServiceLikeCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let userId = session.user.id
            let path1 = "posts/\(postId)/likes_count"
            let path2 = "posts/\(postId)/likes/\(userId)"
            let rootRef = FIRDatabase.database().reference()
            
            rootRef.child(path2).observeSingleEventOfType(.Value, withBlock: { (data) in
                
                if !data.exists() {
                    callback(false, NSError(domain: "PostAPIFirebase", code: 0, userInfo: ["message": "Failed to unlike post."]))
                } else {
                    rootRef.child(path1).runTransactionBlock({ (data) -> FIRTransactionResult in
                        
                        if let val = data.value as? Int where val > 0 {
                            data.value = val - 1
                        } else {
                            data.value = 0
                        }
                        
                        return FIRTransactionResult.successWithValue(data)
                        
                        }, andCompletionBlock: { (error, committed, snap) in
                            
                            if !committed {
                                callback(false, error)
                            } else {
                                rootRef.child(path2).removeValue()
                                callback(true, nil)
                            }
                    })
                }
            })
        }
    }
    
    private func isOK() -> NSError? {
        if session.isValid() {
            return nil
        } else {
            return NSError(domain: "PostAPIFirebase", code: 0, userInfo: ["message": "Unauthorized."])
        }
    }
    
    private func fetch(path: String, userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
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
