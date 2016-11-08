//
//  Post.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import Firebase

struct Post {

    var id: String
    var userId: String
    var timestamp: Double
    var likesCount: Int
    var commentsCount: Int
    var isLiked: Bool
    var message: String
    var photo: Photo

    init() {
        id = ""
        userId = ""
        timestamp = 0
        message = ""
        commentsCount = 0
        likesCount = 0
        isLiked = false
        photo = Photo()
    }
}

extension Post: SnapshotParser {
    
    init(with snapshot: FIRDataSnapshot, exception: String...) {
        self.init()
        
        if snapshot.hasChild("id") && !exception.contains("id") {
            id = snapshot.childSnapshot(forPath: "id").value as! String
        }
        
        if snapshot.hasChild("uid") && !exception.contains("uid") {
            userId = snapshot.childSnapshot(forPath: "uid").value as! String
        }
        
        if snapshot.hasChild("timestamp") && !exception.contains("timestamp") {
            timestamp = snapshot.childSnapshot(forPath: "timestamp").value as! Double
            timestamp = timestamp / 1000
        }
        
        if snapshot.hasChild("likes_count") && !exception.contains("likes_count") {
            likesCount = snapshot.childSnapshot(forPath: "likes_count").value as! Int
        }
        
        if snapshot.hasChild("comments_count") && !exception.contains("comments_count") {
            commentsCount = snapshot.childSnapshot(forPath: "comments_count").value as! Int
        }
        
        if snapshot.hasChild("message") && !exception.contains("message") {
            message = snapshot.childSnapshot(forPath: "message").value as! String
        }
    }
}

struct PostList {
    
    var posts: [Post]
    var users: [String: User]
    var count: Int {
        return posts.count
    }
    
    init() {
        posts = [Post]()
        users = [String: User]()
    }
    
    subscript (index: Int) -> (Post, User)? {
        if posts.isValid(index) {
            let post = posts[index]
            if let user = users[post.userId] {
                return (post, user)
            }
        }
        return nil
    }
}
