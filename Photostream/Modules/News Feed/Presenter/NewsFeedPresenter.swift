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
        interactor.fetchNew(with: limit)
        view.didStartRefreshingFeeds()
    }
    
    func loadMoreFeeds() {
        interactor.fetchNext(with: limit)
    }
    
    func like(post id: String) {
        guard let index = feed.indexOf(post: id),
            var post = feed.items[index] as? NewsFeedPost, !post.isLiked else {
            return
        }
        
        post.isLiked = true
        post.likes += 1
        feed.items[index] = post
        view.reloadView()
        interactor.like(post: id)
    }
    
    func unlike(post id: String) {
        guard let index = feed.indexOf(post: id),
            var post = feed.items[index] as? NewsFeedPost, post.isLiked else {
            return
        }
        
        post.isLiked = false
        post.likes -= 1
        feed.items[index] = post
        view.reloadView()
        interactor.unlike(post: id)
    }
    
    var feedCount: Int {
        return feed.items.count
    }
    
    func feed(at index: Int) -> NewsFeedDataItem? {
        return feed.items[index]
    }
}

extension NewsFeedPresenter: NewsFeedInteractorOutput {
    
    func newsFeedDidRefresh(data: NewsFeedData) {
        feed.items.removeAll()
        feed.items.append(contentsOf: data.items)
        view.didRefreshFeeds()
        view.reloadView()
        
        if feed.items.count == 0 {
            view.showEmptyView()
        }
    }
    
    func newsFeedDidLoadMore(data: NewsFeedData) {
        feed.items.append(contentsOf: data.items)
        view.didLoadMoreFeeds()
        view.reloadView()
    }
    
    func newsFeedDidFetchWithError(error: NewsFeedServiceError) {
        view.didFetchWithError(message: error.message)
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
