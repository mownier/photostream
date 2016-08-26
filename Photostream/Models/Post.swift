//
//  Post.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

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
