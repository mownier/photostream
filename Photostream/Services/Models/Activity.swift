//
//  Activity.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Firebase

enum ActivityType {
    
    case unknown
    case like(String, String) // user id, post id
    case comment(String, String, String) // user id, comment id, post id
    case post(String, String) // user id, post id
    case follow(String) // user id
}

struct Activity {

    var id: String = ""
    var timestamp: Double = 0
    var type: ActivityType = .unknown
}

struct ActivityList {
    
    var activities = [Activity]()
    var posts = [String: Post]()
    var users = [String: User]()
    var comments = [String: Comment]()
    var following = [String]()
    
    var count: Int {
        return activities.count
    }
}

extension Activity: SnapshotParser {
    
    init(with snapshot: FIRDataSnapshot, exception: String...) {
        self.init()
        
        var userId = ""
        var postId = ""
        var commentId = ""
        
        if snapshot.hasChild("id") && !exception.contains("id") {
            id = snapshot.childSnapshot(forPath: "id").value as! String
        }
        
        if snapshot.hasChild("timestamp") && !exception.contains("timestamp") {
            timestamp = snapshot.childSnapshot(forPath: "timestamp").value as! Double
            timestamp = timestamp / 1000
        }
        
        if snapshot.hasChild("trigger_by") && !exception.contains("trigger_by") {
            userId = snapshot.childSnapshot(forPath: "trigger_by").value as! String
        }
        
        if snapshot.hasChild("post_id") && !exception.contains("post_id") {
            postId = snapshot.childSnapshot(forPath: "post_id").value as! String
        }
        
        if snapshot.hasChild("comment_id") && !exception.contains("comment_id") {
            commentId = snapshot.childSnapshot(forPath: "comment_id").value as! String
        }
        
        if snapshot.hasChild("type") && !exception.contains("type") {
            let typeString = snapshot.childSnapshot(forPath: "type").value as! String
            
            switch typeString.lowercased() {
            case "like" where !userId.isEmpty && !postId.isEmpty:
                type = .like(userId, postId)
                
            case "comment" where !userId.isEmpty && !commentId.isEmpty && !postId.isEmpty:
                type = .comment(userId, commentId, postId)
                
            case "post" where !userId.isEmpty && !postId.isEmpty:
                type = .post(userId, postId)
                
            case "follow" where !userId.isEmpty:
                type = .follow(userId)
                
            default:
                break
            }
        }
    }
}
