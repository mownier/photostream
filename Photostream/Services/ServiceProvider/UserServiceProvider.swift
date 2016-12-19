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

    private var session: AuthSession

    init(session: AuthSession) {
        self.session = session
    }
    
    func fetchBasicInfo(id: String, callback: ((UserServiceBasicResult) -> Void)?) {
        
    }
    
    func follow(id: String, callback: ((UserServiceError?) -> Void)?) {
        var error: UserServiceError?
        guard session.isValid else {
            error = .authenticationNotFound(message: "Authentication not found.")
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
                            
                            feed2Ref.observeSingleEvent(of: .value, with: { (feed1Snapshot) in
                                if let feed1 = feed1Snapshot.value as? [AnyHashable: Any] {
                                    feed1Ref.updateChildValues(feed1)
                                }
                                
                                followingRef.setValue(true)
                                followerRef.setValue(true)
                                
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

    private func fetchFollowList(path: String!, userId: String!, offset: UInt!, limit: UInt!, callback: ((UserServiceFollowListResult) -> Void)?) {
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
