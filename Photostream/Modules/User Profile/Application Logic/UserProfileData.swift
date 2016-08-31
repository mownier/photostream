//
//  UserProfileData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct UserProfileData {

    var userId: String
    var fullName: String
    var username: String
    var avatarUrl: String
    var postsCount: Int
    var followersCount: Int
    var followingCount: Int
    var bio: String

    init() {
        userId = ""
        fullName = ""
        username = ""
        avatarUrl = ""
        bio = ""
        postsCount = 0
        followersCount = 0
        followingCount = 0
    }
}
