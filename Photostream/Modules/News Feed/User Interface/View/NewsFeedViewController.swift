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
    
    private var loader: PostCellLoader!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader = PostCellLoader(collectionView: collectionView, type: .List)
        loader.listCellCallback = self
        loader.shouldEnableStickyHeader(true)
        loader.reload()
        
        // navigationItem.titleView = UILabel.createNavigationTitleView("Photostream")
        presenter.refreshFeed(10)
    }
}

extension NewsFeedViewController: NewsFeedViewInterface {

    func reloadView() {
        loader.reload()
    }

    func showEmptyView() {

    }

    func showError(error: NSError) {

    }

    func showItems(items: PostCellItemArray) {
        loader.append(items)
    }
    
    func updateCell(postId: String, isLiked: Bool) {
        loader.reloadCell(postId, likeState: isLiked)
    }
}

extension NewsFeedViewController: PostListCellLoaderCallback {
    
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
