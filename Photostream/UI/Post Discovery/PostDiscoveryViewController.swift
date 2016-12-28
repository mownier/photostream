//
//  PostDiscoveryViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

enum PostDiscoverySceneType {
    case grid
    case list
}

class PostDiscoveryViewController: UICollectionViewController {

    weak var scrollEventListener: ScrollEventListener?
    
    var presenter: PostDiscoveryModuleInterface!
    var isBackBarItemVisible: Bool = false
    
    lazy var gridLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var listLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var prototype: PostListCollectionCell! = PostListCollectionCell()
    
    lazy var emptyView: GhostView! = {
        let view = GhostView()
        view.titleLabel.text = "No posts"
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var refreshView: UIRefreshControl! = {
        let view = UIRefreshControl()
        view.addTarget(
            self,
            action: #selector(self.triggerRefresh),
            for: .valueChanged)
        return view
    }()
    
    lazy var scrollHandler: ScrollHandler = {
        var handler = ScrollHandler()
        handler.scrollView = self.collectionView
        return handler
    }()
    
    var sceneType: PostDiscoverySceneType = .list {
        didSet {
            guard sceneType != oldValue else {
                return
            }
            
            reloadView()
            collectionView!.collectionViewLayout.invalidateLayout()
            
            switch sceneType {
            case .grid:
                collectionView!.setCollectionViewLayout(gridLayout, animated: false)
                
            case .list:
                collectionView!.setCollectionViewLayout(listLayout, animated: false)
            }
        }
    }
    
    var shouldShowLoadingView: Bool = false {
        didSet {
            guard shouldShowLoadingView != oldValue else {
                return
            }
            
            if shouldShowLoadingView {
                loadingView.startAnimating()
                collectionView?.backgroundView = loadingView
            } else {
                loadingView.stopAnimating()
                loadingView.removeFromSuperview()
                collectionView?.backgroundView = nil
            }
        }
    }
    
    var shouldShowRefreshView: Bool = false {
        didSet {
            if refreshView.superview == nil {
                collectionView?.addSubview(refreshView)
            }
            
            if shouldShowLoadingView {
                refreshView.beginRefreshing()
            } else {
                refreshView.endRefreshing()
            }
        }
    }
    
    var shouldShowEmptyView: Bool = false {
        didSet {
            guard shouldShowEmptyView != oldValue, collectionView != nil else {
                return
            }
            
            if shouldShowEmptyView {
                emptyView.frame.size = collectionView!.frame.size
                collectionView!.backgroundView = emptyView
            } else {
                collectionView!.backgroundView = nil
                emptyView.removeFromSuperview()
            }
        }
    }
    
    convenience init(type: PostDiscoverySceneType) {
        let layout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout: layout)
        switch type {
        case .grid:
            self.gridLayout = layout
        case .list:
            self.listLayout = layout
        }
        self.sceneType = type
    }
    
    override func loadView() {
        super.loadView()
        
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor.white
        
        let size = collectionView!.frame.size
        
        gridLayout.configure(with: size.width, columnCount: 3)
        
        listLayout.configure(with: size.width, columnCount: 1)
        listLayout.headerReferenceSize = CGSize(width: size.width, height: 48)
        listLayout.sectionHeadersPinToVisibleBounds = false
        
        PostGridCollectionCell.register(in: collectionView!)
        PostListCollectionCell.register(in: collectionView!)
        PostListCollectionHeader.register(in: collectionView!)
        
        prototype.bounds.size.width = size.width
        
        setupNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func triggerRefresh() {
        presenter.refreshPosts()
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Discovery"
        
        if isBackBarItemVisible {
            let barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_nav_icon"), style: .plain, target: self, action: #selector(self.didTapBack))
            navigationItem.leftBarButtonItem = barItem
            
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
}

extension PostDiscoveryViewController {
    
    func didTapBack() {
        presenter.exit()
    }
}

extension PostDiscoveryViewController: PostDiscoveryScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reloadView() {
        collectionView?.reloadData()
    }
    
    func showEmptyView() {
        shouldShowEmptyView = true
    }
    
    func showRefreshView() {
        shouldShowRefreshView = true
    }
    
    func showInitialLoadView() {
        shouldShowLoadingView = true
    }
    
    func hideEmptyView() {
        shouldShowEmptyView = false
    }
    
    func hideRefreshView() {
        shouldShowRefreshView = false
    }
    
    func hideInitialLoadView() {
        shouldShowLoadingView = false
    }
    
    func showInitialPost(at index: Int) {
        switch sceneType {
        case .list:
            let attributes = collectionView!.collectionViewLayout.layoutAttributesForSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                at: IndexPath(item: 0, section: index))
            
            var offset = CGPoint.zero
            offset.y = attributes!.frame.origin.y
            offset.y -= collectionView!.contentInset.top
            collectionView!.setContentOffset(offset, animated: false)
            
        default:
            break
        }
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
