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
    
    lazy var prototype: PostListCollectionCell! = PostListCollectionCell()
    
    lazy var emptyView: GhostView! = {
        let view = GhostView()
        view.titleLabel.text = "No posts"
        return view
    }()
    
    lazy var refreshView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(
            self,
            action: #selector(self.triggerRefresh),
            for: .valueChanged)
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    var shouldDisplayIndicatorView: Bool = false {
        didSet {
            if shouldDisplayIndicatorView {
                loadingView.startAnimating()
                collectionView.backgroundView = loadingView
            } else {
                loadingView.stopAnimating()
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
        
        collectionView.alwaysBounceVertical = true
        
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
