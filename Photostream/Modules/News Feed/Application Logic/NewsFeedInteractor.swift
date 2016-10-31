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

    fileprivate func parseNewsFeedData(_ posts: PostList?) -> NewsFeedData {
        guard posts != nil else {
            return NewsFeedData()
        }
        
        var data = NewsFeedData()
        for i in 0..<posts!.count {
            if let (post, user) = posts![i] {
                var item = NewsFeedPost()
                
                item.id = post.id
                item.message = post.message
                item.timestamp = post.timestamp / 1000
                
                item.likes = post.likesCount
                item.comments = post.commentsCount
                item.isLiked = post.isLiked

                item.photoUrl = post.photo.url
                item.photoWidth = post.photo.width
                item.photoHeight  = post.photo.height

                item.userId = user.id
                item.avatarUrl = user.avatarUrl
                item.displayName = user.displayName

                data.items.append(item)
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

