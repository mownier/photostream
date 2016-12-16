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
    func showRefreshView()
    
    func hideEmptyView()
    func hideInitialLoadView()
    func hideRefreshView()
    
    func didRefresh(with error: String?)
    func didLoadMore(with error: String?)
    
    func didLikeWithError(message: String?)
    func didUnlikeWithError(message: String?)
}
