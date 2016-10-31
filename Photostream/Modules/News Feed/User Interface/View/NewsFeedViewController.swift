//
//  NewsFeedViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout
import DateTools

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: NewsFeedPresenterInterface!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.refreshFeeds()
    }
}

extension NewsFeedViewController: NewsFeedViewInterface {
    
    var controller: UIViewController? {
        return self
    }

    func reloadView() {
        collectionView.reloadData()
    }

    func showEmptyView() {

    }
    
    func didRefreshFeeds() {
        reloadView()
    }
    
    func didLoadMoreFeeds() {
        reloadView()
    }
    
    func didLike() {
        reloadView()
    }
    
    func didUnlike() {
        reloadView()
    }
    
    func didFetchWithError(message: String) {
        
    }
    
    func didFailToLikeWithError(message: String) {
        
    }
    
    func didFailToUnlikeWithError(message: String) {
        
    }
}
