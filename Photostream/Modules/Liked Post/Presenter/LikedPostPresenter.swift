//
//  LikedPostPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol LikedPostPresenterInterface: BaseModulePresenter, BaseModuleInteractable {
    
    var userId: String! { set get }
    var posts: [LikedPostData] { set get }
    var limit: UInt { set get }
    
    func indexOf(post id: String) -> Int?
    func appendPosts(_ data: [LikedPostData])
}

class LikedPostPresenter: LikedPostPresenterInterface {

    typealias ModuleInteractor = LikedPostInteractorInput
    typealias ModuleView = LikedPostScene
    typealias ModuleWireframe = LikedPostWireframeInterface
    
    weak var view: ModuleView!
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var userId: String!
    var posts = [LikedPostData]()
    var limit: UInt = 10
    
    func indexOf(post id: String) -> Int? {
        return posts.index { item -> Bool in
            return item.id == id
        }
    }
    
    func appendPosts(_ data: [LikedPostData]) {
        let filtered = data.filter { post in
            return indexOf(post: post.id) == nil
        }
        
        posts.append(contentsOf: filtered)
    }
}

extension LikedPostPresenter: LikedPostModuleInterface {
    
    var postCount: Int {
        return posts.count
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func viewDidLoad() {
        view.isLoadingViewHidden = false
        interactor.fetchNew(userId: userId, limit: limit)
    }
    
    func refresh() {
        view.isEmptyViewHidden = true
        view.isRefreshingViewHidden = false
        interactor.fetchNew(userId: userId, limit: limit)
    }
    
    func loadMore() {
        interactor.fetchNext(userId: userId, limit: limit)
    }
    
    func unlikePost(at index: Int) {
        guard var post = post(at: index), post.isLiked else {
            view.reload(at: index)
            return
        }
        
        post.isLiked = false
        post.likes -= 1
        posts[index] = post
        
        view.reload(at: index)
        
        interactor.unlikePost(id: post.id)
    }
    
    func likePost(at index: Int) {
        guard var post = post(at: index), !post.isLiked else {
            view.reload(at: index)
            return
        }
        
        post.isLiked = true
        post.likes += 1
        posts[index] = post
        
        view.reload(at: index)
        
        interactor.likePost(id: post.id)
    }
    
    func toggleLike(at index: Int) {
        guard let post = post(at: index) else {
            view.reload(at: index)
            return
        }
        
        if post.isLiked {
            unlikePost(at: index)
            
        } else {
            likePost(at: index)
        }
    }
    
    func post(at index: Int) -> LikedPostData? {
        guard posts.isValid(index) else {
            return nil
        }
        
        return posts[index]
    }
}

extension LikedPostPresenter: LikedPostInteractorOutput {
    
    func didRefresh(data: [LikedPostData]) {
        view.isLoadingViewHidden = true
        view.isRefreshingViewHidden = true
        
        posts.removeAll()
        appendPosts(data)
        
        if postCount == 0 {
            view.isEmptyViewHidden = false
        }
        
        view.didRefresh(error: nil)
        view.reload()
    }
    
    func didLoadMore(data: [LikedPostData]) {
        view.didLoadMore(error: nil)
        
        guard data.count > 0 else {
            return
        }
        
        appendPosts(data)
        view.reload()
    }
    
    func didRefresh(error: PostServiceError) {
        view.isLoadingViewHidden = true
        view.isRefreshingViewHidden = true
        
        view.didRefresh(error: error.message)
    }
    
    func didLoadMore(error: PostServiceError) {
        view.didLoadMore(error: error.message)
    }
    
    func didLike(error: PostServiceError?, postId: String) {
        view.didLike(error: error?.message)
        
        guard let index = indexOf(post: postId),
            var post = post(at: index),
            error != nil else {
            return
        }
        
        post.isLiked = false
        
        if post.likes > 0 {
            post.likes -= 1
        }
        
        posts[index] = post
        view.reload(at: index)
    }

    func didUnlike(error: PostServiceError?, postId: String) {
        view.didUnlike(error: error?.message)
        
        guard let index = indexOf(post: postId),
            var post = post(at: index),
            error != nil else {
            return
        }
        
        post.isLiked = true
        post.likes += 1
        posts[index] = post
        
        view.reload(at: index)
    }
}
