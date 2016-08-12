//
//  Profile.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct Profile {

    var userId: String!
    var postsCount: Int64!
    var followersCount: Int64!
    var followingCount: Int64!

    init() {
        postsCount = 0
        followersCount = 0
        followingCount = 0
    }
}
