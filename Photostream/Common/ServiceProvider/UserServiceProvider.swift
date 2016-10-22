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

class UserServiceProvider: UserService {

    private var session: AuthSession

    required init(session: AuthSession) {
        self.session = session
    }
    
    func fetchBasicInfo(id: String, callback: ((UserServiceBasicResult) -> Void)?) {
        
    }
    
    func follow(id: String, callback: ((UserServiceError?) -> Void)?) {
        var error: UserServiceError?
        if !session.isValid {
            error = .authenticationNotFound(message: "Authentication not found.")
            callback?(error)
        } else {
            let user = session.user
            let path1 = "users/\(user.id)/profile/following_count"
            let path2 = "users/\(user.id)/following/\(id)"
            let path3 = "users/\(id)/followers/\(user.id)"
            let path4 = "users/\(id)/profile/followers_count"
            let path5 = "users/\(user.id)/feed"
            let path6 = "users/\(id)/feed"

            let rootRef = FIRDatabase.database().reference()
            let followingCountRef = rootRef.child(path1)
            let followingRef = rootRef.child(path2)
            let followerRef = rootRef.child(path3)
            let followerCountRef = rootRef.child(path4)
            let feed1Ref = rootRef.child(path5)
            let feed2Ref = rootRef.child(path6)

            followingRef.observeSingleEvent(of: .value, with: { (data) in

                if !data.exists() {
                    followingRef.setValue(true)

                    followerRef.observeSingleEvent(of: .value, with: { (data2) in
                        followerRef.setValue(true)

                        followingCountRef.runTransactionBlock({ (data3) -> FIRTransactionResult in

                            if let val = data3.value as? Int , val > 0 {
                                data3.value = val + 1
                            } else {
                                data3.value = 1
                            }

                            return FIRTransactionResult.success(withValue: data3)

                            }, andCompletionBlock: { (err, committed, snap) in

                                if !committed {
                                    error = .failedToFollow(message: "Failed to follow.")
                                    callback?(error)
                                } else {
                                    followerCountRef.runTransactionBlock({ (data4) -> FIRTransactionResult in

                                        if let val = data4.value as? Int , val > 0 {
                                            data4.value = val + 1
                                        } else {
                                            data4.value = 1
                                        }

                                        return FIRTransactionResult.success(withValue: data4)

                                        }, andCompletionBlock: { (err, committed, snap) in

                                            if !committed {
                                                error = .failedToFollow(message: "Failed to follow.")
                                                callback?(error)
                                            } else {
                                                feed2Ref.observeSingleEvent(of: .value, with: { (data5) in

                                                    if let feeds = data5.value as? [String: AnyObject] {
                                                        feed1Ref.updateChildValues(feeds)
                                                    }
                                                    callback?(nil)
                                                })
                                            }
                                    })
                                }
                        })
                    })
                } else {
                    error = .failedToFollow(message: "Already followed")
                    callback?(error)
                }
            })
        }
    }

    func unfollow(id: String, callback: ((UserServiceError?) -> Void)?) {
        var error: UserServiceError?
        if !session.isValid {
            error = .authenticationNotFound(message: "Authentication not found.")
            callback?(error)
        } else {
            let user = session.user
            let path1 = "users/\(user.id)/profile/following_count"
            let path2 = "users/\(user.id)/following/\(id)"
            let path3 = "users/\(id)/followers/\(user.id)"
            let path4 = "users/\(id)/profile/followers_count"
            let path5 = "users/\(user.id)/feed"
            let path6 = "users/\(id)/feed"

            let rootRef = FIRDatabase.database().reference()
            let followingCountRef = rootRef.child(path1)
            let followingRef = rootRef.child(path2)
            let followerRef = rootRef.child(path3)
            let followerCountRef = rootRef.child(path4)
            let feed1Ref = rootRef.child(path5)
            let feed2Ref = rootRef.child(path6)

            followingRef.removeValue()
            followerRef.removeValue()
            followingCountRef.runTransactionBlock({ (data) -> FIRTransactionResult in

                if let val = data.value as? Int , val > 0 {
                    data.value = val - 1
                } else {
                    data.value = 0
                }

                return FIRTransactionResult.success(withValue: data)

                }, andCompletionBlock: { (err, committed, snap) in

                    if !committed {
                        error = .failedToUnfollow(message: "Failed to unfollow.")
                        callback?(error)
                    } else {
                        followerCountRef.runTransactionBlock({ (data2) -> FIRTransactionResult in

                            if let val = data2.value as? Int , val > 0 {
                                data2.value = val - 1
                            } else {
                                data2.value = 0
                            }

                            return FIRTransactionResult.success(withValue: data2)

                            }, andCompletionBlock: { (err, committed, snap) in

                                if !committed {
                                    error = .failedToUnfollow(message: "Failed to unfollow.")
                                    callback?(error)
                                } else {
                                    feed2Ref.observeSingleEvent(of: .value, with: { (data3) in

                                        for child in data3.children {
                                            feed1Ref.child((child as AnyObject).key).removeValue()
                                        }
                                        callback?(nil)
                                    })
                                }
                        })
                    }
            })
        }
    }
    
    func fetchFollowers(id: String, offset: UInt, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?) {
        fetchFollowList(path: "followers", userId: id, offset: offset, limit: limit, callback: callback)
    }

    func fetchFollowing(id: String, offset: UInt, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?) {        fetchFollowList(path: "following", userId: id, offset: offset, limit: limit, callback: callback)
    }

    func fetchProfile(id: String, callback: ((UserServiceProfileResult) -> Void)?) {
        var result = UserServiceProfileResult()
        if !session.isValid {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
        } else {
            let path1 = "users/\(id)/"
            let path2 = "profile"
            let rootRef = FIRDatabase.database().reference()
            let userRef = rootRef.child(path1)
            let profRef  = userRef.child(path2)
            userRef.observeSingleEvent(of: .value, with: { (data) in

                profRef.observeSingleEvent(of: .value, with: { (data2) in

                    var user = User()
                    user.id = data.childSnapshot(forPath: "id").value as! String
                    user.firstName = data.childSnapshot(forPath: "firstname").value as! String
                    user.lastName = data.childSnapshot(forPath: "lastname").value as! String

                    var profile = Profile()
                    profile.userId = user.id

                    if data2.hasChild("posts_count") {
                        profile.postsCount = data2.childSnapshot(forPath: "posts_count").value as! Int
                    }

                    if data2.hasChild("followers_count") {
                        profile.followersCount = data2.childSnapshot(forPath: "followers_count").value as! Int
                    }

                    if data2.hasChild("following_count") {
                        profile.followingCount = data2.childSnapshot(forPath: "following_count").value as! Int
                    }

                    result.user = user
                    result.profile = profile
                    callback?(result)
                })
            })
        }
    }

    private func fetchFollowList(path: String!, userId: String!, offset: UInt!, limit: UInt!, callback: ((UserServiceFollowListResult) -> Void)?) {
        var result = UserServiceFollowListResult()
        if !session.isValid {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
        } else {
            let path1 = "users"
            let path2 = "users/\(userId)/\(path)"
            let rootRef = FIRDatabase.database().reference()
            let userRef = rootRef.child(path1)
            let followerRef = rootRef.child(path2)

            followerRef.observeSingleEvent(of: .value, with: { (data) in

                var userList = [User]()

                if !data.exists() {
                    result.users = userList
                    callback?(result)
                } else {
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
                }
            })
        }
    }
}
