//
//  LikedPostViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

class LikedPostViewController: UICollectionViewController {

    lazy var prototype: PostListCollectionCell! = PostListCollectionCell()
    
    lazy var loadingView: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    var listLayout: UICollectionViewFlowLayout!
    var presenter: LikedPostModuleInterface!
    
    var isLoadingViewHidden: Bool = false {
        didSet {
            
        }
    }
    
    var isEmptyViewHidden: Bool = false {
        didSet {
            
        }
    }
    
    var isRefreshingViewHidden: Bool = false {
        didSet {
            
        }
    }
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout: layout)
        self.listLayout = layout
    }
    
    override func loadView() {
        super.loadView()
        
        guard collectionView != nil else {
            return
        }
        
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor.white
        
        let size = collectionView!.frame.size
        
        listLayout.configure(with: size.width, columnCount: 1)
        listLayout.headerReferenceSize = CGSize(width: size.width, height: 48)
        listLayout.sectionHeadersPinToVisibleBounds = false
        
        PostListCollectionCell.register(in: collectionView!)
        PostListCollectionHeader.register(in: collectionView!)
        
        prototype.bounds.size.width = size.width
        
        setupNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "back_nav_icon"),
            style: .plain,
            target: self,
            action: #selector(self.back))
        
        navigationItem.leftBarButtonItem = barItem
        
        navigationItem.title = "Liked Post"
    }
    
    func back() {
        presenter.exit()
    }
}

extension LikedPostViewController: LikedPostScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reload() {
        collectionView?.reloadData()
    }
    
    func reload(at index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView?.reloadItems(at: [indexPath])
    }
    
    func didRefresh(error: String?) {
        
    }
    
    func didLoadMore(error: String?) {
        
    }
    
    func didLike(error: String?) {
        
    }
    
    func didUnlike(error: String?) {
        
    }
}
