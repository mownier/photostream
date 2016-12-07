//
//  UserPostListViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserPostListViewController: UICollectionViewController {
    
    var presenter: UserPostModuleInterface!
}

extension UserPostListViewController: UserPostScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reloadView() {
        
    }
    
    func showEmptyView() {
        
    }
    
    func showRefreshView() {
        
    }
    
    func showInitialLoadView() {
        
    }
    
    func hideEmptyView() {
        
    }
    
    func hideRefreshView() {
        
    }
    
    func hideInitialLoadView() {
        
    }
    
    func didRefresh(with error: String?) {
        
    }
    
    func didLoadMore(with error: String?) {
        
    }
    
    func didLike(with error: String?) {
        
    }
    
    func didUnlike(with error: String?) {
        
    }
}
