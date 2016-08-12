//
//  UserAPIFirebase.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserAPIFirebase: UserService {

    var session: AuthSession!

    required init(session: AuthSession!) {
        self.session = session
    }

    func follow(userId: String!, callback: UserServiceFollowCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let user = session!.user
            let path1 = "users/\(user.id)/profile/following_count"
            let path2 = "users/\(user.id)/following/\(userId)"
            let path3 = "users/\(userId)/followers/\(user.id)"
            let path4 = "users/\(userId)/profile/followers_count"
            let path5 = "users/\(user.id)/feed"
            let path6 = "users/\(userId)/feed"

            let rootRef = FIRDatabase.database().reference()
            let followingCountRef = rootRef.child(path1)
            let followingRef = rootRef.child(path2)
            let followerRef = rootRef.child(path3)
            let followerCountRef = rootRef.child(path4)
            let feed1Ref = rootRef.child(path5)
            let feed2Ref = rootRef.child(path6)

            followingRef.observeSingleEventOfType(.Value, withBlock: { (data) in

                if let _ = data.value as? NSNull {
                    followingRef.setValue(true)

                    followerRef.observeSingleEventOfType(.Value, withBlock: { (data2) in
                        followerRef.setValue(true)

                        followingCountRef.runTransactionBlock({ (data3) -> FIRTransactionResult in

                            if let val = data3.value as? Int where val > 0 {
                                data3.value = val + 1
                            } else {
                                data3.value = 1
                            }

                            return FIRTransactionResult.successWithValue(data3)

                            }, andCompletionBlock: { (error, committed, snap) in

                                if !committed {
                                    callback(false, error)
                                } else {
                                    followerCountRef.runTransactionBlock({ (data4) -> FIRTransactionResult in

                                        if let val = data4.value as? Int where val > 0 {
                                            data4.value = val + 1
                                        } else {
                                            data4.value = 1
                                        }

                                        return FIRTransactionResult.successWithValue(data4)

                                        }, andCompletionBlock: { (error, committed, snap) in

                                            if !committed {
                                                callback(false, error)
                                            } else {
                                                feed2Ref.observeSingleEventOfType(.Value, withBlock: { (data5) in

                                                    if let feeds = data5.value as? [String: AnyObject] {
                                                        feed1Ref.updateChildValues(feeds)
                                                    }
                                                    callback(true, nil)
                                                })
                                            }
                                    })
                                }
                        })
                    })
                } else {
                    callback(false, NSError(domain: "UserAPIFirebase", code: 0, userInfo: ["message": "Already followed."]))
                }
            })
        }
    }

    func unfollow(userId: String!, callback: UserServiceFollowCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let user = session!.user
            let path1 = "users/\(user.id)/profile/following_count"
            let path2 = "users/\(user.id)/following/\(userId)"
            let path3 = "users/\(userId)/followers/\(user.id)"
            let path4 = "users/\(userId)/profile/followers_count"
            let path5 = "users/\(user.id)/feed"
            let path6 = "users/\(userId)/feed"

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
                        followerCountRef.runTransactionBlock({ (data2) -> FIRTransactionResult in

                            if let val = data2.value as? Int where val > 0 {
                                data2.value = val - 1
                            } else {
                                data2.value = 0
                            }

                            return FIRTransactionResult.successWithValue(data2)

                            }, andCompletionBlock: { (error, committed, snap) in

                                if !committed {
                                    callback(false, error)
                                } else {
                                    feed2Ref.observeSingleEventOfType(.Value, withBlock: { (data3) in

                                        for child in data3.children {
                                            feed1Ref.child(child.key).removeValue()
                                        }
                                        callback(true, nil)
                                    })
                                }
                        })
                    }
            })
        }
    }

    func fetchFollowers(userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!) {
        fetchFollowList("followers", userId: userId, offset: offset, limit: limit, callback: callback)
    }

    func fetchFollowing(userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!) {
        fetchFollowList("following", userId: userId, offset: offset, limit: limit, callback: callback)
    }

    func fetchProfile(userId: String!, callback: UserServiceProfileCallback) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let path1 = "users/\(userId)/"
            let path2 = "profile"
            let rootRef = FIRDatabase.database().reference()
            let userRef = rootRef.child(path1)
            let profRef  = userRef.child(path2)
            userRef.observeSingleEventOfType(.Value, withBlock: { (data) in

                profRef.observeSingleEventOfType(.Value, withBlock: { (data2) in

                    var user = User()
                    user.id = data.childSnapshotForPath("id").value as! String
                    user.firstName = data.childSnapshotForPath("firstname").value as! String
                    user.lastName = data.childSnapshotForPath("lastname").value as! String

                    var profile = Profile()
                    profile.userId = user.id

                    if data2.hasChild("posts_count") {
                        profile.postsCount = (data2.childSnapshotForPath("posts_count").value as! NSNumber).longLongValue
                    }

                    if data2.hasChild("followers_count") {
                        profile.followersCount = (data2.childSnapshotForPath("followers_count").value as! NSNumber).longLongValue
                    }

                    if data2.hasChild("following_count") {
                        profile.followingCount = (data2.childSnapshotForPath("following_count").value as! NSNumber).longLongValue
                    }

                    var result = UserServiceProfileResult()
                    result.user = user
                    result.profile = profile
                    callback(result, nil)
                })
            })
        }
    }

    private func isOK() -> NSError? {
        if session.isValid() {
            return nil
        } else {
            return NSError(domain: "UserAPIFirebase", code: 0, userInfo: ["message": "No authenticated user."])
        }
    }

    private func fetchFollowList(path: String!, userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let path1 = "users"
            let path2 = "users/\(userId)/\(path)"
            let rootRef = FIRDatabase.database().reference()
            let userRef = rootRef.child(path1)
            let followerRef = rootRef.child(path2)

            followerRef.observeSingleEventOfType(.Value, withBlock: { (data) in

                var userList = [User]()

                if !data.exists() {
                    callback(userList, nil)
                } else {
                    for child in data.children {
                        userRef.child(child.key).observeSingleEventOfType(.Value, withBlock: { (data2) in

                            var user = User()
                            user.id = data2.childSnapshotForPath("id").value as! String
                            user.firstName = data2.childSnapshotForPath("firstname").value as! String
                            user.lastName = data2.childSnapshotForPath("lastname").value as! String

                            userList.append(user)

                            if UInt(userList.count) == data.childrenCount {
                                callback(userList, nil)
                            }
                        })
                    }
                }
            })
        }
    }
}
