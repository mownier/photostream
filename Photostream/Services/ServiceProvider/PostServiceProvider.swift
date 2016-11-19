//
//  PostServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct PostServiceProvider: PostService {

    var session: AuthSession

    init(session: AuthSession) {
        self.session = session
    }

    func fetchPosts(userId: String, offset: UInt, limit: UInt, callback: ((PostServiceResult) -> Void)?) {
        var result = PostServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let root = FIRDatabase.database().reference()
        let users = root.child("users")
        let posts = root.child("posts")
        let photos = root.child("photos")
        let ref = users.child(userId).child("posts")
        let uid = session.user.id
        
        ref.queryLimited(toFirst: limit).observeSingleEvent(of: .value, with: { (data) in
            var postList = [Post]()
            var postUsers = [String: User]()
            for snap in data.children {
                posts.child((snap as AnyObject).key).observeSingleEvent(of: .value, with: { (data2) in
                    
                    let posterId = data2.childSnapshot(forPath: "uid").value as! String
                    let photoId = data2.childSnapshot(forPath: "photo_id").value as! String
                    
                    users.child(posterId).observeSingleEvent(of: .value, with: { (data3) in
                        
                        photos.child(photoId).observeSingleEvent(of: .value, with: { (data4) in
                            
                            if postUsers[posterId] == nil {
                                var user = User()
                                user.id = posterId
                                user.firstName = data3.childSnapshot(forPath: "firstname").value as! String
                                user.lastName = data3.childSnapshot(forPath: "lastname").value as! String
                                postUsers[posterId] = user
                            }
                            
                            var photo = Photo()
                            photo.url = data4.childSnapshot(forPath: "url").value as! String
                            photo.height = data4.childSnapshot(forPath: "height").value as! Int
                            photo.width = data4.childSnapshot(forPath: "width").value as! Int
                            
                            var post = Post()
                            post.userId = posterId
                            post.id = data2.childSnapshot(forPath: "id").value as! String
                            post.timestamp = data2.childSnapshot(forPath: "timestamp").value as! Double
                            post.photo = photo
                            
                            if data2.hasChild("likes_count") {
                                post.likesCount = data2.childSnapshot(forPath: "likes_count").value as! Int
                            }
                            
                            if data2.hasChild("likes/\(uid)") {
                                post.isLiked = true
                            }
                            
                            if data2.hasChild("comments_count") {
                                post.commentsCount = data2.childSnapshot(forPath: "comments_count").value as! Int
                            }
                            
                            if data2.hasChild("message") {
                                post.message = data2.childSnapshot(forPath: "message").value as! String
                            }
                            
                            postList.append(post)
                            
                            
                            if UInt(postList.count) == data.childrenCount {
                                var result = PostServiceResult()
                                var resultList = PostList()
                                resultList.posts = postList
                                resultList.users = postUsers
                                result.posts = resultList
                                callback?(result)
                            }
                        })
                    })
                })
            }
        })
    }

    func writePost(imageUrl: String, content: String, callback: ((PostServiceResult) -> Void)?) {
        var result = PostServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let userId = session.user.id
        let ref = FIRDatabase.database().reference()
        let key = ref.child("posts").childByAutoId().key
        let data: [String: AnyObject] = [
            "id": key as AnyObject,
            "uid": userId as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "timestamp": FIRServerValue.timestamp() as AnyObject,
            "message": content as AnyObject
        ]
        let path1 = "posts/\(key)"
        let path2 = "users/\(userId)/\(path1)"
        let path3 = "users/\(userId)/feed/\(key)"
        let path4 = "users/\(userId)/profile/posts_count"
        let updates: [String: AnyObject] = [path1: data as AnyObject, path2: true as AnyObject, path3: true as AnyObject]

        ref.child(path4).runTransactionBlock({ (data) -> FIRTransactionResult in
            if let val = data.value as? Int {
                data.value = val + 1
            } else {
                data.value = 0
            }
            return FIRTransactionResult.success(withValue: data)

            }, andCompletionBlock: { (error, committed, snap) in
                guard committed else {
                    result.error = .failedToWrite(message: "Failed to write post.")
                    callback?(result)
                    return
                }
                
                ref.updateChildValues(updates)
                ref.child(path1).observeSingleEvent(of: .value, with: { (data) in
                    ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (data2) in
                        var user = User()
                        user.id = userId
                        user.firstName = data2.childSnapshot(forPath: "firstname").value as! String
                        user.lastName = data2.childSnapshot(forPath: "lastname").value as! String

                        var post = Post()
                        post.id = key
                        post.userId = userId
                        post.timestamp = data.childSnapshot(forPath: "timestamp").value as! Double

                        var posts = [Post]()
                        posts.append(post)

                        var users = [String: User]()
                        users[userId] = user

                        var resultList = PostList()
                        resultList.posts = posts
                        resultList.users = users
                        
                        result.posts = resultList
                        callback?(result)
                    })
                })
        })
    }

    func like(id: String, callback: ((PostServiceError?) -> Void)?) {
        var error: PostServiceError?
        guard session.isValid else {
            error = .authenticationNotFound(message: "Authentication not found.")
            callback?(error)
            return
        }
        
        let userId = session.user.id
        let path1 = "posts/\(id)/likes_count"
        let path2 = "posts/\(id)/likes/\(userId)"
        let rootRef = FIRDatabase.database().reference()
        
        rootRef.child(path2).observeSingleEvent(of: .value, with: { (data) in
            guard !data.exists() else {
                error = .failedToLike(message: "Already liked.")
                callback?(error)
                return
            }
           
            rootRef.child(path1).runTransactionBlock({ (data2) -> FIRTransactionResult in
                if let val = data2.value as? Int {
                    data2.value = val + 1
                } else {
                    data2.value = 1
                }
                return FIRTransactionResult.success(withValue: data2)
                
                }, andCompletionBlock: { (err, committed, snap) in
                    guard committed else {
                        error = .failedToLike(message: "Failed to like post.")
                        callback?(error)
                        return
                    }
                    
                    rootRef.child(path2).setValue(true)
                    callback?(nil)
            })
        })
    }


    func unlike(id: String, callback: ((PostServiceError?) -> Void)?) {
        var error: PostServiceError?
        guard session.isValid else {
            error = .authenticationNotFound(message: "Authentication not found.")
            callback?(error)
            return
        }
        
        let userId = session.user.id
        let path1 = "posts/\(id)/likes_count"
        let path2 = "posts/\(id)/likes/\(userId)"
        let rootRef = FIRDatabase.database().reference()
        
        rootRef.child(path2).observeSingleEvent(of: .value, with: { (data) in
            guard data.exists() else {
                error = .failedToUnlike(message: "Post does not exist.")
                callback?(error)
                return
            }
            
            rootRef.child(path1).runTransactionBlock({ (data) -> FIRTransactionResult in
                if let val = data.value as? Int , val > 0 {
                    data.value = val - 1
                } else {
                    data.value = 0
                }
                return FIRTransactionResult.success(withValue: data)
                
                }, andCompletionBlock: { (err, committed, snap) in
                    guard committed else {
                        error = .failedToUnlike(message: "Failed to unlike post.")
                        callback?(error)
                        return
                    }
                    
                    rootRef.child(path2).removeValue()
                    callback?(nil)
            })
        })
    }

    func fetchLikes(id: String, offset: UInt, limit: UInt, callback: ((PostServiceLikeResult) -> Void)?) {
        var result = PostServiceLikeResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let path1 = "posts/\(id)/likes"
        let path2 = "users"
        let rootRef = FIRDatabase.database().reference()
        
        rootRef.child(path1).queryLimited(toFirst: limit).observeSingleEvent(of: .value, with: { (data) in
            var likeList = [User]()
            guard data.exists() else {
                result.likes = likeList
                callback?(result)
                return
            }
            
            for c in data.children {
                let child = c as! FIRDataSnapshot
                rootRef.child("\(path2)/\(child.key)").observeSingleEvent(of: .value, with: { (data2) in
                    
                    var user = User()
                    user.id = data2.childSnapshot(forPath: "id").value as! String
                    user.firstName = data2.childSnapshot(forPath: "firstname").value as! String
                    user.lastName = data2.childSnapshot(forPath: "lastname").value as! String
                    
                    likeList.append(user)
                    
                    if UInt(likeList.count) == data.childrenCount {
                        result.likes = likeList
                        callback?(result)
                    }
                })
            }
        })
    }
    
    func fetchPostInfo(id: String, callback: ((PostServiceResult) -> Void)?) {
        // TODO: Implement fetching single post info
    }
}
