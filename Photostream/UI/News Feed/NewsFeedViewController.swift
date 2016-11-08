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
    @IBOutlet weak var flowLayout: MONUniformFlowLayout!

    var presenter: NewsFeedModuleInterface!
    lazy var scrollHandler = ScrollHandler()
    lazy var sizeHandler = DynamicSizeHandler<String,String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRightBarButtonItem()
        
        flowLayout.enableStickyHeader = true
        
        PostListCell.registerPrototype(in: &sizeHandler)
        PostListCell.registerNib(in: collectionView)
        PostListHeader.registerNib(in: collectionView)
        PostListFooter.registerClass(in: collectionView)
        
        scrollHandler.scrollView = collectionView

        presenter.refreshFeeds()
    }
    
    func configureRightBarButtonItem() {
        let barItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.loadMore))
        
        navigationItem.rightBarButtonItem = barItem
    }
    
    func loadMore() {
        presenter.loadMoreFeeds()
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
    
    func didFetchWithError(message: String) {
    
    }
    
    func didLikeWithError(message: String?) {
    
    }
    
    func didUnlikeWithError(message: String?) {
    
    }
}
