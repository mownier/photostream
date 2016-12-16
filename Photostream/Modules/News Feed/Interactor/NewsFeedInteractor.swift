//
//  NewsFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol NewsFeedInteractorInput: BaseModuleInteractorInput {
    
    func fetchNew(with limit: UInt)
    func fetchNext(with limit: UInt)
    func like(post id: String)
    func unlike(post id: String)
}

protocol NewsFeedInteractorOutput: BaseModuleInteractorOutput {
    
    func newsFeedDidRefresh(data: NewsFeedData)
    func newsFeedDidLoadMore(data: NewsFeedData)
    func newsFeedDidRefresh(error: NewsFeedServiceError)
    func newsFeedDidLoadMore(error: NewsFeedServiceError)
    
    func newsFeedDidLike(with postId: String, and error: PostServiceError?)
    func newsFeedDidUnlike(with postId: String, and error: PostServiceError?)
}

protocol NewsFeedInteractorInterface: BaseModuleInteractor {
    
    var offset: String? { set get }
    var feedService: NewsFeedService! { set get }
    var postService: PostService! { set get }
    
    init(feedService: NewsFeedService, postService: PostService)
}

class NewsFeedInteractor: NewsFeedInteractorInterface {
    
    typealias Output = NewsFeedInteractorOutput
    
    weak var output: Output?
    
    var feedService: NewsFeedService!
    var postService: PostService!
    var offset: String?
    
    fileprivate var isFetching: Bool = false

    required init(feedService: NewsFeedService, postService: PostService) {
        self.feedService = feedService
        self.postService = postService
    }

    fileprivate func fetch(with limit: UInt) {
        guard output != nil && offset != nil && !isFetching else {
            return
        }
        
        isFetching = true
        feedService.fetchNewsFeed(offset: offset!, limit: limit) { (result) in
            self.isFetching = false
            
            guard result.error == nil else {
                if self.offset!.isEmpty {
                    self.output?.newsFeedDidRefresh(error: result.error!)
                } else {
                    self.output?.newsFeedDidLoadMore(error: result.error!)
                }
                return
            }
            
            let data = self.parseData(with: result.posts)
            if self.offset!.isEmpty {
                self.output?.newsFeedDidRefresh(data: data)
            } else {
                self.output?.newsFeedDidLoadMore(data: data)
            }
            
            self.offset = result.nextOffset as? String
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
                item.timestamp = post.timestamp
                
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
        offset = ""
        fetch(with: limit)
    }
    
    func fetchNext(with limit: UInt) {
        fetch(with: limit)
    }
    
    func like(post id: String) {
        guard output != nil else {
            return
        }
        
        postService.like(id: id) { (error) in
            self.output?.newsFeedDidLike(with: id, and: error)
        }
    }
    
    func unlike(post id: String) {
        guard output != nil else {
            return
        }
        
        postService.unlike(id: id) { (error) in
            self.output?.newsFeedDidUnlike(with: id, and: error)
        }
    }
}

