//
//  NewsFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedInteractor: NewsFeedInteractorInterface {
    
    typealias Offset = UInt
    
    weak var output: NewsFeedInteractorOutput?
    var feedService: NewsFeedService!
    var postService: PostService!
    var offset: Offset

    required init(feedService: NewsFeedService, postService: PostService) {
        self.feedService = feedService
        self.postService = postService
        self.offset = 0
    }

    fileprivate func fetch(with limit: UInt) {
        guard output != nil else {
            return
        }
        
        feedService.fetchNewsFeed(offset: offset, limit: limit) { (result) in
            guard result.error == nil else {
                self.output?.newsFeedDidFetchWithError(error: result.error!)
                return
            }
            
            let data = self.parseData(with: result.posts)
            if self.offset == 0 {
                self.output?.newsFeedDidRefresh(data: data)
            } else {
                self.output?.newsFeedDidLoadMore(data: data)
            }
        }
    }

    fileprivate func parseData(with posts: PostList?) -> NewsFeedData {
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
    
    func fetchNew(with limit: UInt) {
        offset = 0
        fetch(with: limit)
    }
    
    func fetchNext(with limit: UInt) {
        offset = offset + UInt(1)
        fetch(with: limit)
    }
    
    func like(post id: String) {
        guard output != nil else {
            return
        }
        
        postService.like(id: id) { (error) in
            self.output?.newsFeedDidLike(with: error)
        }
    }
    
    func unlike(post id: String) {
        guard output != nil else {
            return
        }
        
        postService.unlike(id: id) { (error) in
            self.output?.newsFeedDidUnlike(with: error)
        }
    }
}

