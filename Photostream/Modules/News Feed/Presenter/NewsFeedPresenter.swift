//
//  NewsFeedPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedPresenterInterface: BaseModulePresenter, BaseModuleInteractable {
    
    var limit: UInt { set get }
    var feed: NewsFeedData! { get }
}

class NewsFeedPresenter: NewsFeedPresenterInterface {
    
    typealias ModuleView = NewsFeedScene
    typealias ModuleInteractor = NewsFeedInteractorInput
    typealias ModuleWireframe = NewsFeedWireframeInterface
    
    weak var view: ModuleView!
    
    var wireframe: ModuleWireframe!
    var interactor: ModuleInteractor!
    
    var feed: NewsFeedData! = NewsFeedData()
    var limit: UInt = 10
}

extension NewsFeedPresenter: NewsFeedModuleInterface {
    
    var feedCount: Int {
        return feed.items.count
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
    
    func refreshFeeds() {
        view.hideEmptyView()
        view.showRefreshView()
        interactor.fetchNew(with: limit)
    }
    
    func loadMoreFeeds() {
        interactor.fetchNext(with: limit)
    }
    
    func toggleLike(at index: Int) {
        guard let post = feed(at: index) as? NewsFeedPost else {
            return
        }
        
        if post.isLiked {
            unlikePost(at: index)
        } else {
            likePost(at: index)
        }
    }
    
    func likePost(at index: Int) {
        guard feed.items.isValid(index),
            var post = feed.items[index] as? NewsFeedPost, !post.isLiked else {
            return
        }
        
        post.isLiked = true
        post.likes += 1
        feed.items[index] = post
        view.reloadView()
        interactor.like(post: post.id)
    }
    
    func unlikePost(at index: Int) {
        guard feed.items.isValid(index),
            var post = feed.items[index] as? NewsFeedPost, post.isLiked else {
            return
        }
        
        post.isLiked = false
        post.likes -= 1
        feed.items[index] = post
        view.reloadView()
        interactor.unlike(post: post.id)
    }
    
    func feed(at index: Int) -> NewsFeedDataItem? {
        return feed.items[index]
    }
}

extension NewsFeedPresenter: NewsFeedInteractorOutput {
    
    func newsFeedDidRefresh(data: NewsFeedData) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        feed.items.removeAll()
        feed.items.append(contentsOf: data.items)
        
        if feed.items.count == 0 {
            view.showEmptyView()
        }
        
        view.didRefresh(with: nil)
        view.reloadView()
    }
    
    func newsFeedDidLoadMore(data: NewsFeedData) {
        view.didLoadMore(with: nil)
        
        guard data.items.count > 0 else {
            return
        }
        
        feed.items.append(contentsOf: data.items)
        view.reloadView()
    }
    
    func newsFeedDidRefresh(error: NewsFeedServiceError) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        view.didRefresh(with: error.message)
    }
    
    func newsFeedDidLoadMore(error: NewsFeedServiceError) {
        view.didLoadMore(with: error.message)
    }
    
    func newsFeedDidLike(with postId: String, and error: PostServiceError?) {
        view.didLikeWithError(message: error?.message)
        view.reloadView()
    }
    
    func newsFeedDidUnlike(with postId: String, and error: PostServiceError?) {
        view.didUnlikeWithError(message: error?.message)
        view.reloadView()
    }
}
