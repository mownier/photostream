//
//  NewsFeedPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedPresenter: NewsFeedPresenterInterface {
    
    weak var view: NewsFeedViewInterface!
    var wireframe: NewsFeedWireframeInterface!
    var interactor: NewsFeedInteractorInput!
    var feed: NewsFeedData! = NewsFeedData()
    var limit: UInt {
        return 10
    }
}

extension NewsFeedPresenter: NewsFeedModuleInterface {
    
    func refreshFeeds() {
        interactor.fetchNew(with: limit)
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
        feed.items[index] = post
        interactor.like(post: id)
    }
    
    func unlike(post id: String) {
        guard let index = feed.indexOf(post: id),
            var post = feed.items[index] as? NewsFeedPost, post.isLiked else {
            return
        }
        
        post.isLiked = false
        feed.items[index] = post
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
        
        if feed.items.count == 0 {
            view.showEmptyView()
        }
    }
    
    func newsFeedDidLoadMore(data: NewsFeedData) {
        feed.items.append(contentsOf: data.items)
        view.didLoadMoreFeeds()
    }
    
    func newsFeedDidFetchWithError(error: NewsFeedServiceError) {
        view.didFetchWithError(message: error.message)
    }
    
    func newsFeedDidLike(with error: PostServiceError?) {
        view.didLikeWithError(message: error?.message)
    }
    
    func newsFeedDidUnlike(with error: PostServiceError?) {
        view.didUnlikeWithError(message: error?.message)
    }
}
