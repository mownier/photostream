//
//  NewsFeedPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct NewsFeedPresenter: NewsFeedPresenterInterface {
    
    weak var view: NewsFeedViewInterface!
    var wireframe: NewsFeedWireframeInterface!
    var interactor: NewsFeedInteractorInput!
    var feeds: NewsFeedData!
    var limit: UInt {
        return 10
    }
    
    init() {
        self.feeds = NewsFeedData()
    }

    mutating func refreshFeeds() {
        interactor.fetchNew(limit: limit)
    }

    mutating func loadMoreFeeds() {
        interactor.fetchNext(limit: limit)
    }

    mutating func likePost(id: String) {
        guard let feed = feeds[id], !feed.isLiked else {
            return
        }
        
        feeds[id]!.isLiked = true
        interactor.likePost(id: id)
    }

    mutating func unlikePost(id: String) {
        guard let feed = feeds[id], !feed.isLiked else {
            return
        }
        
        feeds[id]!.isLiked = false
        interactor.unlikePost(id: id)
    }
}

extension NewsFeedPresenter: NewsFeedInteractorOutput {
    
    mutating func newsFeedDidRefresh(data: NewsFeedData) {
        feeds.items.append(contentsOf: data.items)
        
        view.didRefreshFeeds()
        
        if feeds.items.count == 0 {
            view.showEmptyView()
        }
    }
    
    mutating func newsFeedDidLoadMore(data: NewsFeedData) {
        feeds.items.append(contentsOf: data.items)
        
        view.didLoadMoreFeeds()
    }
    
    func newsFeedDidFetchWithError(error: NewsFeedServiceError) {
        view.didFetchWithError(message: error.message)
    }
    
    func newsFeedDidLike(with error: NewsFeedServiceError?) {
        view.didLikeWithError(message: error?.message)
    }
    
    func newsFeedDidUnlike(with error: NewsFeedServiceError?) {
        view.didUnlikeWithError(message: error?.message)
    }
}
