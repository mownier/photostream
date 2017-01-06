//
//  Profile.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Firebase

struct Profile {

    var userId: String
    var bio: String
    var postsCount: Int
    var followersCount: Int
    var followingCount: Int

    init() {
        userId = ""
        bio = ""
        postsCount = 0
        followersCount = 0
        followingCount = 0
    }
}

extension Profile: SnapshotParser {
    
    init(with snapshot: FIRDataSnapshot, exception: String...) {
        self.init()
            
        if snapshot.hasChild("post_count") && !exception.contains("post_count") {
            postsCount = snapshot.childSnapshot(forPath: "post_count").value as! Int
        }
        
        if snapshot.hasChild("follower_count") && !exception.contains("follower_count") {
            followersCount = snapshot.childSnapshot(forPath: "follower_count").value as! Int
        }
        
        if snapshot.hasChild("following_count") && !exception.contains("following_count") {
            followingCount = snapshot.childSnapshot(forPath: "following_count").value as! Int
        }
        
        if snapshot.hasChild("bio") && !exception.contains("bio") {
            bio = snapshot.childSnapshot(forPath: "bio").value as! String
        }
    }
}
