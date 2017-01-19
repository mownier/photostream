//
//  LikedPostInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol LikedPostInteractorInput: BaseModuleInteractorInput {
    
    func fetchNew(userId: String, limit: UInt)
    func fetchNext(userId: String, limit: UInt)
    
    func likePost(id: String)
    func unlikePost(id: String)
}

protocol LikedPostInteractorOutput: BaseModuleInteractorOutput {
    
    func didRefresh(data: [LikedPostData])
    func didLoadMore(data: [LikedPostData])
    
    func didRefresh(error: PostServiceError)
    func didLoadMore(error: PostServiceError)
    
    func didLike(error: PostServiceError?, postId: String)
    func didUnlike(error: PostServiceError?, postId: String)
}

protocol LikedPostInteractorInterface: BaseModuleInteractor {
    
    var service: PostService! { set get }
    var offset: String? { set get }
    var isFetching: Bool { set get }
    
    init(service: PostService)
    
    func fetchPosts(userId: String, limit: UInt)
}

class LikedPostInteractor: LikedPostInteractorInterface {

    typealias Output = LikedPostInteractorOutput
    
    weak var output: Output?
    var service: PostService!
    var offset: String?
    var isFetching: Bool = false
    
    required init(service: PostService) {
        self.service = service
    }
    
    func fetchPosts(userId: String, limit: UInt) {
        guard output != nil, offset != nil, !isFetching else {
            return
        }
        
        isFetching = true
        
        service.fetchLikedPosts(userId: userId, offset: offset!, limit: limit) {
            [weak self] result in
            
            self?.didFetch(result: result)
        }
    }
    
    private func didFetch(result: PostServiceResult) {
        isFetching = false
        
        guard result.error == nil else {
            didFetch(error: result.error!)
            return
        }
        
        guard let list = result.posts, list.count > 0 else {
            didFetch(data: [LikedPostData]())
            return
        }
        
        var posts = [LikedPostData]()
        
        for post in list.posts {
            guard let user = list.users[post.userId] else {
                continue
            }
            
            var item = LikedPostDataItem()
            
            item.id = post.id
            item.message = post.message
            item.timestamp = post.timestamp
            
            item.photoUrl = post.photo.url
            item.photoWidth = post.photo.width
            item.photoHeight = post.photo.height
            
            item.likes = post.likesCount
            item.comments = post.commentsCount
            item.isLiked = post.isLiked
            
            item.userId = user.id
            item.avatarUrl = user.avatarUrl
            item.displayName = user.displayName
            
            posts.append(item)
        }
        
        didFetch(data: posts)

        offset = result.nextOffset
    }
    
    private func didFetch(data: [LikedPostData]) {
        if offset != nil, offset!.isEmpty {
            output?.didRefresh(data: data)
            
        } else {
            output?.didLoadMore(data: data)
        }
    }
    
    private func didFetch(error: PostServiceError) {
        if offset != nil, offset!.isEmpty {
            output?.didRefresh(error: error)
            
        } else {
            output?.didLoadMore(error: error)
        }
    }
}

extension LikedPostInteractor: LikedPostInteractorInput {
    
    func fetchNew(userId: String, limit: UInt) {
        offset = ""
        fetchPosts(userId: userId, limit: limit)
    }
    
    func fetchNext(userId: String, limit: UInt) {
        fetchPosts(userId: userId, limit: limit)
    }
    
    func likePost(id: String) {
        guard output != nil else {
            return
        }
        
        service.like(id: id) { error in
            self.output?.didLike(error: error, postId: id)
        }
    }
    
    func unlikePost(id: String) {
        guard output != nil else {
            return
        }
        
        service.unlike(id: id) { error in
            self.output?.didUnlike(error: error, postId: id)
        }
    }
}
