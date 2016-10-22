//
//  NewsFeedPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedPresenter: NewsFeedModuleInterface, NewsFeedInteractorOutput {

    weak var view: NewsFeedViewInterface!
    var wireframe: NewsFeedWireframe!
    var interactor: NewsFeedInteractorInput!
    var refreshing: Bool

    init() {
        self.refreshing = false
    }

    func refreshFeed(_ limit: UInt!) {
        refreshing = true
        interactor.fetchNew(limit)
    }

    func retrieveNextFeed(_ limit: UInt!) {
        interactor.fetchNext(limit)
    }

    func presentCommentsInterface(_ shouldComment: Bool) {
        wireframe.navigateCommentsInterface(shouldComment)
    }

    func toggleLike(_ postId: String, isLiked: Bool) {
        if isLiked {
            unlikePost(postId)
        } else {
            likePost(postId)
        }
    }

    func likePost(_ postId: String) {
        view.updateCell(postId, isLiked: true)
    }

    func unlikePost(_ postId: String) {
        view.updateCell(postId, isLiked: false)
    }

    func newsFeedDidFetchOk(_ data: NewsFeedDataCollection) {
        var list = parseList(data)
        if refreshing {
            list.mode = .truncate
        } else {
            list.mode = .default
        }
        refreshing = false
        view.showItems(list)
        view.reloadView()
    }

    func newsFeedDidFetchWithError(_ error: NewsFeedServiceError) {
        view.showError(error.message)
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
