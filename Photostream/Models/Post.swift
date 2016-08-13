//
//  Post.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct Post {

    var id: String!
    var userId: String!
    var image: String!
    var timestamp: Double!
    var likesCount: Int64!
    var isLiked: Bool!
    
    init() {
        likesCount = 0
        isLiked = false
    }
}
