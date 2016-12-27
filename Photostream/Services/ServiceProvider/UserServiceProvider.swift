//
//  UserServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct UserServiceProvider: UserService {

    fileprivate var session: AuthSession

    init(session: AuthSession) {
        self.session = session
    }
    
    func fetchBasicInfo(id: String, callback: ((UserServiceBasicResult) -> Void)?) {
        
    }
    
    func follow(id: String, callback: ((UserServiceError?) -> Void)?) {
        var error: UserServiceError?
        guard session.isValid else {
            error = .authenticationNotFound(message: "Authentication not found")
            callback?(error)
            return
        }
        
        guard id != session.user.id else {
            error = .failedToFollow(message: "You can only follow other than your self.")
            callback?(error)
            return
        }
        
        let uid = session.user.id
        let path1 = "user-profile/\(uid)/following_count"
        let path2 = "user-following/\(uid)/following/\(id)"
        let path3 = "user-follower/\(id)/followers/\(uid)"
        let path4 = "user-profile/\(id)/follower_count"
        let path5 = "user-feed/\(uid)/posts"
        let path6 = "user-feed/\(id)/posts"
        
        let rootRef = FIRDatabase.database().reference()
        let followingCountRef = rootRef.child(path1)
        let followingRef = rootRef.child(path2)
        let followerCountRef = rootRef.child(path4)
        let feed2Ref = rootRef.child(path6)
        
        followingRef.observeSingleEvent(of: .value, with: { (followingSnapshot) in
            guard !followingSnapshot.exists() else {
                error = .failedToFollow(message: "Already followed")
                callback?(error)
                return
            }
            
            followingCountRef.runTransactionBlock({ (followingCountSnapshot) -> FIRTransactionResult in
                if let val = followingCountSnapshot.value as? Int , val > 0 {
                    followingCountSnapshot.value = val + 1
                    
                } else {
                    followingCountSnapshot.value = 1
                }
                return FIRTransactionResult.success(withValue: followingCountSnapshot)
                
                }, andCompletionBlock: { (err, committed, snap) in
                    guard committed else {
                        error = .failedToFollow(message: "Failed to follow")
                        callback?(error)
                        return
                    }
                    
                    followerCountRef.runTransactionBlock({ (followerCountSnapshot) -> FIRTransactionResult in
                        if let val = followerCountSnapshot.value as? Int , val > 0 {
                            followerCountSnapshot.value = val + 1
                            
                        } else {
                            followerCountSnapshot.value = 1
                        }
                        return FIRTransactionResult.success(withValue: followerCountSnapshot)
                        
                        }, andCompletionBlock: { (err, committed, snap) in
                            guard committed else {
                                error = .failedToFollow(message: "Failed to follow")
                                callback?(error)
                                return
                            }
                            
                            feed2Ref.observeSingleEvent(of: .value, with: { feed2Snapshot in
                                var updates: [AnyHashable: Any] = [
                                    path2: true,
                                    path3: true
                                ]
                                
                                for feed2Child in feed2Snapshot.children {
                                    guard let feed2 = feed2Child as? FIRDataSnapshot else {
                                        continue
                                    }
                                    
                                    updates["\(path5)/\(feed2.key)"] = feed2.value
                                }
                                
                                let activitiesRef = rootRef.child("activities")
                                let activityKey = activitiesRef.childByAutoId().key
                                let activityUpdate: [AnyHashable: Any] = [
                                    "id": activityKey,
                                    "type": "follow",
                                    "trigger_by": uid,
                                    "timestamp": FIRServerValue.timestamp()
                                ]
                                updates["activities/\(activityKey)"] = activityUpdate
                                updates["user-activity/\(id)/activities/\(activityKey)"] = true
                                updates["user-activity/\(id)/activity-follow/\(uid)"] = [activityKey: true]
                                
                                rootRef.updateChildValues(updates)
                                callback?(nil)
                            })
                    })
            })
        })
    }

    func unfollow(id: String, callback: ((UserServiceError?) -> Void)?) {
        var error: UserServiceError?
        guard session.isValid else {
            error = .authenticationNotFound(message: "Authentication not found.")
            callback?(error)
            return
        }
        
        guard id != session.user.id else {
            error = .failedToUnfollow(message: "You can only unfollow other than your self.")
            callback?(error)
            return
        }
        
        let uid = session.user.id
        let path1 = "user-profile/\(uid)/following_count"
        let path2 = "user-following/\(uid)/following/\(id)"
        let path3 = "user-follower/\(id)/followers/\(uid)"
        let path4 = "user-profile/\(id)/follower_count"
        let path5 = "user-feed/\(uid)/posts"
        let path6 = "user-feed/\(id)/posts"
        
        let rootRef = FIRDatabase.database().reference()
        let followingCountRef = rootRef.child(path1)
        let followingRef = rootRef.child(path2)
        let followerRef = rootRef.child(path3)
        let followerCountRef = rootRef.child(path4)
        let feed1Ref = rootRef.child(path5)
        let feed2Ref = rootRef.child(path6)
        
        followingCountRef.runTransactionBlock({ (followingCountSnapshot) -> FIRTransactionResult in
            if let val = followingCountSnapshot.value as? Int , val > 0 {
                followingCountSnapshot.value = val - 1
                
            } else {
                followingCountSnapshot.value = 0
            }
            return FIRTransactionResult.success(withValue: followingCountSnapshot)
            
            }, andCompletionBlock: { (err, committed, snap) in
                guard committed else {
                    error = .failedToUnfollow(message: "Failed to unfollow")
                    callback?(error)
                    return
                }
                
                followerCountRef.runTransactionBlock({ (followerCountSnapshot) -> FIRTransactionResult in
                    if let val = followerCountSnapshot.value as? Int , val > 0 {
                        followerCountSnapshot.value = val - 1
                        
                    } else {
                        followerCountSnapshot.value = 0
                    }
                    return FIRTransactionResult.success(withValue: followerCountSnapshot)
                    
                    }, andCompletionBlock: { (err, committed, snap) in
                        guard committed else {
                            error = .failedToUnfollow(message: "Failed to unfollow")
                            callback?(error)
                            return
                        }
                        
                        feed2Ref.observeSingleEvent(of: .value, with: { (feed2Snapshot) in
                            for child in feed2Snapshot.children {
                                guard let childSnapshot = child as? FIRDataSnapshot else {
                                    continue
                                }
                                
                                let key = childSnapshot.key
                                feed1Ref.child(key).removeValue()
                            }
                            
                            followingRef.removeValue()
                            followerRef.removeValue()
                            
                            callback?(nil)
                        })
                })
        })
    }
    
    func fetchFollowers(id: String, offset: UInt, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?) {
        fetchFollowList(path: "followers", userId: id, offset: offset, limit: limit, callback: callback)
    }

    func fetchFollowing(id: String, offset: UInt, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?) {        fetchFollowList(path: "following", userId: id, offset: offset, limit: limit, callback: callback)
    }

    func fetchProfile(id: String, callback: ((UserServiceProfileResult) -> Void)?) {
        var result = UserServiceProfileResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let path1 = "users/\(id)/"
        let path2 = "user-profile/\(id)"
        let path3 = "user-follower/\(id)/followers/\(uid)"
        let rootRef = FIRDatabase.database().reference()
        let usersRef = rootRef.child(path1)
        let profileRef = rootRef.child(path2)
        let followerRef = rootRef.child(path3)
        
        followerRef.observeSingleEvent(of: .value, with: { (follow) in
            usersRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                profileRef.observeSingleEvent(of: .value, with: { (profileSnapshot) in
                    let user = User(with: userSnapshot, exception: "email")
                    var profile = Profile(with: profileSnapshot)
                    profile.userId = user.id
                    
                    result.user = user
                    result.profile = profile
                    result.isFollowed = follow.exists()
                    callback?(result)
                })
            })
        })

    }
    
    func fetchActivities(id: String, offset: String, limit: UInt, callback: ((UserServiceActivityListResult) -> Void)?) {
        var result = UserServiceActivityListResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            return
        }
        
        let uid = session.user.id
        let path1 = "user-activity/\(uid)/activities"
        let path2 = "activities"
        let rootRef = FIRDatabase.database().reference()
        let userActivityRef = rootRef.child(path1)
        let activitiesRef = rootRef.child(path2)
        
        var query = userActivityRef.queryOrderedByKey()
        
        if !offset.isEmpty {
            query = query.queryEnding(atValue: offset)
        }
        
        query = query.queryLimited(toLast: limit + 1)
        
        query.observeSingleEvent(of: .value, with: { queryResult -> Void in
            guard queryResult.childrenCount > 0 else {
                result.list = ActivityList()
                callback?(result)
                return
            }
            
            var posts = [String: Post]()
            var users = [String: User]()
            var comments = [String: Comment]()
            var activities = [Activity]()
            
            let appendWith: (_ activity: Activity) -> Void = { activity in
                activities.append(activity)
                
                let activityCount = UInt(activities.count)
                
                if activityCount == queryResult.childrenCount {
                    if activityCount == limit + 1 {
                        let removedActivity = activities.removeFirst()
                        result.nextOffset = removedActivity.id
                    }
                    
                    var list = ActivityList()
                    list.activities = activities.reversed()
                    list.posts = posts
                    list.users = users
                    list.comments = comments
                    
                    result.list = list
                    
                    callback?(result)
                }
            }
            
            for child in queryResult.children {
                guard let userActivity = child as? FIRDataSnapshot else {
                    continue
                }
                
                let activityId = userActivity.key
                let activityRef = activitiesRef.child(activityId)
                
                activityRef.observeSingleEvent(of: .value, with: { activitySnapshot in
                    let activity = Activity(with: activitySnapshot)
                    
                    switch activity.type {
                    case .like(let userId, let postId),
                         .post(let userId, let postId):
                        let userRef = rootRef.child("users/\(userId)")
                        let postRef = rootRef.child("posts/\(postId)")
                        
                        // If both user and post does not exist
                        // user => !exist
                        // post => !exist
                        if users[userId] == nil && posts[postId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                postRef.observeSingleEvent(of: .value, with: { postSnapshot in
                                    guard postSnapshot.hasChild("photo_id"),
                                        let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                                            return
                                    }
                                    
                                    let photoRef = rootRef.child("photos/\(photoId)")
                                    photoRef.observeSingleEvent(of: .value, with: { photoSnapshot in
                                        let photo = Photo(with: photoSnapshot)
                                        var post = Post(with: postSnapshot)
                                        post.photo = photo
                                        posts[postId] = post
                                        
                                        let user = User(with: userSnapshot, exception: "email")
                                        users[userId] = user
                                        
                                        appendWith(activity)
                                    })
                                })
                            })
                            
                        // If user does not exist while post does exist
                        // user => !exist
                        // post => exist
                        } else if users[userId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                let user = User(with: userSnapshot, exception: "email")
                                users[userId] = user
                                
                                appendWith(activity)
                            })
                        
                        // If user does exist while post does not exist
                        // user => exist
                        // post => !exist
                        } else if posts[postId] == nil {
                            postRef.observeSingleEvent(of: .value, with: { postSnapshot in
                                guard postSnapshot.hasChild("photo_id"),
                                    let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                                        return
                                }
                                
                                let photoRef = rootRef.child("photos/\(photoId)")
                                photoRef.observeSingleEvent(of: .value, with: { photoSnapshot in
                                    let photo = Photo(with: photoSnapshot)
                                    var post = Post(with: postSnapshot)
                                    post.photo = photo
                                    posts[postId] = post
                                    
                                    appendWith(activity)
                                })
                            })
                            
                        } else {
                            appendWith(activity)
                        }
                    
                    case .comment(let userId, let commentId, let postId):
                        let userRef = rootRef.child("users/\(userId)")
                        let commentRef = rootRef.child("comments/\(commentId)")
                        let postRef = rootRef.child("posts/\(postId)")
                        
                        if users[userId] == nil, comments[commentId] == nil, posts[postId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                commentRef.observeSingleEvent(of: .value, with: { commentSnapshot in
                                    postRef.observeSingleEvent(of: .value, with: { postSnapshot in
                                        guard postSnapshot.hasChild("photo_id"),
                                            let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                                            return
                                        }
                                        
                                        let photoRef = rootRef.child("photos/\(photoId)")
                                        
                                        photoRef.observeSingleEvent(of: .value, with: { photoSnapshot in
                                            let photo = Photo(with: photoSnapshot)
                                            var post = Post(with: postSnapshot)
                                            post.photo = photo
                                            posts[postId] = post
                                            
                                            let user = User(with: userSnapshot, exception: "email")
                                            users[userId] = user
                                            
                                            let comment = Comment(with: commentSnapshot)
                                            comments[commentId] = comment
                                            
                                            appendWith(activity)
                                        })
                                    })
                                })
                            })
                            
                        } else if users[userId] == nil, comments[commentId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                commentRef.observeSingleEvent(of: .value, with: { commentSnapshot in
                                    let user = User(with: userSnapshot, exception: "email")
                                    users[userId] = user
                                    
                                    let comment = Comment(with: commentSnapshot)
                                    comments[commentId] = comment
                                    
                                    appendWith(activity)
                                })
                            })
                            
                        } else if users[userId] == nil, posts[postId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                postRef.observeSingleEvent(of: .value, with: { postSnapshot in
                                    guard postSnapshot.hasChild("photo_id"),
                                        let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                                        return
                                    }
                                    
                                    let photoRef = rootRef.child("photos/\(photoId)")
                                    
                                    photoRef.observeSingleEvent(of: .value, with: { photoSnapshot in
                                        let photo = Photo(with: photoSnapshot)
                                        var post = Post(with: postSnapshot)
                                        post.photo = photo
                                        posts[postId] = post
                                        
                                        let user = User(with: userSnapshot, exception: "email")
                                        users[userId] = user
                                        
                                        appendWith(activity)
                                    })
                                })
                            })
                            
                        } else if comments[commentId] == nil, posts[postId] == nil {
                            commentRef.observeSingleEvent(of: .value, with: { commentSnapshot in
                                postRef.observeSingleEvent(of: .value, with: { postSnapshot in
                                    guard postSnapshot.hasChild("photo_id"),
                                        let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                                            return
                                    }
                                    
                                    let photoRef = rootRef.child("photos/\(photoId)")
                                    
                                    photoRef.observeSingleEvent(of: .value, with: { photoSnapshot in
                                        let photo = Photo(with: photoSnapshot)
                                        var post = Post(with: postSnapshot)
                                        post.photo = photo
                                        posts[postId] = post
                                        
                                        let comment = Comment(with: commentSnapshot)
                                        comments[commentId] = comment
                                        
                                        appendWith(activity)
                                    })
                                })
                            })
                        } else if users[userId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                let user = User(with: userSnapshot, exception: "email")
                                users[userId] = user
                                
                                appendWith(activity)
                            })
                            
                        } else if comments[commentId] == nil {
                            commentRef.observeSingleEvent(of: .value, with: { commentSnapshot in
                                let comment = Comment(with: commentSnapshot)
                                comments[commentId] = comment
                                
                                appendWith(activity)
                            })
                            
                        } else if posts[postId] == nil {
                            postRef.observeSingleEvent(of: .value, with: { postSnapshot in
                                guard postSnapshot.hasChild("photo_id"),
                                    let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                                        return
                                }
                                
                                let photoRef = rootRef.child("photos/\(photoId)")
                                
                                photoRef.observeSingleEvent(of: .value, with: { photoSnapshot in
                                    let photo = Photo(with: photoSnapshot)
                                    var post = Post(with: postSnapshot)
                                    post.photo = photo
                                    posts[postId] = post
                                    
                                    appendWith(activity)
                                })
                            })
                            
                        } else {
                            appendWith(activity)
                        }
                    
                    case .follow(let userId):
                        let userRef = rootRef.child("users/\(userId)")
                        
                        if users[userId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                let user = User(with: userSnapshot, exception: "email")
                                users[userId] = user
                                
                                appendWith(activity)
                            })
                            
                        } else {
                            appendWith(activity)
                        }
                        
                    default:
                        break
                    }
                })
            }
        })
    }
}

extension UserServiceProvider {
    
    fileprivate func fetchFollowList(path: String!, userId: String!, offset: UInt!, limit: UInt!, callback: ((UserServiceFollowListResult) -> Void)?) {
        var result = UserServiceFollowListResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let path1 = "users"
        let path2 = "users/\(userId)/\(path)"
        let rootRef = FIRDatabase.database().reference()
        let userRef = rootRef.child(path1)
        let followerRef = rootRef.child(path2)
        
        followerRef.observeSingleEvent(of: .value, with: { (data) in
            var userList = [User]()
            guard data.exists() else {
                result.users = userList
                callback?(result)
                return
            }
            
            for child in data.children {
                userRef.child((child as AnyObject).key).observeSingleEvent(of: .value, with: { (data2) in
                    var user = User()
                    user.id = data2.childSnapshot(forPath: "id").value as! String
                    user.firstName = data2.childSnapshot(forPath: "firstname").value as! String
                    user.lastName = data2.childSnapshot(forPath: "lastname").value as! String
                    
                    userList.append(user)
                    
                    if UInt(userList.count) == data.childrenCount {
                        result.users = userList
                        callback?(result)
                    }
                })
            }
        })
    }
}
