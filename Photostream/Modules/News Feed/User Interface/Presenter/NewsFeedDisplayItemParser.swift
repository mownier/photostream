//
//  NewsFeedDisplayItemParser.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedDisplayItemParser: PostCellItemSerializer {

    var post: NewsFeedPost

    init(post: NewsFeedPost) {
        self.post = post
    }

    func serializeCellItem() -> PostCellItem {
        var item = PostCellItem()

        item.postId = post.id
        item.userId = post.userId

        item.isLiked = post.isLiked
        item.timestamp = Date(timeIntervalSince1970: post.timestamp)
        item.message = post.message
        item.photoUrl = post.photoUrl
        item.photoWidth = Float(post.photoWidth)
        item.photoHeight = Float(post.photoHeight)
        item.commentsCount = Int(post.comments)
        item.likesCount = Int(post.likes)

        item.avatarUrl = post.avatarUrl
        item.displayName = post.displayName

        return item
    }
}
