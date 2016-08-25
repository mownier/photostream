//
//  NewsFeedDisplayItemParser.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class NewsFeedDisplayItemParser: NewsFeedDisplayItemSerializer {

    func serialize(data: NewsFeedDataCollection) -> PostCellItemList {
        var list = PostCellItemList()
        for i in 0..<data.count {
            if let (post, user) = data[i] {
                let item = serialize(post, user: user)
                list.append(item)
            }
        }
        return list
    }

    func serialize(post: NewsFeedPostData, user: NewsFeedUserData) -> PostCellItem {
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
