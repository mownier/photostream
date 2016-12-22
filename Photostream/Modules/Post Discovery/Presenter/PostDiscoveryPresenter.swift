//
//  PostDiscoveryPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostDiscoveryPresenterInterface: BaseModulePresenter, BaseModuleInteractable {

    var posts: [PostDiscoveryData] { set get }
    var limit: UInt { set get }
    var initialPostIndex: Int { set get }
    var isShownInitialPost: Bool { set get }
    
    func indexOf(post id: String) -> Int?
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
    var initialPostIndex: Int = 0
    var isShownInitialPost: Bool = false
    
    func indexOf(post id: String) -> Int? {
        let itemIndex = posts.index { item -> Bool in
            return item.id == id
        }
        return itemIndex
    }
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
    
    func viewDidLoad() {
        if postCount == 0 {
            initialLoad()
            
        } else {
            view.reloadView()
            view.hideInitialLoadView()
            view.hideRefreshView()
        }
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
    
    func initialPostWillShow() {
        guard !isShownInitialPost, posts.isValid(initialPostIndex) else {
            return
        }
        
        view.showInitialPost(at: initialPostIndex)
        isShownInitialPost = true
    }
}

extension PostDiscoveryPresenter: PostDiscoveryInteractorOutput {
    
    func postDiscoveryDidRefresh(with data: [PostDiscoveryData]) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        posts.removeAll()
        posts.append(contentsOf: data)
        
        if posts.count == 0 {
            view.showEmptyView()
        }
        
        view.didRefresh(with: nil)
        view.reloadView()
    }
    
    func postDiscoveryDidLoadMore(with data: [PostDiscoveryData]) {
        view.didLoadMore(with: nil)
        
        guard data.count > 0 else {
            return
        }
        
        posts.append(contentsOf: data)
        view.reloadView()
    }
    
    func postDiscoveryDidRefresh(with error: PostServiceError) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        view.didRefresh(with: error.message)
    }
    
    func postDiscoveryDidLoadMore(with error: PostServiceError) {
         view.didLoadMore(with: error.message)
    }
    
    func postDiscoveryDidLike(with postId: String, and error: PostServiceError?) {
        view.didLike(with: error?.message)
    }
    
    func postDiscoveryDidUnlike(with postId: String, and error: PostServiceError?) {
        view.didUnlike(with: error?.message)
    }
}
