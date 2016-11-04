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
    lazy var dynamicCellHandler = DynamicPostListCellHandler()
    lazy var cellSizeHandler = UICollectionViewCellSizeHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.enableStickyHeader = true
        
        PostListCell.registerNib(in: collectionView)
        PostListHeader.registerNib(in: collectionView)
        PostListFooter.registerClass(in: collectionView)
        
        scrollHandler.scrollView = collectionView
        dynamicCellHandler.cell = PostListCell.createNew()
        
        cellSizeHandler.register(cell: PostListCell.createNew(), for: kPostListCellReuseId)

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
    
    func didFetchWithError(message: String) {
        print("NewsFeedViewController:", message)
    }
    
    func didLikeWithError(message: String?) {
        reloadView()
    }
    
    func didUnlikeWithError(message: String?) {
        reloadView()
    }
}
