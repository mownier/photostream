//
//  PostDiscoveryPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol PostDiscoveryPresenterInterface: BaseModulePresenter, BaseModuleInteractable {

    var posts: [PostDiscoveryData] { set get }
    var limit: UInt { set get }
}

class PostDiscoveryPresenter: PostDiscoveryPresenterInterface {

    typealias ModuleView = PostDiscoveryScene
    typealias ModuleInteractor = PostDiscoveryInteractorInput
    typealias ModuleWireframe = PostDiscoveryWireframeInterface
    
    weak var view: ModuleView!
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var posts = [PostDiscoveryData]()
    var limit: UInt = 50
}

extension PostDiscoveryPresenter: PostDiscoveryModuleInterface {
    
    var postCount: Int {
        return posts.count
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func initialLoad() {
        view.showInitialLoadView()
        interactor.fetchNew(with: limit)
    }
    
    func refreshPosts() {
        view.hideEmptyView()
        view.showRefreshView()
        interactor.fetchNew(with: limit)
    }
    
    func loadMorePosts() {
        interactor.fetchNext(with: limit)
    }
    
    func unlikePost(at index: Int) {
        guard var post = post(at: index), post.isLiked else {
            return
        }
        
        post.isLiked = false
        post.likes -= 1
        posts[index] = post
        view.reloadView()
        
        interactor.unlike(post: post.id)
    }
    
    func likePost(at index: Int) {
        guard var post = post(at: index), !post.isLiked else {
            return
        }
        
        post.isLiked = true
        post.likes += 1
        posts[index] = post
        view.reloadView()
        
        interactor.like(post: post.id)
    }
    
    func toggleLike(at index: Int) {
        guard let post = post(at: index) else {
            return
        }
        
        if post.isLiked {
            unlikePost(at: index)
        } else {
            likePost(at: index)
        }
    }
    
    func post(at index: Int) -> PostDiscoveryData? {
        guard posts.isValid(index) else {
            return nil
        }
        
        return posts[index]
    }
}

extension PostDiscoveryPresenter: PostDiscoveryInteractorOutput {
    
    func postDiscoveryDidRefresh(with data: [PostDiscoveryData]) {
        
    }
    
    func postDiscoveryDidLoadMore(with data: [PostDiscoveryData]) {
        
    }
    
    func postDiscoveryDidRefresh(with error: PostServiceError) {
        
    }
    
    func postDiscoveryDidLoadMore(with error: PostServiceError) {
        
    }
    
    func postDiscoveryDidLike(with postId: String, and error: PostServiceError?) {
        
    }
    
    func postDiscoveryDidUnlike(with postId: String, and error: PostServiceError?) {
        
    }
}
