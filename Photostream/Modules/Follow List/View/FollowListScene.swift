//
//  FollowListScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol FollowListScene: BaseModuleView {

    var presenter: FollowListModuleInterface! { set get }
    
    var isEmptyViewHidden: Bool { set get }
    var isLoadingViewHidden: Bool { set get }
    var isRefreshingViewHidden: Bool { set get }
    
    func reload()
    func reloadItem(at index: Int)
    
    func didRefresh(with error: String?)
    func didLoadMore(with error: String?)
    
    func didFollow(with error: String?)
    func didUnfollow(with error: String?)
}
