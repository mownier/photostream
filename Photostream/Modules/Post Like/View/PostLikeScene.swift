//
//  PostLikeScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol PostLikeScene: BaseModuleView {
    
    var presenter: PostLikeModuleInterface! { set get }
    
    var isEmptyViewHidden: Bool { set get }
    var isLoadingViewHidden: Bool { set get }
    var isRefreshingViewHidden: Bool { set get }
    
    func reload()
    func reload(at index: Int)
    
    func didRefresh(error: String?)
    func didLoadMore(error: String?)
    
    func didFollow(error: String?)
    func didUnfollow(error: String?)
}
