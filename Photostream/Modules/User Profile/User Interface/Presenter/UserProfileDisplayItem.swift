//
//  UserProfileDisplayItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 27/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct UserProfileDisplayItem {

    var avatarUrl: String
    var postsCountText: String
    var followersCountText: String
    var followingCountText: String
    var displayName: String
    var username: String
    var bio: String
    
    init() {
        avatarUrl = ""
        postsCountText = ""
        followersCountText = ""
        followingCountText = ""
        displayName = ""
        username = ""
        bio = ""
    }
    
    func getBio() -> String {
        if !bio.isEmpty {
            return bio
        } else {
            return "Write your bio here..."
        }
    }
}
