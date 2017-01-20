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
        let path = "user-post/\(userId)/posts"
        fetchUserPosts(path: path, offset: offset, limit: limit, callback: callback)
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
        let postKey = rootRef.child("posts").childByAutoId().key
        
        let path1 = "posts/\(postKey)"
        let path2 = "user-post/\(uid)/posts/\(postKey)"
        let path3 = "user-feed/\(uid)/posts/\(postKey)"
        let path4 = "user-profile/\(uid)/post_count"
        let path5 = "user-follower/\(uid)/followers"

        let postCountRef = rootRef.child(path4)
        let followerRef = rootRef.child(path5)
        
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
                
                followerRef.observeSingleEvent(of: .value, with: { followerSnapshot in
                    let postUpdate: [AnyHashable: Any] = [
                        "id": postKey,
                        "uid": uid,
                        "timestamp": FIRServerValue.timestamp(),
                        "message": content,
                        "photo_id": photoId,
                        "likes_count": 0,
                        "comments_count": 0
                    ]
                    
                    var updates: [AnyHashable: Any] = [
                        path1: postUpdate,
                        path2: true,
                        path3: true
                    ]
                    
                    let activitiesRef = rootRef.child("activities")
                    
                    for childSnapshot in followerSnapshot.children {
                        guard let follower = childSnapshot as? FIRDataSnapshot else {
                            continue
                        }
                        
                        let followerId = follower.key
                        
                        // Update follower's feed
                        updates["user-feed/\(followerId)/posts/\(postKey)"] = true
                        
                        // Update follower's activity
                        let activityKey = activitiesRef.childByAutoId().key
                        let activityUpdate: [AnyHashable: Any] = [
                            "id": activityKey,
                            "type": "post",
                            "trigger_by": uid,
                            "post_id": postKey,
                            "timestamp": FIRServerValue.timestamp()
                        ]
                        updates["activities/\(activityKey)"] = activityUpdate
                        updates["user-activity/\(followerId)/activities/\(activityKey)"] = true
                        updates["user-activity/\(followerId)/activity-post/\(postKey)/\(uid)/\(activityKey)"] = true
                    }
                    
                    rootRef.updateChildValues(updates, withCompletionBlock: { error, ref in
                        guard error == nil else {
                            result.error = .failedToWrite(message: "Failed to write post")
                            callback?(result)
                            return
                        }
                        
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
        
        let uid = session.user.id
        
        let path1 = "posts/\(id)/likes_count"
        let path2 = "post-like/\(id)/likes"
        let path3 = "posts/\(id)/uid"
        
        let rootRef = FIRDatabase.database().reference()
        let likesRef = rootRef.child(path2)
        let likesCountRef = rootRef.child(path1)
        let authorRef = rootRef.child(path3)
        
        authorRef.observeSingleEvent(of: .value, with: { authorSnapshot in
            guard let authorId = authorSnapshot.value as? String else {
                error = .failedToLike(message: "Failed to like post")
                callback?(error)
                return
            }
            
            likesRef.child(uid).observeSingleEvent(of: .value, with: { (data) in
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
                            error = .failedToLike(message: "Failed to like post")
                            callback?(error)
                            return
                        }
                        
                        var updates: [AnyHashable: Any] = [
                            "\(path2)/\(uid)": true,
                            "user-like/\(uid)/posts/\(id)": true
                        ]
                        
                        if authorId != uid {
                            let activitiesRef = rootRef.child("activities")
                            let activityKey = activitiesRef.childByAutoId().key
                            let activityUpdate: [AnyHashable: Any] = [
                                "id": activityKey,
                                "type": "like",
                                "trigger_by": uid,
                                "post_id": id,
                                "timestamp": FIRServerValue.timestamp()
                            ]
                            updates["activities/\(activityKey)"] = activityUpdate
                            updates["user-activity/\(authorId)/activities/\(activityKey)"] = true
                            updates["user-activity/\(authorId)/activity-like/\(id)/\(uid)"] = [activityKey: true]
                        }
                        
                        rootRef.updateChildValues(updates)
                        callback?(nil)
                })
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
        
        let uid = session.user.id
        
        let path1 = "posts/\(id)/likes_count"
        let path2 = "post-like/\(id)/likes"
        let path3 = "posts/\(id)/uid"
        
        let rootRef = FIRDatabase.database().reference()
        let likesRef = rootRef.child(path2)
        let likesCountRef = rootRef.child(path1)
        let authorRef = rootRef.child(path3)
        
        authorRef.observeSingleEvent(of: .value, with: { authorSnapshot in
            guard let authorId = authorSnapshot.value as? String else {
                error = .failedToUnlike(message: "Failed to unlike post")
                callback?(error)
                return
            }
            
            let userActivityLikeRef = rootRef.child("user-activity/\(authorId)/activity-like/\(id)/\(uid)")
            
            userActivityLikeRef.observeSingleEvent(of: .value, with: { userActivitySnapshot in
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
                            
                            var updates: [AnyHashable: Any] = [
                                "\(path2)/\(uid)": NSNull(),
                                "user-like/\(uid)/posts/\(id)": NSNull()
                            ]
                            
                            if authorId != uid {
                                for child in userActivitySnapshot.children {
                                    guard let activitySnapshot = child as? FIRDataSnapshot else {
                                        continue
                                    }
                                    
                                    let activityKey = activitySnapshot.key
                                    
                                    // Removal of activities
                                    updates["activities/\(activityKey)"] = NSNull()
                                    updates["user-activity/\(authorId)/activities/\(activityKey)"] = NSNull()
                                }
                                
                                updates["user-activity/\(authorId)/activity-like/\(id)/\(uid)"] = NSNull()
                            }
                            
                            rootRef.updateChildValues(updates)
                            callback?(nil)
                    })
                })
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
        
        let uid = session.user.id
  
        let path1 = "post-like/\(id)/likes"
        let path2 = "users"
        let path3 = "user-following/\(uid)/following"
        
        let rootRef = FIRDatabase.database().reference()
        let likesRef = rootRef.child(path1)
        let usersRef = rootRef.child(path2)
        let followingRef = rootRef.child(path3)
        
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
            var following = [String: Bool]()
            
            for child in data.children {
                guard let userChild = child as? FIRDataSnapshot else {
                    continue
                }
                
                let userKey = userChild.key
                let userRef = usersRef.child(userKey)
                let isFollowingRef = followingRef.child(userKey)
                
                isFollowingRef.observeSingleEvent(of: .value, with: { isFollowingSnapshot in
                    userRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                        let user = User(with: userSnapshot, exception: "email")
                        
                        if following[userKey] == nil &&
                            (isFollowingSnapshot.exists() || userKey == uid) {
                            following[userKey] = userKey == uid
                        }
                        
                        users.append(user)
                        
                        let userCount = UInt(users.count)
                        if userCount == data.childrenCount {
                            if userCount == limit + 1 {
                                let removedUser = users.removeFirst()
                                result.nextOffset = removedUser.id
                            }
                            
                            result.likes = users
                            result.following = following
                            callback?(result)
                        }
                    })
                })
            }
        })
    }
    
    func fetchPostInfo(id: String, callback: ((PostServiceResult) -> Void)?) {
        var result = PostServiceResult()
        
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let path1 = "posts/\(id)"
        let rootRef = FIRDatabase.database().reference()
        let postRef = rootRef.child(path1)
        
        postRef.observeSingleEvent(of: .value, with: { postSnapshot in
            guard postSnapshot.exists(),
                let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                result.error = .failedToFetch(message: "Post not found")
                callback?(result)
                return
            }
            
            var posts = [Post]()
            var users = [String: User]()
            
            let post = Post(with: postSnapshot)
            let posterId = post.userId
            
            let userRef = rootRef.child("users").child(posterId)
            let photoRef = rootRef.child("photos").child(photoId)
            let likesRef = rootRef.child("post-like/\(id)/likes")
            
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
                        post.isLiked = likesSnapshot.hasChild(uid)
                        
                        posts.append(post)
                        
                        var list = PostList()
                        list.posts = posts
                        list.users = users
                        
                        result.posts = list
                        
                        callback?(result)
                    })
                })
            })
        })
    }
    
    func fetchDiscoveryPosts(offset: String, limit: UInt, callback: ((PostServiceResult) -> Void)?) {
        var result = PostServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let path1 = "posts"
        let rootRef = FIRDatabase.database().reference()
        let postsRef = rootRef.child(path1)
        
        var query = postsRef.queryOrderedByKey()
        
        if !offset.isEmpty {
            query = query.queryEnding(atValue: offset)
        }
        
        query = query.queryLimited(toLast: limit + 1)
        
        query.observeSingleEvent(of: .value, with: { queryResult -> Void in
            guard queryResult.childrenCount > 0 else {
                result.posts = PostList()
                callback?(result)
                return
            }
            
            var posts = [Post]()
            var users = [String: User]()
            var discoveryPosts = [String]()
            var discoveryPostAuthors = [String]()
            
            for child in queryResult.children {
                guard let postSnapshot = child as? FIRDataSnapshot,
                    let posterId = postSnapshot.childSnapshot(forPath: "uid").value as? String,
                    let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                    continue
                }
                
                let postId = postSnapshot.key
                let userRef = rootRef.child("users").child(posterId)
                let photoRef = rootRef.child("photos").child(photoId)
                let likedRef = rootRef.child("post-likes").child(postId).child(uid)
                let followingRef = rootRef.child("user-following").child(uid).child("following").child(posterId)
                
                followingRef.observeSingleEvent(of: .value, with: { followingSnapshot in
                    likedRef.observeSingleEvent(of: .value, with: { likedSnapshot in
                        userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                            photoRef.observeSingleEvent(of: .value, with: { photoSnapshot in
                                if users[posterId] == nil {
                                    let user = User(with: userSnapshot)
                                    users[posterId] = user
                                }
                                
                                var post = Post(with: postSnapshot)
                                let photo = Photo(with: photoSnapshot)
                                
                                post.photo = photo
                                post.isLiked = likedSnapshot.exists()
                                
                                posts.append(post)
                                
                                if !followingSnapshot.exists() && posterId != uid {
                                    discoveryPosts.append(postId)
                                    
                                    if !discoveryPostAuthors.contains(posterId) {
                                        discoveryPostAuthors.append(posterId)
                                    }
                                }
                                
                                let postCount = UInt(posts.count)
                                if postCount == queryResult.childrenCount {
                                    if postCount == limit + 1 {
                                        let removedPost = posts.removeFirst()
                                        result.nextOffset = removedPost.id
                                    }
                                    
                                    var list = PostList()
                                    
                                    // Filtered posts based on the post id in
                                    // 'discoveryPosts' array.
                                    list.posts = posts.filter({ post -> Bool in
                                        return discoveryPosts.contains(post.id)
                                    }).sorted(by: { post1, post2 -> Bool in
                                        return post1.timestamp > post2.timestamp
                                    })
                                    
                                    // Filtered users based on the user id in
                                    // 'discoveryPostAuthors' array.
                                    let filteredUsers = users.filter({ (entry: (key: String, value: User)) -> Bool in
                                        return discoveryPostAuthors.contains(entry.key)
                                    })
                                    
                                    // Filtered users is reduced and converted
                                    // to dictionary with type '[String: User]'
                                    list.users = filteredUsers.reduce([String: User]()) { dict, entry -> [String: User] in
                                        var info = dict
                                        info[entry.key] = entry.value
                                        return info
                                    }
                                    
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
    
    func fetchLikedPosts(userId: String, offset: String, limit: UInt, callback: ((PostServiceResult) -> Void)?) {
        let path = "user-like/\(userId)/posts"
        fetchUserPosts(path: path, offset: offset, limit: limit, callback: callback)
    }
}

extension PostServiceProvider {
    
    fileprivate func fetchUserPosts(path: String, offset: String, limit: UInt, callback: ((PostServiceResult) -> Void)?) {
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
        let userPostRef = rootRef.child(path)
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
                                    
                                    let sorted = posts.sorted(by: { post1, post2 -> Bool in
                                        return post1.timestamp > post2.timestamp
                                    })
                                    
                                    var list = PostList()
                                    list.posts = sorted
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
}
