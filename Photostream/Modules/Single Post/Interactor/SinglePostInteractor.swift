//
//  SinglePostInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol SinglePostInteractorInput: BaseModuleInteractorInput {
    
    func fetchPost(id: String)
    func likePost(id: String)
    func unlikePost(id: String)
}

protocol SinglePostInteractorOutput: BaseModuleInteractorOutput {
    
    func didFetchPost(data: SinglePostData)
    func didFetchPost(error: PostServiceError)
    
    func didLike(error: PostServiceError?)
    func didUnlike(error: PostServiceError?)
}

protocol SinglePostInteractorInterface: BaseModuleInteractor {
    
    var service: PostService! { set get }
    
    init(service: PostService)
}

class SinglePostInteractor: SinglePostInteractorInterface {

    typealias Output = SinglePostInteractorOutput
    
    weak var output: Output?
    var service: PostService!
    
    required init(service: PostService) {
        self.service = service
    }
}

extension SinglePostInteractor: SinglePostInteractorInput {
    
    func fetchPost(id: String) {
        guard output != nil else {
            return
        }
        
        service.fetchPostInfo(id: id) { [weak self] result in
            guard result.error == nil else {
                self?.output?.didFetchPost(error: result.error!)
                return
            }
            
            guard let list = result.posts, list.count == 1,
                let (post, user) = list[0] else {
                let error = PostServiceError.failedToFetch(message: "Unable to fetch post")
                self?.output?.didFetchPost(error: error)
                return
            }
            
            var item = SinglePostDataItem()
            
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
            
            self?.output?.didFetchPost(data: item)
        }
    }
    
    func likePost(id: String) {
        guard output != nil else {
            return
        }
        
        service.like(id: id) { [weak self] error in
            self?.output?.didLike(error: error)
        }
    }
    
    func unlikePost(id: String) {
        guard output != nil else {
            return
        }
        
        service.unlike(id: id) { [weak self] error in
            self?.output?.didUnlike(error: error)
        }
    }
}
