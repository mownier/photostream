//
//  Comment.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Firebase

struct Comment {

    var id: String
    var message: String
    var timestamp: Double
    var userId: String

    init() {
        id = ""
        message = ""
        timestamp = 0
        userId = ""
    }
}

struct CommentList {
    
    var comments: [Comment]
    var users: [String: User]
    
    init() {
        comments = [Comment]()
        users = [String: User]()
    }
}

extension Comment: SnapshotParser {
    
    init(with snapshot: FIRDataSnapshot, exception: String...) {
        self.init()
        
        if snapshot.hasChild("id") && !exception.contains("id") {
            id = snapshot.childSnapshot(forPath: "id").value as! String
        }
        
        if snapshot.hasChild("message") && !exception.contains("message") {
            message = snapshot.childSnapshot(forPath: "message").value as! String
        }
        
        if snapshot.hasChild("timestamp") && !exception.contains("timestamp") {
            timestamp = snapshot.childSnapshot(forPath: "timestamp").value as! Double
            timestamp /= 1000
        }
        
        if snapshot.hasChild("uid") && !exception.contains("uid") {
            userId = snapshot.childSnapshot(forPath: "uid").value as! String
        }
    }
}
