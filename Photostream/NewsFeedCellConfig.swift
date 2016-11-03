//
//  NewsFeedCellConfig.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostListCell {

    func configure(for post: NewsFeedPost) {
        setMessage(with: post.message, and: post.displayName)
        setPhoto(with: post.photoUrl)
        elapsedTime = post.timeAgo
        
        shouldHighlightLikeButton(post.isLiked)
        likesCountText = post.likesText
        commentsCountText = post.commentsText
    }
}
