//
//  NewsFeedServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct NewsFeedServiceProvider: NewsFeedService {
    
    var session: AuthSession
    
    init(session: AuthSession) {
        self.session = session
    }
    
    func fetchNewsFeed(offset: Any, limit: UInt, callback: ((NewsFeedServiceResult) -> Void)?) {
        var result = NewsFeedServiceResult()
        guard let offset = offset as? String,
            session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let rootRef = FIRDatabase.database().reference()
        let feedRef = rootRef.child("user-feed").child(uid)
        let postsRef = feedRef.child("posts")
        var query = postsRef.queryOrderedByKey()
        
        if !offset.isEmpty {
            query = query.queryStarting(atValue: offset)
        }
        
        query = query.queryLimited(toFirst: limit)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            var posts = [Post]()
            var users = [String: User]()
            
            for child in snapshot.children {
                guard let post = child as? FIRDataSnapshot else {
                    continue
                }
                
                let postKey = post.key
                let postRef = rootRef.child("posts").child(postKey)
                postRef.observeSingleEvent(of: .value, with: { (postSnapshot) in
                    guard let userId = postSnapshot.childSnapshot(forPath: "uid").value as? String,
                        let photoId = postSnapshot.childSnapshot(forPath: "photo_id").value as? String else {
                        return
                    }
                    
                    let userRef = rootRef.child("users").child(userId)
                    let photoRef = rootRef.child("photos").child(photoId)
                    let likesRef = rootRef.child("post-likes")
                    
                    userRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                        photoRef.observeSingleEvent(of: .value, with: { (photoSnapshot) in
                            likesRef.observeSingleEvent(of: .value, with: { (likesSnapshot) in
                                if users[userId] == nil {
                                    users[userId] = parseUser(with: userSnapshot, exception: "email")
                                }
                                
                                var post = parsePost(with: postSnapshot)
                                post.photo = parsePhoto(with: photoSnapshot)
                                
                                if likesSnapshot.hasChild("\(postKey)/likes/\(uid)") {
                                    post.isLiked = true
                                }
                                
                                posts.append(post)
                                
                                if UInt(posts.count) == snapshot.childrenCount {
                                    var result = NewsFeedServiceResult()
                                    var postList = PostList()
                                    postList.posts = posts
                                    postList.users = users
                                    result.posts = postList
                                    callback?(result)
                                }
                            })
                        })
                    })
                })
            }
        })
    }
}
