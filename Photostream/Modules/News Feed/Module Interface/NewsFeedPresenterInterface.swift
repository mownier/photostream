//
//  NewsFeedPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedPresenterInterface {

    var view: NewsFeedViewInterface! { set get }
    var interactor: NewsFeedInteractorInput! { set get }
    var wireframe: NewsFeedWireframeInterface! { set get }
    var limit: UInt { get }
    var feeds: PostCellItemArray! { get }
    
    mutating func likePost(id: String)
    mutating func unlikePost(id: String)
    mutating func refreshFeeds()
    mutating func loadMoreFeeds()
}
