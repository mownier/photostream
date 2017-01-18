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
        let path6 = "user-post/\(id)/posts"
        
        let rootRef = FIRDatabase.database().reference()
        let followingCountRef = rootRef.child(path1)
        let followingRef = rootRef.child(path2)
        let followerCountRef = rootRef.child(path4)
        let userPostRef = rootRef.child(path6)
        
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
                            
                            userPostRef.observeSingleEvent(of: .value, with: { userPostSnapshot in
                                var updates: [AnyHashable: Any] = [
                                    path2: true,
                                    path3: true
                                ]
                                
                                for postChild in userPostSnapshot.children {
                                    guard let post = postChild as? FIRDataSnapshot else {
                                        continue
                                    }
                                    
                                    updates["\(path5)/\(post.key)"] = post.value
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
        let path6 = "user-post/\(id)/posts"
        
        let rootRef = FIRDatabase.database().reference()
        let followingCountRef = rootRef.child(path1)
        let followerCountRef = rootRef.child(path4)
        let userPostRef = rootRef.child(path6)
        
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
                        
                        let userActivityFollowRef = rootRef.child("user-activity/\(id)/activity-follow/\(uid)")
                        
                        userActivityFollowRef.observeSingleEvent(of: .value, with: { userActivitySnapshot in
                            userPostRef.observeSingleEvent(of: .value, with: { userPostSnapshot in
                                var updates: [AnyHashable: Any] = [
                                    path2: NSNull(),
                                    path3: NSNull()
                                ]
                                
                                for userPostChild in userPostSnapshot.children {
                                    guard let post = userPostChild as? FIRDataSnapshot else {
                                        continue
                                    }
                                    
                                    updates["\(path5)/\(post.key)"] = NSNull()
                                }
                                
                                if userActivitySnapshot.exists() {
                                    for child in userActivitySnapshot.children {
                                        guard let activitySnapshot = child as? FIRDataSnapshot else {
                                            continue
                                        }
                                        
                                        let activityKey = activitySnapshot.key
                                        
                                        // Removal of activities
                                        updates["activities/\(activityKey)"] = NSNull()
                                        updates["user-activity/\(id)/activities/\(activityKey)"] = NSNull()
                                    }
                                    
                                    updates["user-activity/\(id)/activity-follow/\(uid)"] = NSNull()
                                }
                                
                                rootRef.updateChildValues(updates)
                                callback?(nil)
                            })
                        })
                })
        })
    }
    
    func fetchFollowers(id: String, offset: String, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?) {
        let path = "user-follower/\(id)/followers"
        fetchFollowList(path: path, offset: offset, limit: limit, callback: callback)
    }

    func fetchFollowing(id: String, offset: String, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?) {
        let path = "user-following/\(id)/following"
        fetchFollowList(path: path, offset: offset, limit: limit, callback: callback)
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
            var following = [String]()
            var activities = [Activity]()
            
            let appendWith: (_ activity: Activity) -> Void = { activity in
                activities.append(activity)
                
                let activityCount = UInt(activities.count)
                
                if activityCount == queryResult.childrenCount {
                    if activityCount == limit + 1 {
                        let removedActivity = activities.removeFirst()
                        result.nextOffset = removedActivity.id
                    }
                    
                    let sorted = activities.sorted(by: { activity1, activity2 -> Bool in
                        return activity1.timestamp > activity2.timestamp
                    })
                    
                    var list = ActivityList()
                    list.activities = sorted
                    list.posts = posts
                    list.users = users
                    list.comments = comments
                    list.following = following
                    
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
                        let followingRef = rootRef.child("user-following/\(uid)/following/\(userId)")
                        
                        if users[userId] == nil {
                            userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                                followingRef.observeSingleEvent(of: .value, with: { followingSnapshot in
                                    if followingSnapshot.exists(), !following.contains(userId) {
                                        following.append(userId)
                                    }
                                    
                                    let user = User(with: userSnapshot, exception: "email")
                                    users[userId] = user
                                    
                                    appendWith(activity)
                                })
                            })
                            
                        } else {
                            guard !following.contains(userId) else {
                                appendWith(activity)
                                return
                            }
                            
                            followingRef.observeSingleEvent(of: .value, with: { followingSnapshot in
                                if followingSnapshot.exists() {
                                    following.append(userId)
                                }
                                
                                appendWith(activity)
                            })
                        }
                        
                    default:
                        break
                    }
                })
            }
        })
    }
    
    func editProfile(data: UserServiceProfileEditData, callback: ((UserServiceProfileEditResult) -> Void)?) {
        var result = UserServiceProfileEditResult()
        
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let rootRef = FIRDatabase.database().reference()
        
        let path1 = "users/\(uid)"
        let path2 = "user-profile/\(uid)"
        
        var updates = [AnyHashable: Any]()
        
        let performUpdates = { () -> Void in
            guard !updates.isEmpty else {
                result.editData = data
                callback?(result)
                return
            }
            
            rootRef.updateChildValues(updates, withCompletionBlock: { error, ref in
                guard error == nil else {
                    result.error = .failedToEditProfile(message: "Failed to edit profile")
                    callback?(result)
                    return
                }
                
                result.editData = data
                callback?(result)
            })
        }
        
        if !data.firstName.isEmpty, data.firstName != session.user.firstName {
            updates["\(path1)/firstname"] = data.firstName
        }
        
        if !data.lastName.isEmpty, data.lastName != session.user.lastName {
            updates["\(path1)/lastname"] = data.lastName
        }
        
        if !data.bio.isEmpty {
            updates["\(path2)/bio"] = data.bio
        }
        
        if !data.avatarUrl.isEmpty {
            updates["\(path1)/avatar_url"] = data.avatarUrl
        }
        
        if data.username.isEmpty {
            performUpdates()
            
        } else {
            let usersRef = rootRef.child("users")
            var query = usersRef.queryOrdered(byChild: "username")
            query = query.queryEqual(toValue: data.username)
            
            query.observeSingleEvent(of: .value, with: { queryResult in
                guard !queryResult.exists() else {
                    result.error = .failedToEditProfile(message: "Username is already taken")
                    callback?(result)
                    return
                }
                
                updates["\(path1)/username"] = data.username
                performUpdates()
            })
        }
    }
}

