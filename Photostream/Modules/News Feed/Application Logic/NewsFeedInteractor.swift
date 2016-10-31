//
//  NewsFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct NewsFeedInteractor: NewsFeedInteractorInterface {
    
    typealias Offset = UInt
    
    var output: NewsFeedInteractorOutput?
    var service: NewsFeedService!
    var offset: Offset

    init(service: NewsFeedService) {
        self.service = service
        self.offset = 0
    }

    fileprivate mutating func fetch(limit: UInt) {
        guard var output = output else {
            return
        }
        let this = self
        service.fetchNewsFeed(offset: offset, limit: limit) { (result) in
            guard result.error != nil else {
                output.newsFeedDidFetchWithError(error: result.error!)
                return
            }
            
            let data = this.parseNewsFeedData(result.posts)
            if this.offset == 0 {
                output.newsFeedDidRefresh(data: data)
            } else {
                output.newsFeedDidLoadMore(data: data)
            }
        }
    }

    fileprivate func parseNewsFeedData(_ posts: PostList?) -> NewsFeedDataCollection {
        guard posts != nil else {
            return NewsFeedDataCollection()
        }
        
        var data = NewsFeedDataCollection()
        for i in 0..<posts!.count {
            if let (post, user) = posts![i] {
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

extension NewsFeedInteractor: NewsFeedInteractorInput {
    
    mutating func fetchNew(limit: UInt) {
        offset = 0
        fetch(limit: limit)
    }
    
    mutating func fetchNext(limit: UInt) {
        offset = offset + UInt(1)
        fetch(limit: limit)
    }
    
    func likePost(id: String) {
        
    }
    
    func unlikePost(id: String) {
        
    }
}

