//
//  UserActivityScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserActivityScene: BaseModuleView {

    var presenter: UserActivityModuleInterface! { set get }
    
    func reloadView()
    
    func showInitialLoadView()
    func showRefreshView()
    func showEmptyView()
    
    func hideInitialLoadView()
    func hideRefreshView()
    func hideEmptyView()
    
    func didRefresh(with error: String?)
    func didLoadMore(with error: String?)
}
