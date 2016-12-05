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
    
    func fetchComments(postId: String, offset: String, limit: UInt, callback: ((CommentServiceResult) -> Void)?) {
        var result = CommentServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            return
        }
        
        let root = FIRDatabase.database().reference()
        let commentsRef = root.child("comments")
        let postCommentRef = root.child("post-comment")
        let usersRef = root.child("users")
        var query = postCommentRef.child(postId).child("comments").queryOrderedByKey()
        
        if !offset.isEmpty {
            query = query.queryEnding(atValue: offset)
        }
        
        query = query.queryLimited(toLast: limit + 1)
        query.observeSingleEvent(of: .value, with: { (data) in
            guard data.hasChildren() else {
                callback?(result)
                return
            }
            
            var comments = [Comment]()
            var users = [String: User]()
            for snap in data.children {
                commentsRef.child((snap as AnyObject).key).observeSingleEvent(of: .value, with: { (commentSnapshot) in
                    guard let userId = commentSnapshot.childSnapshot(forPath: "uid").value as? String else {
                        return
                    }
                    
                    usersRef.child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
                        if users[userId] == nil {
                            let user = User(with: userSnapshot, exception: "email")
                            users[user.id] = user
                        }
                        
                        let comment = Comment(with: commentSnapshot)
                        comments.append(comment)
                        
                        let commentCount = UInt(comments.count)
                        if commentCount == data.childrenCount {
                            if commentCount == limit + 1 {
                                let removedComment = comments.removeFirst()
                                result.nextOffset = removedComment.id
                            }
                            
                            var commentList = CommentList()
                            commentList.comments = comments.reversed()
                            commentList.users = users
                            result.comments = commentList
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
