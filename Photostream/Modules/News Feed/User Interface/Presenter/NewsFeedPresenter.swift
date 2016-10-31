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
    var feeds: PostCellItemArray!
    var limit: UInt {
        return 10
    }
    
    init() {
        self.feeds = PostCellItemArray()
    }

    mutating func refreshFeeds() {
        interactor.fetchNew(limit: limit)
    }

    mutating func loadMoreFeeds() {
        interactor.fetchNext(limit: limit)
    }

    mutating func likePost(id: String) {
        guard let index = feeds[id],
            let feed = feeds[index], !feed.isLiked else {
            return
        }
        
        feeds[index]!.isLiked = true
        interactor.likePost(id: id)
    }

    mutating func unlikePost(id: String) {
        guard let index = feeds[id],
            let feed = feeds[index], feed.isLiked else {
            return
        }
        
        feeds[index]!.isLiked = false
        interactor.unlikePost(id: id)
    }

    fileprivate func parseList(_ data: NewsFeedDataCollection) -> PostCellItemArray {
        var list = PostCellItemArray()
        for i in 0..<data.count {
            if let (post, user) = data[i] {
                let parser = NewsFeedDisplayItemParser(post: post, user: user)
                let item =  parser.serializeCellItem()
                list.append(item)
            }
        }
        return list
    }
}

extension NewsFeedPresenter: NewsFeedInteractorOutput {
    
    mutating func newsFeedDidRefresh(data: NewsFeedDataCollection) {
        var list = parseList(data)
        list.mode = .truncate
        feeds.appendContentsOf(list)
        
        view.didRefreshFeeds()
        
        if feeds.count == 0 {
            view.showEmptyView()
        }
    }
    
    mutating func newsFeedDidLoadMore(data: NewsFeedDataCollection) {
        let list = parseList(data)
        feeds.appendContentsOf(list)
        
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
