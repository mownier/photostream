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

struct CommentServiceProvider: CommentService {

    var session: AuthSession

    init(session: AuthSession) {
        self.session = session
    }
    
    func fetchComments(postId: String, offset: UInt, limit: UInt, callback: ((CommentServiceResult) -> Void)?) {
        var result = CommentServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            return
        }
        
        let root = FIRDatabase.database().reference()
        let comments = root.child("comments")
        let postComment = root.child("post-comment")
        let users = root.child("users")
        let ref = postComment.child(postId).child("comments")
        
        ref.queryLimited(toFirst: limit).observeSingleEvent(of: .value, with: { (data) in
            guard data.hasChildren() else {
                callback?(result)
                return
            }
            
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
                        comment.timestamp = (data2.childSnapshot(forPath: "timestamp").value as! Double) / 1000
                        
                        commentList.append(comment)
                        
                        if UInt(commentList.count) == data.childrenCount {
                            var resultList = CommentList()
                            resultList.comments  = commentList
                            resultList.users = commentUsers
                            result.comments = resultList
                            callback?(result)
                        }
                    })
                })
            }
        })
    }

    func writeComment(postId: String, message: String, callback: ((CommentServiceResult) -> Void)?) {
        var result = CommentServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        let userId = session.user.id
        let ref = FIRDatabase.database().reference()
        let key = ref.child("comments").childByAutoId().key
        let path1 = "comments/\(key)"
        let path2 = "post-comment/\(postId)/\(path1)"
        let path3 = "user-comment/\(userId)/\(path1)"
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
                
                var resultList = CommentList()
                resultList.comments = comments
                resultList.users = users
                
                result.comments = resultList
                callback?(result)
            })
        })
    }
}
