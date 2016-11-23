//
//  UploadedPost.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct UploadedPost {

    var id: String = ""
    var message: String = ""
    var timestamp: Double = 0
    
    var photoUrl: String = ""
    var photoWidth: Int = 0
    var photoHeight: Int = 0
    
    var likes: Int = 0
    var comments: Int = 0
    var isLiked: Bool = false
    
    var userId: String = ""
    var avatarUrl: String = ""
    var displayName: String = ""
}