extension UserServiceProvider {
    
    fileprivate func fetchFollowList(path: String, offset: String, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?) {
        var result = UserServiceFollowListResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let path1 = "users"
        let path2 = "user-following/\(uid)/following"
        let rootRef = FIRDatabase.database().reference()
        let followingRef = rootRef.child(path2)
        let usersRef = rootRef.child(path1)
        let followRef = rootRef.child(path)
        var query = followRef.queryOrderedByKey()
        
        if !offset.isEmpty {
            query = query.queryEnding(atValue: offset)
        }
        
        query = query.queryLimited(toLast: limit + 1)
        query.observeSingleEvent(of: .value, with: { queryResult in
            guard queryResult.exists(), queryResult.childrenCount > 0 else {
                result.users = [User]()
                callback?(result)
                return
            }
            
            var users = [User]()
            var following = [String: Bool]()
            
            for child in queryResult.children {
                guard let childSnapshot = child as? FIRDataSnapshot else {
                    continue
                }
                
                let userId = childSnapshot.key
                
                let isFollowingRef = followingRef.child(userId)
                let userRef = usersRef.child(userId)
                
                isFollowingRef.observeSingleEvent(of: .value, with: { isFollowingSnapshot in
                    userRef.observeSingleEvent(of: .value, with: { userSnapshot in
                        let user = User(with: userSnapshot, exception: "email")
                        
                        if following[userId] == nil &&
                            (isFollowingSnapshot.exists() || userId == uid) {
                            following[userId] = userId == uid
                        }
                        
                        users.append(user)
                        
                        let userCount = UInt(users.count)
                        if userCount == queryResult.childrenCount {
                            if userCount == limit + 1 {
                                let removedUser = users.removeFirst()
                                result.nextOffset = removedUser.id
                            }
                            
                            result.users = users
                            result.following = following
                            callback?(result)
                        }
                    })
                })
            }
        })
    }
}
