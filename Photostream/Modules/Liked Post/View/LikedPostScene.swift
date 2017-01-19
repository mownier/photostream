//
//  LikedPostScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol LikedPostScene: BaseModuleView {
    
    var presenter: LikedPostModuleInterface! { set get }
    var isLoadingViewHidden: Bool { set get }
    var isEmptyViewHidden: Bool { set get }
    var isRefreshingViewHidden: Bool { set get }
    
    func reload()
    func reload(at index: Int)
    func didRefresh(error: String?)
    func didLoadMore(error: String?)
    func didLike(error: String?)
    func didUnlike(error: String?)
}
