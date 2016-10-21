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

class PostServiceProvider: PostService {

    var session: AuthSession!

    required init(session: AuthSession!) {
        self.session = session
    }

    func fetchNewsFeed(_ offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let userId = session.user.id
            fetch("feed", userId: userId, offset: offset, limit: limit, callback: callback)
        }
    }

    func fetchPosts(_ userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            fetch("posts", userId: userId, offset: offset, limit: limit, callback: callback)
        }
    }

    func writePost(_ imageUrl: String!, callback: PostServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let userId = session.user.id
            let ref = FIRDatabase.database().reference()
            let key = ref.child("posts").childByAutoId().key
            let data: [String: AnyObject] = [
                "id": key as AnyObject,
                "uid": userId as AnyObject,
                "imageUrl": imageUrl as AnyObject,
                "timestamp": FIRServerValue.timestamp() as AnyObject
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

                }, andCompletionBlock: { (error, result, snap) in

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

                            var result = PostServiceResult()
                            result.posts = posts
                            result.users = users

                            callback(result, nil)

                        })
                    })
            })
        }
    }

    func like(_ postId: String!, callback: PostServiceLikeCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let userId = session.user.id
            let path1 = "posts/\(postId)/likes_count"
            let path2 = "posts/\(postId)/likes/\(userId)"
            let rootRef = FIRDatabase.database().reference()

            rootRef.child(path2).observeSingleEvent(of: .value, with: { (data) in

                if data.exists() {
                    callback(false, NSError(domain: "PostServiceProvider", code: 0, userInfo: ["message": "Already liked."]))
                } else {
                    rootRef.child(path1).runTransactionBlock({ (data2) -> FIRTransactionResult in

                        if let val = data2.value as? Int {
                            data2.value = val + 1
                        } else {
                            data2.value = 1
                        }

                        return FIRTransactionResult.success(withValue: data2)

                        }, andCompletionBlock: { (error, committed, snap) in

                            if !committed {
                                callback(false, error as? NSError)
                            } else {
                                rootRef.child(path2).setValue(true)
                                callback(true, nil)
                            }
                    })
                }
            })
        }
    }

    func unlike(_ postId: String!, callback: PostServiceLikeCallback!) {
        if let error = isOK() {
            callback(false, error)
        } else {
            let userId = session.user.id
            let path1 = "posts/\(postId)/likes_count"
            let path2 = "posts/\(postId)/likes/\(userId)"
            let rootRef = FIRDatabase.database().reference()

            rootRef.child(path2).observeSingleEvent(of: .value, with: { (data) in

                if !data.exists() {
                    callback(false, NSError(domain: "PostServiceProvider", code: 0, userInfo: ["message": "Failed to unlike post."]))
                } else {
                    rootRef.child(path1).runTransactionBlock({ (data) -> FIRTransactionResult in

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
                                rootRef.child(path2).removeValue()
                                callback(true, nil)
                            }
                    })
                }
            })
        }
    }

    func fetchLikes(_ postId: String, offset: UInt!, limit: UInt!, callback: PostServiceLikeListCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let path1 = "posts/\(postId)/likes"
            let path2 = "users"
            let rootRef = FIRDatabase.database().reference()
            rootRef.child(path1).queryLimited(toFirst: limit).observeSingleEvent(of: .value, with: { (data) in

                var likeList = [User]()
                if !data.exists() {
                    callback(likeList, nil)
                } else {
                    for c in data.children {
                        let child = c as! FIRDataSnapshot
                        rootRef.child("\(path2)/\(child.key)").observeSingleEvent(of: .value, with: { (data2) in

                            var user = User()
                            user.id = data2.childSnapshot(forPath: "id").value as! String
                            user.firstName = data2.childSnapshot(forPath: "firstname").value as! String
                            user.lastName = data2.childSnapshot(forPath: "lastname").value as! String

                            likeList.append(user)

                            if UInt(likeList.count) == data.childrenCount {
                                callback(likeList, nil)
                            }
                        })
                    }
                }
            })
        }
    }

    fileprivate func isOK() -> NSError? {
        if session.isValid() {
            return nil
        } else {
            return NSError(domain: "PostServiceProvider", code: 0, userInfo: ["message": "Unauthorized."])
        }
    }

    fileprivate func fetch(_ path: String, userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!) {
        let root = FIRDatabase.database().reference()
        let users = root.child("users")
        let posts = root.child("posts")
        let photos = root.child("photos")
        let ref = users.child(userId).child(path)
        let uid = session!.user.id
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
                                result.posts = postList
                                result.users = postUsers
                                callback(result, nil)
                            }
                        })
                    })
                })
            }
        })
    }
}
