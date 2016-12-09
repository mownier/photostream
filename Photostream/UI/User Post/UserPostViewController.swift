//
//  UserPostViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseAuth

enum UserPostSceneType {
    case grid
    case list
}

class UserPostViewController: UICollectionViewController {
    
    var loadingView: UIActivityIndicatorView!
    var refreshView: UIRefreshControl!
    
    var presenter: UserPostModuleInterface!
    var sceneType: UserPostSceneType = .grid {
        didSet {
            guard sceneType != oldValue else {
                return
            }
            
            reloadView()
            collectionView!.collectionViewLayout.invalidateLayout()
            
            var leftTitle = ""
            
            switch sceneType {
            case .grid:
                leftTitle = "Grid"
                collectionView!.setCollectionViewLayout(gridLayout, animated: false)
            
            case .list:
                leftTitle = "List"
                collectionView!.setCollectionViewLayout(listLayout, animated: false)
            }
            
            let barItem = UIBarButtonItem(
                title: leftTitle,
                style: .plain,
                target: self,
                action: #selector(self.toggleScene))
            
            navigationItem.leftBarButtonItem = barItem
        }
    }
    
    lazy var gridLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var listLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var prototype: PostListCollectionCell! = PostListCollectionCell()
    lazy var emptyView: GhostView! = {
        let view = GhostView()
        view.titleLabel.text = "No posts"
        return view
    }()
    
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
            guard shouldShowRefreshView != oldValue else {
                return
            }
            
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
                emptyView.removeFromSuperview()
                collectionView!.backgroundView = nil
            }
        }
    }
    
    override func loadView() {
        let size = UIScreen.main.bounds.size
        let frame = CGRect(origin: .zero, size: size)
        
        gridLayout.configure(with: size.width, columnCount: 3)
        
        listLayout.configure(with: size.width, columnCount: 1)
        listLayout.headerReferenceSize = CGSize(width: size.width, height: 48)
        listLayout.sectionHeadersPinToVisibleBounds = true

        switch sceneType {
        case .grid:
            collectionView = UICollectionView(frame: frame, collectionViewLayout: gridLayout)
        
        case .list:
            collectionView = UICollectionView(frame: frame, collectionViewLayout: listLayout)
        }
        
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor.white
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        
        refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(self.triggerRefresh), for: .valueChanged)
        
        PostGridCollectionCell.register(in: collectionView!)
        PostListCollectionCell.register(in: collectionView!)
        PostListCollectionHeader.register(in: collectionView!)
        
        prototype.contentView.bounds.size.width = size.width
        
        var barItem = UIBarButtonItem(
            title: "Sign out",
            style: .plain,
            target: self,
            action: #selector(self.signOut))
        
        navigationItem.rightBarButtonItem = barItem
        
        var leftTitle = ""
        
        switch sceneType {
        case .grid:
            leftTitle = "Grid"
            
        case .list:
            leftTitle = "List"
        }
        
        barItem = UIBarButtonItem(
            title: leftTitle,
            style: .plain,
            target: self,
            action: #selector(self.toggleScene))
        
        navigationItem.leftBarButtonItem = barItem
        
        navigationItem.title = "User Post"
        
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.refreshPosts()
    }
    
    func triggerRefresh() {
        presenter.refreshPosts()
    }
    
    func signOut() {
        try? FIRAuth.auth()?.signOut()
    }
    
    func toggleScene() {
        switch sceneType {
        case .list:
            sceneType = .grid
        
        case .grid:
            sceneType = .list
        }
    }
}

extension UserPostViewController: UserPostScene {
    
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
    
    func didRefresh(with error: String?) {
        
    }
    
    func didLoadMore(with error: String?) {
        
    }
    
    func didLike(with error: String?) {
        
    }
    
    func didUnlike(with error: String?) {
        
    }
}

