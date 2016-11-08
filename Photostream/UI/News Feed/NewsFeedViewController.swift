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
    var refreshControl: UIRefreshControl!

    var presenter: NewsFeedModuleInterface!
    lazy var scrollHandler = ScrollHandler()
    lazy var sizeHandler = DynamicSizeHandler<String,String>()

    override func loadView() {
        super.loadView()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRightBarButtonItem()
        
        flowLayout.enableStickyHeader = true
        
        PostListCell.registerPrototype(in: &sizeHandler)
        PostListCell.registerNib(in: collectionView)
        PostListHeader.registerNib(in: collectionView)
        PostListFooter.registerClass(in: collectionView)
        
        scrollHandler.scrollView = collectionView

        refresh()
    }
    
    func configureRightBarButtonItem() {
        let barItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.loadMore))
        
        navigationItem.rightBarButtonItem = barItem
    }
    
    func loadMore() {
        presenter.loadMoreFeeds()
    }
    
    func refresh() {
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
        refreshControl.endRefreshing()
        reloadView()
    }
    
    func didLoadMoreFeeds() {
        reloadView()
    }
    
    func didFetchWithError(message: String) {
        refreshControl.endRefreshing()
    }
    
    func didLikeWithError(message: String?) {
    
    }
    
    func didUnlikeWithError(message: String?) {
    
    }
}
