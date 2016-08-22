//
//  NewsFeedDisplayItemParser.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class NewsFeedDisplayItemParser: NewsFeedDisplayItemSerializer {

    func serialize(data: NewsFeedDataCollection) -> NewsFeedDisplayItemCollection {
        var collection = NewsFeedDisplayItemCollection()
        for i in 0..<data.count {
            if let (post, user) = data[i] {
                let item = serialize(post, user: user)
                collection.append(item)
            }
        }
        return collection
    }
    
    func serialize(post: NewsFeedPostData, user: NewsFeedUserData) -> NewsFeedDisplayItem {
        var item = NewsFeedDisplayItem()
        
        item.postId = post.postId
        item.userId = user.userId
        
        item.cellItem.displayName = user.displayName
        item.cellItem.isLiked = post.isLiked
        item.cellItem.timestamp = NSDate(timeIntervalSince1970: post.timestamp)
        item.cellItem.message = post.message
        item.cellItem.photoUrl = post.photoUrl
        item.cellItem.photoWidth = post.photoWidth
        item.cellItem.photoHeight = post.photoHeight
        
        if post.commentsCount > 0 {
            if post.commentsCount == 1 {
                item.cellItem.comments = "View 1 comment"
            } else {
                if post.commentsCount > 3 {
                    item.cellItem.comments = "View \(post.commentsCount) comments"
                } else {
                    item.cellItem.comments = "View all \(post.commentsCount) comments"
                }
            }
        }
        
        if post.likesCount > 0 {
            if post.likesCount == 1 {
                item.cellItem.likes = "1 like"
            } else {
                item.cellItem.likes = "\(post.likesCount) likes"
            }
        }
        
        item.headerItem.avatarUrl = user.avatarUrl
        item.headerItem.displayName = user.displayName
        
        return item
    }
}
