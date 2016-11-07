//
//  SnapshotParsing.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import Firebase

func parseUser(with snapshot: FIRDataSnapshot, exception: String...) -> User {
    var user = User()
    
    if snapshot.hasChild("id") && !exception.contains("id") {
        user.id = snapshot.childSnapshot(forPath: "id").value as! String
    }
    
    if snapshot.hasChild("firstname") && !exception.contains("firstname") {
        user.firstName = snapshot.childSnapshot(forPath: "firstname").value as! String
    }
    
    if snapshot.hasChild("lastname") && !exception.contains("lastname") {
        user.lastName = snapshot.childSnapshot(forPath: "lastname").value as! String
    }
    
    if snapshot.hasChild("email") && !exception.contains("email") {
        user.email = snapshot.childSnapshot(forPath: "email").value as! String
    }
    
    if snapshot.hasChild("username") && !exception.contains("username") {
        user.username = snapshot.childSnapshot(forPath: "username").value as! String
    }
    
    return user
}

func parsePhoto(with snapshot: FIRDataSnapshot, exception: String...) -> Photo {
    var photo = Photo()
    
    if snapshot.hasChild("url") && !exception.contains("url") {
        photo.url = snapshot.childSnapshot(forPath: "url").value as! String
    }
    
    if snapshot.hasChild("width") && !exception.contains("width") {
        photo.width = snapshot.childSnapshot(forPath: "width").value as! Int
    }
    
    if snapshot.hasChild("height") && !exception.contains("height") {
        photo.height = snapshot.childSnapshot(forPath: "height").value as! Int
    }
    
    return photo
}

func parsePost(with snapshot: FIRDataSnapshot, exception: String...) -> Post {
    var post = Post()
    
    if snapshot.hasChild("id") && !exception.contains("id") {
        post.id = snapshot.childSnapshot(forPath: "id").value as! String
    }
    
    if snapshot.hasChild("uid") && !exception.contains("uid") {
        post.userId = snapshot.childSnapshot(forPath: "uid").value as! String
    }
    
    if snapshot.hasChild("timestamp") && !exception.contains("timestamp") {
        post.timestamp = snapshot.childSnapshot(forPath: "timestamp").value as! Double
    }
    
    if snapshot.hasChild("likes_count") && !exception.contains("likes_count") {
        post.likesCount = snapshot.childSnapshot(forPath: "likes_count").value as! Int
    }
    
    if snapshot.hasChild("comments_count") && !exception.contains("comments_count") {
        post.commentsCount = snapshot.childSnapshot(forPath: "comments_count").value as! Int
    }
    
    if snapshot.hasChild("message") && !exception.contains("message") {
        post.message = snapshot.childSnapshot(forPath: "message").value as! String
    }

    return post
}

