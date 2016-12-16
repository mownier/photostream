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

    func fetchPosts(userId: String, offset: String, limit: UInt, callback: ((PostServiceResult) -> Void)?) {
        var result = PostServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let rootRef = FIRDatabase.database().reference()
        let usersRef = rootRef.child("users")
        let postsRef = rootRef.child("posts")
        let photosRef = rootRef.child("photos")
        let userPostRef = rootRef.child("user-post/\(userId)/posts")
        var query = userPostRef.queryOrderedByKey()
        
        if !offset.isEmpty {
            query = query.queryEnding(atValue: offset)
        }
        
        query = query.queryLimited(toLast: limit + 1)
        query.observeSingleEvent(of: .value, with: { (data) in
            guard data.childrenCount > 0 else {
                result.posts = PostList()
                callback?(result)
                return
            }
            
            var posts = [Post]()
            var users = [String: User]()
            
            for child in data.children {
                guard let userPost = child as? FIRDataSnapshot else {
                    continue
                }
                
                let postId = userPost.key
                let postRef = postsRef.child(postId)
                
                postRef.observeSingleEvent(of: .value, with: { (postSnapshot) in
                    guard let posterId = postSnapshot.childSnapshot(forPath: "uid").value as? String,
                        let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                        return
                    }
                    
                    let userRef = usersRef.child(posterId)
                    let photoRef = photosRef.child(photoId)
                    let likesRef = rootRef.child("post-like/\(postId)/likes")
                    
                    userRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                        photoRef.observeSingleEvent(of: .value, with: { (photoSnapshot) in
                            likesRef.observeSingleEvent(of: .value, with: { (likesSnapshot) in
                                if users[posterId] == nil {
                                    let user = User(with: userSnapshot, exception: "email")
                                    users[posterId] = user
                                }
                                
                                let photo = Photo(with: photoSnapshot)
                                var post = Post(with: postSnapshot)
                                post.photo = photo
                                
                                if likesSnapshot.hasChild(uid) {
                                    post.isLiked = true
                                }
                                
                                posts.append(post)
                                
                                let postCount = UInt(posts.count)
                                if postCount == data.childrenCount {
                                    if postCount == limit + 1 {
                                        let removedPost = posts.removeFirst()
                                        result.nextOffset = removedPost.id
                                    }
                                    
                                    var list = PostList()
                                    list.posts = posts.reversed()
                                    list.users = users
                                    result.posts = list
                                    callback?(result)
                                }
                            })
                        })
                    })
                })
            }
        })
    }

    func writePost(photoId: String, content: String, callback: ((PostServiceResult) -> Void)?) {
        var result = PostServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let rootRef = FIRDatabase.database().reference()
        let key = rootRef.child("posts").childByAutoId().key
        let data: [String: Any] = [
            "id": key,
            "uid": uid,
            "timestamp": FIRServerValue.timestamp(),
            "message": content,
            "photo_id": photoId,
            "likes_count": 0,
            "comments_count": 0
        ]
        let path1 = "posts/\(key)"
        let path2 = "user-post/\(uid)/posts/\(key)"
        let path3 = "user-feed/\(uid)/posts/\(key)"
        let path4 = "user-profile/\(uid)/post_count"
        let updates: [String: AnyObject] = [path1: data as AnyObject, path2: true as AnyObject, path3: true as AnyObject]

        let postCountRef = rootRef.child(path4)
        
        postCountRef.runTransactionBlock({ (data) -> FIRTransactionResult in
            if let val = data.value as? Int {
                data.value = val + 1
            } else {
                data.value = 1
            }
            return FIRTransactionResult.success(withValue: data)

            }, andCompletionBlock: { (error, committed, snap) in
                guard error == nil, committed else {
                    result.error = .failedToWrite(message: "Failed to write post")
                    callback?(result)
                    return
                }
                
                rootRef.updateChildValues(updates)
                
                let postsRef = rootRef.child(path1)
                let usersRef = rootRef.child("users/\(uid)")
                
                postsRef.observeSingleEvent(of: .value, with: { (postSnapshot) in
                    usersRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                        let user = User(with: userSnapshot, exception: "email")
                        let users = [uid: user]
                        
                        let post = Post(with: postSnapshot)
                        let posts = [post]

                        var list = PostList()
                        list.posts = posts
                        list.users = users
                        
                        result.posts = list
                        callback?(result)
                    })
                })
        })
    }

    func like(id: String, callback: ((PostServiceError?) -> Void)?) {
        var error: PostServiceError?
        guard session.isValid else {
            error = .authenticationNotFound(message: "Authentication not found")
            callback?(error)
            return
        }
        
        let userId = session.user.id
        let path1 = "posts/\(id)/likes_count"
        let path2 = "post-like/\(id)/likes"
        let rootRef = FIRDatabase.database().reference()
        let likesRef = rootRef.child(path2)
        let likesCountRef = rootRef.child(path1)
        
        likesRef.child(userId).observeSingleEvent(of: .value, with: { (data) in
            guard !data.exists() else {
                error = .failedToLike(message: "Already liked")
                callback?(error)
                return
            }
           
            likesCountRef.runTransactionBlock({ (data) -> FIRTransactionResult in
                if let val = data.value as? Int {
                    data.value = val + 1
                } else {
                    data.value = 1
                }
                return FIRTransactionResult.success(withValue: data)
                
                }, andCompletionBlock: { (err, committed, snap) in
                    guard err == nil, committed else {
                        error = .failedToLike(message: "Failed to like post.")
                        callback?(error)
                        return
                    }
                    
                    likesRef.child(userId).setValue(true)
                    callback?(nil)
            })
        })
    }

    func unlike(id: String, callback: ((PostServiceError?) -> Void)?) {
        var error: PostServiceError?
        guard session.isValid else {
            error = .authenticationNotFound(message: "Authentication not found")
            callback?(error)
            return
        }
        
        let userId = session.user.id
        let path1 = "posts/\(id)/likes_count"
        let path2 = "post-like/\(id)/likes"
        let rootRef = FIRDatabase.database().reference()
        let likesRef = rootRef.child(path2)
        let likesCountRef = rootRef.child(path1)
        
        likesRef.observeSingleEvent(of: .value, with: { (data) in
            guard data.exists() else {
                error = .failedToUnlike(message: "Post does not exist")
                callback?(error)
                return
            }
            
            likesCountRef.runTransactionBlock({ (data) -> FIRTransactionResult in
                if let val = data.value as? Int , val > 0 {
                    data.value = val - 1
                } else {
                    data.value = 0
                }
                return FIRTransactionResult.success(withValue: data)
                
                }, andCompletionBlock: { (err, committed, snap) in
                    guard err == nil, committed else {
                        error = .failedToUnlike(message: "Failed to unlike post")
                        callback?(error)
                        return
                    }
                    
                    likesRef.child(userId).removeValue()
                    callback?(nil)
            })
        })
    }

    func fetchLikes(id: String, offset: String, limit: UInt, callback: ((PostServiceLikeResult) -> Void)?) {
        var result = PostServiceLikeResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let path1 = "post-like/\(id)/likes"
        let path2 = "users"
        let rootRef = FIRDatabase.database().reference()
        let likesRef = rootRef.child(path1)
        let usersRef = rootRef.child(path2)
        var query = likesRef.queryOrderedByKey()
        
        if !offset.isEmpty {
            query = query.queryEnding(atValue: offset)
        }
        
        query = query.queryLimited(toLast: limit + 1)
        query.observeSingleEvent(of: .value, with: { (data) in
            guard data.exists(), data.childrenCount > 0 else {
                result.likes = [User]()
                callback?(result)
                return
            }
            
            var users = [User]()
            
            for child in data.children {
                guard let userChild = child as? FIRDataSnapshot else {
                    continue
                }
                
                let userKey = userChild.key
                let userRef = usersRef.child(userKey)
                
                userRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                    let user = User(with: userSnapshot, exception: "email")
                    users.append(user)
                    
                    let userCount = UInt(users.count)
                    if userCount == data.childrenCount {
                        if userCount == limit + 1 {
                            let removedUser = users.removeFirst()
                            result.nextOffset = removedUser.id
                        }
                        
                        result.likes = users.reversed()
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
