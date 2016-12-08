//
//  UserPostGridViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserPostGridViewController: UICollectionViewController {

    var flowLayout: UICollectionViewFlowLayout!
    var loadingView: UIActivityIndicatorView!
    var refreshView: UIRefreshControl!
    
    var presenter: UserPostModuleInterface!
    
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
        
        flowLayout = UICollectionViewFlowLayout()
        configureFlowLayout(with: size)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor.white
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        
        refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(self.triggerRefresh), for: .valueChanged)
        
        registerCell()
        
        let barItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.signOut))
        navigationItem.rightBarButtonItem = barItem
        navigationItem.title = "User Post"
        
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.refreshPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.postCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PostGridCollectionCell.dequeue(from: collectionView, for: indexPath)!
        let item = presenter.post(at: indexPath.row) as? PostGridCollectionCellItem
        cell.configure(with: item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == presenter.postCount - 10 else {
            return
        }
        
        presenter.loadMorePosts()
    }
    
    func triggerRefresh() {
        presenter.refreshPosts()
    }
    
    func signOut() {
        try? FIRAuth.auth()?.signOut()
    }
    
    func configureFlowLayout(with size: CGSize) {
        flowLayout.configure(with: size.width, columnCount: 3)
    }
    
    func registerCell() {
        PostGridCollectionCell.register(in: collectionView!)
    }
}

extension UserPostGridViewController: UserPostScene {
    
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
