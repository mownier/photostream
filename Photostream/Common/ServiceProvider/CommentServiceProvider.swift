//
//  CommentServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class CommentServiceProvider: CommentService {

    var session: AuthSession!

    required init(session: AuthSession!) {
        self.session = session
    }

    func fetchComments(_ postId: String!, offset: UInt!, limit: UInt!, callback: CommentServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let root = FIRDatabase.database().reference()
            let comments = root.child("comments")
            let posts = root.child("posts")
            let users = root.child("users")
            let ref = posts.child(postId).child("comments")
            ref.queryLimited(toFirst: limit).observeSingleEvent(of: .value, with: { (data) in
                var commentList = [Comment]()
                var commentUsers = [String: User]()
                for snap in data.children {
                    comments.child((snap as AnyObject).key).observeSingleEvent(of: .value, with: { (data2) in
                        let userId = data2.childSnapshot(forPath: "uid").value as! String
                        users.child(userId).observeSingleEvent(of: .value, with: { (data3) in
                            if commentUsers[userId] == nil {
                                var user = User()
                                user.id = userId
                                user.firstName = data3.childSnapshot(forPath: "firstname").value as! String
                                user.lastName = data3.childSnapshot(forPath: "lastname").value as! String
                                commentUsers[userId] = user
                            }

                            var comment = Comment()
                            comment.userId = userId
                            comment.id = data2.childSnapshot(forPath: "id").value as! String
                            comment.message = data2.childSnapshot(forPath: "message").value as! String
                            comment.timestamp = data2.childSnapshot(forPath: "timestamp").value as! Double

                            commentList.append(comment)

                            if UInt(commentList.count) == data.childrenCount {
                                var result = CommentServiceResult()
                                result.comments  = commentList
                                result.users = commentUsers
                                callback(result, nil)
                            }
                        })
                    })
                }
            })
        }
    }

    func writeComment(_ postId: String!, message: String!, callback: CommentServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let userId = session.user.id
            let ref = FIRDatabase.database().reference()
            let key = ref.child("comments").childByAutoId().key
            let path1 = "comments/\(key)"
            let path2 = "posts/\(postId)/\(path1)"
            let path3 = "users/\(userId)/\(path1)"
            let data = [
                "id": key,
                "uid": userId,
                "pid": postId,
                "message": message,
                "timestamp": FIRServerValue.timestamp()
            ] as [String : Any]
            let updates: [String: AnyObject] = [path1: data as AnyObject, path2: true as AnyObject, path3: true as AnyObject]

            ref.updateChildValues(updates)
            ref.child(path1).observeSingleEvent(of: .value, with: { (data) in
                ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (data2) in
                    var user = User()
                    user.id = userId
                    user.firstName = data2.childSnapshot(forPath: "firstname").value as! String
                    user.lastName = data2.childSnapshot(forPath: "lastname").value as! String

                    var comment = Comment()
                    comment.id = key
                    comment.message = message
                    comment.userId = userId
                    comment.timestamp = data.childSnapshot(forPath: "timestamp").value as! Double

                    var comments = [Comment]()
                    comments.append(comment)

                    var users = [String: User]()
                    users[userId] = user

                    var result = CommentServiceResult()
                    result.comments = comments
                    result.users = users

                    callback(result, nil)
                })
            })
        }
    }

    fileprivate func isOK() -> NSError? {
        if session.isValid() {
            return nil
        } else {
            return NSError(domain: "CommentServiceProvider", code: 0, userInfo: ["message": "No authenticated user."])
        }
    }
}
