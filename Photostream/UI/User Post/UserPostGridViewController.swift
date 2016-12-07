//
//  UserPostGridViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserPostGridViewController: UICollectionViewController {

    var flowLayout: UICollectionViewFlowLayout!
    var loadingView: UIActivityIndicatorView!
    
    var presenter: UserPostModuleInterface!
    
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
    
    override func loadView() {
        let size = UIScreen.main.bounds.size
        let frame = CGRect(origin: .zero, size: size)
        flowLayout = UICollectionViewFlowLayout()

        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor.white
        
        navigationItem.title = "User Post"
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        
        PostGridCollectionCell.register(in: collectionView!)
        
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.configure(with: collectionView!.frame.size.width, columnCount: 3)
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
}

extension UserPostGridViewController: UserPostScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reloadView() {
        collectionView?.reloadData()
    }
    
    func showEmptyView() {
        
    }
    
    func showRefreshView() {
        
    }
    
    func showInitialLoadView() {
        shouldShowLoadingView = true
    }
    
    func hideEmptyView() {
        
    }
    
    func hideRefreshView() {
        
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
