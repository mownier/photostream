//
//  UserPostInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserPostInteractorInput: BaseModuleInteractorInput {
    
    func fetchNew(with userId: String, and limit: UInt)
    func fetchNext(with userId: String, and limit: UInt)
    
    func like(post id: String)
    func unlike(post id: String)
}

protocol UserPostInteractorOutput: BaseModuleInteractorOutput {
    
    func userPostDidRefresh(with data: [UserPostData])
    func userPostDidRefresh(with error: PostServiceError)
    func userPostDidLoadMore(with data: [UserPostData])
    func userPostDidLoadMore(with error: PostServiceError)
    
    func userPostDidLike(with postId: String, and error: PostServiceError?)
    func userPostDidUnlike(with postId: String, and error: PostServiceError?)
}

protocol UserPostInteractorInterface: BaseModuleInteractor {
    
    var service: PostService! { set get }
    var offset: String? { set get }
    var isFetching: Bool { set get }
    
    init(service: PostService)
    
    func fetchPosts(with userId: String, and limit: UInt)
}

class UserPostInteractor: UserPostInteractorInterface {
    
    typealias Output = UserPostInteractorOutput
    
    weak var output: Output?
    
    var service: PostService!
    var offset: String?
    var isFetching: Bool = false

    required init(service: PostService) {
        self.service = service
    }
    
    func fetchPosts(with userId: String, and limit: UInt) {
        guard output != nil, offset != nil, !isFetching else {
            return
        }
        
        isFetching = true
        
        service.fetchPosts(userId: userId, offset: offset!, limit: limit) { result in
            self.isFetching = false
            
            guard result.error == nil else {
                if self.offset!.isEmpty {
                    self.output?.userPostDidRefresh(with: result.error!)
                } else {
                    self.output?.userPostDidLoadMore(with: result.error!)
                }
                return
            }
            
            guard let list = result.posts, list.count > 0 else {
                if self.offset!.isEmpty {
                    self.output?.userPostDidRefresh(with: [UserPostDataItem]())
                } else {
                    self.output?.userPostDidLoadMore(with: [UserPostDataItem]())
                }
                return
            }
            
            var posts = [UserPostDataItem]()
            
            for post in list.posts {
                guard let user = list.users[post.userId] else {
                    continue
                }
                
                var item = UserPostDataItem()
                
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
            
            if self.offset!.isEmpty {
                self.output?.userPostDidRefresh(with: posts)
            } else {
                self.output?.userPostDidLoadMore(with: posts)
            }
            
            self.offset = result.nextOffset
        }
    }
}

extension UserPostInteractor: UserPostInteractorInput {
    
    func fetchNew(with userId: String, and limit: UInt) {
        offset = ""
        fetchPosts(with: userId, and: limit)
    }
    
    func fetchNext(with userId: String, and limit: UInt) {
        fetchPosts(with: userId, and: limit)
    }
    
    func like(post id: String) {
        guard output != nil else {
            return
        }
        
        service.like(id: id) { error in
            self.output?.userPostDidLike(with: id, and: error)
        }
    }
    
    func unlike(post id: String) {
        guard output != nil else {
            return
        }
        
        service.unlike(id: id) { error in
            self.output?.userPostDidUnlike(with: id, and: error)
        }
    }
}

