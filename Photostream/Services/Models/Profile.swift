//
//  Profile.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

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
