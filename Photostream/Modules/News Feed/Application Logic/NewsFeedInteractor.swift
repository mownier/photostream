//
//  NewsFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedInteractor: NewsFeedInteractorInput {

    var output: NewsFeedInteractorOutput!
    var service: PostService!
    var currentOffset: UInt!

    init(service: PostService!) {
        self.service = service
        self.currentOffset = 0
    }

    func fetchNew(limit: UInt!) {
        currentOffset = 0
        fetch(currentOffset, limit: limit)
    }

    func fetchNext(limit: UInt!) {
        currentOffset = currentOffset + UInt(1)
        fetch(currentOffset, limit: limit)
    }

    private func fetch(offset: UInt!, limit: UInt!) {
        service.fetchNewsFeed(currentOffset, limit: limit) { (feed, error) in
            if let error = error {
                self.output.newsFeedDidFetchWithError(error)
            } else {
                let data = self.parseNewsFeedData(feed)
                self.output.newsFeedDidFetchOk(data)
            }
        }
    }
    
    private func parseNewsFeedData(feed: PostServiceResult!) -> NewsFeedDataCollection {
        var data = NewsFeedDataCollection()
        
        for i in 0..<feed.count {
            if let (post, user) = feed[i] {
                var postItem = NewsFeedPostData()
                postItem.message = post.message
                postItem.postId = post.id
                postItem.commentsCount = post.commentsCount
                postItem.likesCount = post.likesCount
                postItem.isLiked = post.isLiked
                postItem.timestamp = post.timestamp / 1000
                postItem.userId = user.id
                postItem.photoUrl = post.photo.url
                postItem.photoWidth = post.photo.width
                postItem.photoHeight  = post.photo.height
                
                var userItem = NewsFeedUserData()
                userItem.userId = user.id
                userItem.avatarUrl = user.avatarUrl
                userItem.displayName = user.displayName
                
                data.add(postItem, userItem: userItem)
            }
        }
        
        return data
    }
}
