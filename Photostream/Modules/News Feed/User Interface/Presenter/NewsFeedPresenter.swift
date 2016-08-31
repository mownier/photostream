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

    func refreshFeed(limit: UInt!) {
        refreshing = true
        interactor.fetchNew(limit)
    }

    func retrieveNextFeed(limit: UInt!) {
        interactor.fetchNext(limit)
    }

    func presentCommentsInterface(shouldComment: Bool) {
        wireframe.navigateCommentsInterface(shouldComment)
    }

    func toggleLike(postId: String, isLiked: Bool) {
        if isLiked {
            unlikePost(postId)
        } else {
            likePost(postId)
        }
    }

    func likePost(postId: String) {
        view.updateCell(postId, isLiked: true)
    }

    func unlikePost(postId: String) {
        view.updateCell(postId, isLiked: false)
    }

    func newsFeedDidFetchOk(data: NewsFeedDataCollection) {
        var list = parseList(data)
        if refreshing {
            list.mode = .Truncate
        } else {
            list.mode = .Default
        }
        refreshing = false
        view.showItems(list)
        view.reloadView()
    }

    func newsFeedDidFetchWithError(error: NSError!) {
        view.showError(error)
    }

    private func parseList(data: NewsFeedDataCollection) -> PostCellItemArray {
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
