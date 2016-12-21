//
//  PostDiscoveryScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol PostDiscoveryScene: BaseModuleView {

    var presenter: PostDiscoveryModuleInterface! { set get }
    
    func reloadView()
    
    func showInitialLoadView()
    func showRefreshView()
    func showEmptyView()
    
    func hideInitialLoadView()
    func hideRefreshView()
    func hideEmptyView()
    
    func didRefresh(with error: String?)
    func didLoadMore(with error: String?)
    func didLike(with error: String?)
    func didUnlike(with error: String?)
    
    func showInitialPost(at index: Int)
}
