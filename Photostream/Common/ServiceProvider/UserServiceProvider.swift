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

    var session: AuthSession!

    required init(session: AuthSession!) {
        self.session = session
    }

    func follow(_ userId: String!, callback: UserServiceFollowCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let user = session!.user
            let path1 = "users/\(user?.id)/profile/following_count"
            let path2 = "users/\(user?.id)/following/\(userId)"
            let path3 = "users/\(userId)/followers/\(user?.id)"
            let path4 = "users/\(userId)/profile/followers_count"
            let path5 = "users/\(user?.id)/feed"
            let path6 = "users/\(userId)/feed"

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

                            }, andCompletionBlock: { (error, committed, snap) in

                                if !committed {
                                    callback(false, error as? NSError)
                                } else {
                                    followerCountRef.runTransactionBlock({ (data4) -> FIRTransactionResult in

                                        if let val = data4.value as? Int , val > 0 {
                                            data4.value = val + 1
                                        } else {
                                            data4.value = 1
                                        }

                                        return FIRTransactionResult.success(withValue: data4)

                                        }, andCompletionBlock: { (error, committed, snap) in

                                            if !committed {
                                                callback(false, error as? NSError)
                                            } else {
                                                feed2Ref.observeSingleEvent(of: .value, with: { (data5) in

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
                    callback(false, NSError(domain: "UserServiceProvider", code: 0, userInfo: ["message": "Already followed."]))
                }
            })
        }
    }

    func unfollow(_ userId: String!, callback: UserServiceFollowCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let user = session!.user
            let path1 = "users/\(user?.id)/profile/following_count"
            let path2 = "users/\(user?.id)/following/\(userId)"
            let path3 = "users/\(userId)/followers/\(user?.id)"
            let path4 = "users/\(userId)/profile/followers_count"
            let path5 = "users/\(user?.id)/feed"
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

                if let val = data.value as? Int , val > 0 {
                    data.value = val - 1
                } else {
                    data.value = 0
                }

                return FIRTransactionResult.success(withValue: data)

                }, andCompletionBlock: { (error, committed, snap) in

                    if !committed {
                        callback(false, error as? NSError)
                    } else {
                        followerCountRef.runTransactionBlock({ (data2) -> FIRTransactionResult in

                            if let val = data2.value as? Int , val > 0 {
                                data2.value = val - 1
                            } else {
                                data2.value = 0
                            }

                            return FIRTransactionResult.success(withValue: data2)

                            }, andCompletionBlock: { (error, committed, snap) in

                                if !committed {
                                    callback(false, error as? NSError)
                                } else {
                                    feed2Ref.observeSingleEvent(of: .value, with: { (data3) in

                                        for child in data3.children {
                                            feed1Ref.child((child as AnyObject).key).removeValue()
                                        }
                                        callback(true, nil)
                                    })
                                }
                        })
                    }
            })
        }
    }

    func fetchFollowers(_ userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!) {
        fetchFollowList(path: "followers", userId: userId, offset: offset, limit: limit, callback: callback)
    }

    func fetchFollowing(_ userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!) {
        fetchFollowList(path: "following", userId: userId, offset: offset, limit: limit, callback: callback)
    }

    func fetchProfile(_ userId: String!, callback: @escaping UserServiceProfileCallback) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let path1 = "users/\(userId)/"
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
            return NSError(domain: "UserServiceProvider", code: 0, userInfo: ["message": "No authenticated user."])
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

            followerRef.observeSingleEvent(of: .value, with: { (data) in

                var userList = [User]()

                if !data.exists() {
                    callback(userList, nil)
                } else {
                    for child in data.children {
                        userRef.child((child as AnyObject).key).observeSingleEvent(of: .value, with: { (data2) in

                            var user = User()
                            user.id = data2.childSnapshot(forPath: "id").value as! String
                            user.firstName = data2.childSnapshot(forPath: "firstname").value as! String
                            user.lastName = data2.childSnapshot(forPath: "lastname").value as! String

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
