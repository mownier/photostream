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
                comments.child((snap as AnyObject).key).observeSingleEvent(of: .value, with: { (commentSnapshot) in
                    guard let userId = commentSnapshot.childSnapshot(forPath: "uid").value as? String else {
                        return
                    }
                    
                    users.child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
                        if commentUsers[userId] == nil {
                            let user = User(with: userSnapshot, exception: "email")
                            commentUsers[user.id] = user
                        }
                        
                        let comment = Comment(with: commentSnapshot)
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
        ref.child(path1).observeSingleEvent(of: .value, with: { (commentSnapshot) in
            ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (userSnapshot) in
                let user = User(with: userSnapshot, exception: "email")
                let comment = Comment(with: commentSnapshot)
                
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
