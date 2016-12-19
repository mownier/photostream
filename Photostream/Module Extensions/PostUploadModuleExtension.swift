//
//  PostUploadModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

extension UploadedPost {
    
    func covertToNewsFeedPost() -> NewsFeedPost {
        var post = NewsFeedPost()
        
        post.id = id
        post.message = message
        post.timestamp = timestamp
        
        post.photoUrl = photoUrl
        post.photoWidth = photoWidth
        post.photoHeight = photoHeight
        
        post.likes = likes
        post.comments = comments
        post.isLiked = isLiked
        
        post.userId = userId
        post.avatarUrl = avatarUrl
        post.displayName = displayName
        
        return post
    }
}
