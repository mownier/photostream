//
//  PostLikeInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol PostLikeInteractorInput: BaseModuleInteractorInput {

    func fetchNew(postId: String, limit: UInt)
    func fetchNext(postId: String, limit: UInt)
    
    func follow(userId: String)
    func unfollow(userId: String)
}

protocol PostLikeInteractorOutput: BaseModuleInteractorOutput {
    
    func didFetchNew(data: [PostLikeData])
    func didFetchNext(data: [PostLikeData])
    
    func didFetchNew(error: PostServiceError)
    func didFetchNext(error: PostServiceError)
    
    func didFollow(error: UserServiceError?, userId: String)
    func didUnfollow(error: UserServiceError?, userId: String)
}

protocol PostLikeInteractorInterface: BaseModuleInteractor {
    
    var postService: PostService! { set get }
    var userService: UserService! { set get }
    var offset: String? { set get }
    var isFetching: Bool { set get }
    
    init(postService: PostService, userService: UserService)
    
    func fetch(postId: String, limit: UInt)
}

class PostLikeInteractor: PostLikeInteractorInterface {
    
    typealias Output = PostLikeInteractorOutput
    
    weak var output: Output?
    var postService: PostService!
    var userService: UserService!
    var offset: String?
    var isFetching: Bool = false
    
    required init(postService: PostService, userService: UserService) {
        self.postService = postService
        self.userService = userService
    }
    
    func fetch(postId: String, limit: UInt) {
        guard output != nil, offset != nil, !isFetching else {
            return
        }
        
        isFetching = true
        
        postService.fetchLikes(id: postId, offset: offset!, limit: limit, callback: {
            [weak self] result in
            
            self?.didFinishFetching(result: result)
        })
    }
    
    fileprivate func didFinishFetching(result: PostServiceLikeResult) {
        guard result.error == nil else {
            didFetch(error: result.error!)
            return
        }
        
        guard let likes = result.likes, likes.count > 0 else {
            didFetch(data: [PostLikeData](), nextOffset: result.nextOffset)
            return
        }
        
        var data = [PostLikeData]()
        
        for like in likes {
            var item = PostLikeDataItem()
            
            item.avatarUrl = like.avatarUrl
            item.displayName = like.displayName
            item.userId = like.id
            
            item.isFollowing = result.following != nil && result.following![like.id] != nil
            
            if let isMe = result.following?[like.id] {
                item.isMe = isMe
            }
            
            data.append(item)
        }
        
        didFetch(data: data, nextOffset: result.nextOffset)
    }
    
    fileprivate func didFetch(error: PostServiceError) {
        if let offset = offset {
            if offset.isEmpty {
                output?.didFetchNew(error: error)
            } else {
                output?.didFetchNext(error: error)
            }
        }
        
        isFetching = false
    }
    
    fileprivate func didFetch(data: [PostLikeData], nextOffset: String?) {
        if let offset = offset {
            if offset.isEmpty {
                output?.didFetchNew(data: data)
            } else {
                output?.didFetchNext(data: data)
            }
        }

        isFetching = false
        offset = nextOffset
    }
}

extension PostLikeInteractor: PostLikeInteractorInput {
    
    func fetchNew(postId: String, limit: UInt) {
        offset = ""
        fetch(postId: postId, limit: limit)
    }
    
    func fetchNext(postId: String, limit: UInt) {
        fetch(postId: postId, limit: limit)
    }
    
    func follow(userId: String) {
        userService.follow(id: userId) { [weak self] error in
            self?.output?.didFollow(error: error, userId: userId)
        }
    }
    
    func unfollow(userId: String) {
        userService.unfollow(id: userId) { [weak self] error in
            self?.output?.didUnfollow(error: error, userId: userId)
        }
    }}
