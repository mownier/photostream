//
//  NewsFeedScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol NewsFeedScene: BaseModuleView {

    var presenter: NewsFeedModuleInterface! { set get }
    
    func reloadView()
    func showEmptyView()
    func showInitialLoadView()
    
    func didStartRefreshingFeeds()
    func didRefreshFeeds()
    func didLoadMoreFeeds()
    
    func didFetchWithError(message: String)
    func didLikeWithError(message: String?)
    func didUnlikeWithError(message: String?)
}
