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
    var interactor: NewsFeedInteractorInput!
    var parser: NewsFeedDisplayItemSerializer!
    var refreshing: Bool

    init() {
        self.parser = NewsFeedDisplayItemParser()
        self.refreshing = false
    }

    func refreshFeed(limit: UInt!) {
        refreshing = true
        interactor.fetchNew(limit)
    }

    func retrieveNextFeed(limit: UInt!) {
        interactor.fetchNext(limit)
    }

    func newsFeedDidFetchOk(data: NewsFeedDataCollection) {
        var collection = parseNewsFeedDisplayItems(data)
        if refreshing {
            collection.shouldTruncate = false
        } else {
            collection.shouldTruncate = true
        }
        refreshing = false
        view.showItems(collection)
        view.reloadView()
    }

    func newsFeedDidFetchWithError(error: NSError!) {
        view.showError(error)
    }

    private func parseNewsFeedDisplayItems(data: NewsFeedDataCollection) -> NewsFeedDisplayItemCollection {
        return parser.serialize(data)
    }
}
