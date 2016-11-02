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
    
    func fetchNewsFeed(offset: UInt, limit: UInt, callback: ((NewsFeedServiceResult) -> Void)?) {
        var result = NewsFeedServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        // TODO: Implement fetching of news feed
        
        let root = FIRDatabase.database().reference()
        let users = root.child("users")
        let posts = root.child("posts")
        let photos = root.child("photos")
        let uid = session.user.id
        let ref = users.child(uid).child("feed")
        
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
                                var result = NewsFeedServiceResult()
                                var resultList = PostList()
                                resultList.posts = postList
                                resultList.users = postUsers
                                result.posts = resultList
                                callback?(result)
                            }
                        })
                    })
                })
            }
        })
    }
}
