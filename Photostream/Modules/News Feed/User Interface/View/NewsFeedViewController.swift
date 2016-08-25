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

    var presenter: NewsFeedModuleInterface!
    
    private lazy var loader: PostCellLoader = PostCellLoader(collectionView: self.collectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.callback = self
        loader.shouldEnableStickyHeader(true)
        loader.reload()
        
        navigationItem.titleView = UILabel.createNavigationTitleView("Photostream")
        presenter.refreshFeed(10)
    }
}

extension NewsFeedViewController: NewsFeedViewInterface {

    func reloadView() {
        collectionView.reloadData()
    }

    func showEmptyView() {

    }

    func showError(error: NSError) {

    }

    func showItems(items: PostCellItemList) {
        loader.append(items)
    }
    
    func updateCell(postId: String, isLiked: Bool) {
        loader.reloadCell(postId, likeState: isLiked)
    }
}

extension NewsFeedViewController: PostCellLoaderCallback {
    
    func postCellLoaderDidUnlikePost(postId: String) {
        presenter.unlikePost(postId)
    }
    
    func postCellLoaderDidLikePost(postId: String) {
        presenter.likePost(postId)
    }
    
    func postCellLoaderWillShowLikes(postId: String) {
        
    }
    
    func postCellLoaderWillShowComments(postId: String, shouldComment: Bool) {
        presenter.presentCommentsInterface(shouldComment)
    }
}
