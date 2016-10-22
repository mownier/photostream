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

    fileprivate var loader: PostCellLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        loader = PostCellLoader(collectionView: collectionView, type: .list)
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

    func showError(_ error: String) {

    }

    func showItems(_ items: PostCellItemArray) {
        loader.append(items)
    }

    func updateCell(_ postId: String, isLiked: Bool) {
        loader.reloadCell(postId, likeState: isLiked)
    }
}

extension NewsFeedViewController: PostListCellLoaderCallback {

    func postCellLoaderDidUnlikePost(_ postId: String) {
        presenter.unlikePost(postId)
    }

    func postCellLoaderDidLikePost(_ postId: String) {
        presenter.likePost(postId)
    }

    func postCellLoaderWillShowLikes(_ postId: String) {

    }

    func postCellLoaderWillShowComments(_ postId: String, shouldComment: Bool) {
        presenter.presentCommentsInterface(shouldComment)
    }
}
