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
    @IBOutlet weak var listLayout: UICollectionViewFlowLayout!
    
    lazy var refreshView = UIRefreshControl()
    lazy var indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    lazy var emptyView = EmptyView.createNew()
    lazy var prototype: PostListCollectionCell! = PostListCollectionCell()
    
    var shouldDisplayIndicatorView: Bool = false {
        didSet {
            if shouldDisplayIndicatorView {
                indicatorView.startAnimating()
                collectionView.backgroundView = indicatorView
            } else {
                indicatorView.stopAnimating()
                collectionView.backgroundView = nil
            }
        }
    }
    
    var shouldDisplayEmptyView: Bool = false {
        didSet {
            if shouldDisplayEmptyView {
                collectionView.backgroundView = emptyView
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
    
    var isRefreshing: Bool = false {
        didSet {
            if refreshView.superview == nil {
                self.collectionView.addSubview(self.refreshView)
            }
            
            if isRefreshing {
                refreshView.beginRefreshing()
            } else {
                refreshView.endRefreshing()
            }
        }
    }
    
    var presenter: NewsFeedModuleInterface!

    override func loadView() {
        super.loadView()
        
        refreshView.addTarget(self, action: #selector(self.triggerRefresh), for: .valueChanged)
        
        emptyView.actionHandler = { [unowned self] view in
            self.presenter.initialLoad()
        }
        
        PostListCollectionCell.register(in: collectionView)
        PostListCollectionHeader.register(in: collectionView)
        
        listLayout.configure(with: view.bounds.width, columnCount: 1)
        listLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 48)
        listLayout.sectionHeadersPinToVisibleBounds = false
        
        prototype.bounds.size.width = view.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.initialLoad()
    }
    
    func triggerRefresh() {
        presenter.refreshFeeds()
    }
}

extension NewsFeedViewController: NewsFeedScene {
    
    var controller: UIViewController? {
        return self
    }

    func reloadView() {
        collectionView.reloadData()
    }

    func showEmptyView() {
        shouldDisplayEmptyView = true
    }
    
    func showInitialLoadView() {
        shouldDisplayIndicatorView = true
    }
    
    func showRefreshView() {
        isRefreshing = true
    }
    
    func hideEmptyView() {
        shouldDisplayEmptyView = false
    }
    
    func hideInitialLoadView() {
        shouldDisplayIndicatorView = false
    }
    
    func hideRefreshView() {
        isRefreshing = false
    }
    
    func didRefresh(with error: String?) {
        
    }
    
    func didLoadMore(with error: String?) {
        
    }
    
    func didLikeWithError(message: String?) {
        
    }
    
    func didUnlikeWithError(message: String?) {
    
    }
}
