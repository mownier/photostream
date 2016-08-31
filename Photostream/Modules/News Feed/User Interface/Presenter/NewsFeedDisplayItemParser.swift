//
//  NewsFeedDisplayItemParser.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedDisplayItemParser: PostCellItemSerializer {

    var post: NewsFeedPostData
    var user: NewsFeedUserData

    init(post: NewsFeedPostData, user: NewsFeedUserData) {
        self.post = post
        self.user = user
    }

    func serializeCellItem() -> PostCellItem {
        var item = PostCellItem()

        item.postId = post.postId
        item.userId = user.userId

        item.displayName = user.displayName
        item.isLiked = post.isLiked
        item.timestamp = NSDate(timeIntervalSince1970: post.timestamp)
        item.message = post.message
        item.photoUrl = post.photoUrl
        item.photoWidth = Float(post.photoWidth)
        item.photoHeight = Float(post.photoHeight)
        item.commentsCount = Int(post.commentsCount)
        item.likesCount = Int(post.likesCount)

        item.avatarUrl = user.avatarUrl
        item.displayName = user.displayName

        return item
    }
}
