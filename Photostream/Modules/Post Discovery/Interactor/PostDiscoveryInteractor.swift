//
//  PostDiscoveryInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol PostDiscoveryInteractorInput: BaseModuleInteractorInput {
    
    func fetchNew(with limit: UInt)
    func fetchNext(with limit: UInt)
    
    func like(post id: String)
    func unlike(post id: String)
}

protocol PostDiscoveryInteractorOutput: BaseModuleInteractorOutput {
    
    func postDiscoveryDidRefresh(with data: [PostDiscoveryData])
    func postDiscoveryDidLoadMore(with data: [PostDiscoveryData])
    
    func postDiscoveryDidRefresh(with error: PostServiceError)
    func postDiscoveryDidLoadMore(with error: PostServiceError)
    
    func postDiscoveryDidLike(with postId: String, and error: PostServiceError?)
    func postDiscoveryDidUnlike(with postId: String, and error: PostServiceError?)
}

protocol PostDiscoveryInteractorInterface: BaseModuleInteractor {
    
    var service: PostService! { set get }
    var offset: String? { set get }
    var isFetching: Bool { set get }
    
    init(service: PostService)
    
    func fetchDiscoveryPosts(with limit: UInt)
}

class PostDiscoveryInteractor: PostDiscoveryInteractorInterface {

    typealias Output = PostDiscoveryInteractorOutput
    
    weak var output: Output?
    
    var service: PostService!
    var offset: String?
    var isFetching: Bool = false
    
    required init(service: PostService) {
        self.service = service
    }
    
    func fetchDiscoveryPosts(with limit: UInt) {
        guard !isFetching, offset != nil, output != nil else {
            return
        }
        
        service.fetchDiscoveryPosts(offset: offset!, limit: limit) { [weak self] result in
            guard result.error == nil else {
                self?.didFetch(with: result.error!)
                return
            }
            
            guard let list = result.posts, list.count > 0 else {
                self?.didFetch(with: [PostDiscoveryData]())
                return
            }
            
            var posts = [PostDiscoveryData]()
            
            for post in list.posts {
                guard let user = list.users[post.userId] else {
                    continue
                }
                
                var item = PostDiscoveryDataItem()
                
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
            
            self?.didFetch(with: posts)
            self?.offset = result.nextOffset
        }
    }
    
    private func didFetch(with error: PostServiceError) {
        if offset != nil, offset!.isEmpty {
            output?.postDiscoveryDidRefresh(with: error)
            
        } else {
            output?.postDiscoveryDidLoadMore(with: error)
        }
        
        isFetching = false
    }
    
    private func didFetch(with data: [PostDiscoveryData]) {
        if offset != nil, offset!.isEmpty {
            output?.postDiscoveryDidRefresh(with: data)
            
        } else {
            output?.postDiscoveryDidLoadMore(with: data)
        }
        
        isFetching = false
    }
}

extension PostDiscoveryInteractor: PostDiscoveryInteractorInput {
    
    func fetchNew(with limit: UInt) {
        offset = ""
        fetchDiscoveryPosts(with: limit)
    }
    
    func fetchNext(with limit: UInt) {
        fetchDiscoveryPosts(with: limit)
    }
    
    func like(post id: String) {
        guard output != nil else {
            return
        }
        
        service.like(id: id) { [unowned self] error in
            self.output?.postDiscoveryDidLike(with: id, and: error)
        }
    }
    
    func unlike(post id: String) {
        guard output != nil else {
            return
        }
        
        service.unlike(id: id) { [unowned self] error in
            self.output?.postDiscoveryDidUnlike(with: id, and: error)
        }
    }
}
