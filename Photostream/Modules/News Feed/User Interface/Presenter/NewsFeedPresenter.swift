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
    
    var feedCount: Int! {
        get {
            return interactor.feedCount
        }
    }
    
    func refreshFeed(limit: UInt!) {
        interactor.fetchNew(limit)
    }
    
    func retrieveNextFeed(limit: UInt!) {
        interactor.fetchNext(limit)
    }
    
    func getPostAtIndex(index: UInt!) -> (Post!, User!) {
        return interactor.fetchPost(index)
    }
    
    func newsFeedDidFetchOk() {
        view.reloadView()
    }
    
    func newsFeedDidFetchWithError(error: NSError!) {
        // TODO: Show error
    }
}
