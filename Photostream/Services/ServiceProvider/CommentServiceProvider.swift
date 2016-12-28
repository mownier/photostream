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
                            
                            let sorted = comments.sorted(by: { comment1, comment2 -> Bool in
                                return comment1.timestamp > comment2.timestamp
                            })
                            
                            var commentList = CommentList()
                            commentList.comments = sorted
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
        
        let uid = session.user.id

        let rootRef = FIRDatabase.database().reference()
        
        let key = rootRef.child("comments").childByAutoId().key
        
        let path1 = "comments/\(key)"
        let path2 = "post-comment/\(postId)/\(path1)"
        let path3 = "user-comment/\(uid)/\(path1)"
        let path4 = "posts/\(postId)/comments_count"
        let path5 = "posts/\(postId)/uid"
        let path6 = "users/\(uid)"
        
        let commentCountRef = rootRef.child(path4)
        let authorRef = rootRef.child(path5)
        let userRef = rootRef.child(path6)
        let commentRef = rootRef.child(path1)
        
        authorRef.observeSingleEvent(of: .value, with: { authorSnapshot in
            guard let authorId = authorSnapshot.value as? String else {
                result.error = .failedToWrite(message: "Author not found")
                callback?(result)
                return
            }
            
            commentCountRef.runTransactionBlock({ (data) -> FIRTransactionResult in
                if let val = data.value as? Int {
                    data.value = val + 1
                } else {
                    data.value = 1
                }
                return FIRTransactionResult.success(withValue: data)
                
            }) { (error, committed, snapshot) in
                guard error == nil, committed else {
                    result.error = .failedToWrite(message: "Unable to write a comment")
                    callback?(result)
                    return
                }
                
                let commentUpdate: [AnyHashable: Any] = [
                    "id": key,
                    "uid": uid,
                    "pid": postId,
                    "message": message,
                    "timestamp": FIRServerValue.timestamp()
                ]
                
                var updates: [AnyHashable: Any] = [
                    path1: commentUpdate,
                    path2: true,
                    path3: true
                ]
                
                if authorId != uid {
                    let activitiesRef = rootRef.child("activities")
                    let activityKey = activitiesRef.childByAutoId().key
                    let activityUpdate: [AnyHashable: Any] = [
                        "id": activityKey,
                        "type": "comment",
                        "trigger_by": uid,
                        "post_id": postId,
                        "comment_id": key,
                        "timestamp": FIRServerValue.timestamp()
                    ]
                    updates["activities/\(activityKey)"] = activityUpdate
                    updates["user-activity/\(authorId)/activities/\(activityKey)"] = true
                    updates["user-activity/\(authorId)/activity-comment/\(postId)/\(uid)/\(activityKey)"] = true
                }
                
                rootRef.updateChildValues(updates, withCompletionBlock: { error, ref in
                    guard error == nil else {
                        result.error = .failedToWrite(message: "Failed to write comment")
                        callback?(result)
                        return
                    }
                    
                    commentRef.observeSingleEvent(of: .value, with: { (commentSnapshot) in
                        userRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                            let user = User(with: userSnapshot, exception: "email")
                            let comment = Comment(with: commentSnapshot)
                            
                            let comments = [comment]
                            let users = [uid: user]
                            
                            var resultList = CommentList()
                            resultList.comments = comments
                            resultList.users = users
                            
                            result.comments = resultList
                            callback?(result)
                        })
                    })
                })
            }
        })
    }
}
