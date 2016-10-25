//
//  UserProfileViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class UserProfileViewController: UIViewController {

    var presenter: UserProfileModuleInterface!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gridCollectionView: UICollectionView!

    @IBOutlet weak var headerViewConstraintTop: NSLayoutConstraint!

    fileprivate var listLoader: PostCellLoader!
    fileprivate var gridLoader: PostCellLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        listLoader = PostCellLoader(collectionView: collectionView, type: .list)
        listLoader.listCellCallback = self
        listLoader.scrollCallback = self
        listLoader.shouldEnableStickyHeader(false)

        gridLoader = PostCellLoader(collectionView: gridCollectionView, type: .grid)
        gridLoader.gridCellCallback = self
        gridLoader.scrollCallback = self

        let inset = UIEdgeInsets(top: 185-44, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
        gridCollectionView.contentInset = inset
        gridCollectionView.scrollIndicatorInsets = inset

        presenter.fetchUserProfile()
        presenter.fetchUserPosts(10)
    }

    @IBAction func showList(_ sender: AnyObject) {
        toggleCollectionViewVisibility(collectionView, willHide: gridCollectionView)
        updateLoader(gridLoader, next: listLoader)
    }

    @IBAction func showGrid(_ sender: AnyObject) {
        toggleCollectionViewVisibility(gridCollectionView, willHide: collectionView)
        updateLoader(listLoader, next: gridLoader)
    }

    @IBAction func didTapSignOut() {
        (presenter as? UserProfilePresenter)?.presentLogin()
    }
    
    fileprivate func toggleCollectionViewVisibility(_ willShow: UIView, willHide: UIView) {
        willShow.isHidden = false
        willHide.isHidden = true
    }

    fileprivate func updateLoader(_ current: PostCellLoader, next: PostCellLoader) {
        current.killScroll()
        if !next.isContentScrollable() {
            changeRelativeOffset(current)
            putBackHeaderView()
        }
    }

    fileprivate func putBackHeaderView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.headerViewConstraintTop.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }

    fileprivate func changeRelativeOffset(_ loader: PostCellLoader) {
        if loader.isContentScrollable() {
            let offset = loader.contentOffset
            let newOffset = CGPoint(x: 0, y: offset.y + headerViewConstraintTop.constant)
            loader.updateContentOffset(newOffset, animated: false)
        } else {
            let newOffset = CGPoint(x: 0, y: 0)
            loader.updateContentOffset(newOffset, animated: false)
        }
    }
}

extension UserProfileViewController: UserProfileViewInterface {

    func showUserProfile(_ item: UserProfileDisplayItem) {
        let text: String = item.displayName[0]
        let font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightMedium)
        let image = UILabel.createPlaceholderImageWithFrame(avatarImageView.bounds, text: text, font: font)
        if let url = URL(string: item.avatarUrl) {
            let resource = ImageResource(downloadURL: url)
            avatarImageView.kf.setImage(with: resource, placeholder: image)
        } else {
            avatarImageView.image = image
        }
        
        postsCountLabel.text = item.postsCountText
        followersCountLabel.text = item.followersCountText
        followingCountLabel.text = item.followingCountText
        displayNameLabel.text = item.displayName
        descriptionLabel.text = item.getBio()
    }

    func showUserPosts(_ list: UserProfilePostListItemArray, grid: UserProfilePostGridItemArray) {
        listLoader.append(list)
        gridLoader.append(grid)
    }

    func reloadUserPosts() {
        listLoader.reload()
        gridLoader.reload()
    }

    func showError(_ message: String) {

    }
}

extension UserProfileViewController: PostListCellLoaderCallback {

    func postCellLoaderDidLikePost(_ postId: String) {
        presenter.likePost(postId)
    }

    func postCellLoaderDidUnlikePost(_ postId: String) {
        presenter.unlikePost(postId)
    }

    func postCellLoaderWillShowLikes(_ postId: String) {
        presenter.showLikes(postId)
    }

    func postCellLoaderWillShowComments(_ postId: String, shouldComment: Bool) {
        presenter.showComments(postId, shouldComment: shouldComment)
    }
}

extension UserProfileViewController: PostGridCellLoaderCallback {

    func postCellLoaderWillShowPostDetails(_ postId: String) {

    }
}

extension UserProfileViewController: PostCellLoaderScrollCallback {

    func postCellLoaderDidScrollUp(_ deltaOffsetY: CGFloat, loader: PostCellLoader) {
        if loader.contentOffset.y < 0 {
            let delta: CGFloat = headerViewConstraintTop.constant + deltaOffsetY
            let minDelta: CGFloat = min(delta, 0)
            headerViewConstraintTop.constant = minDelta
        }
    }

    func postCellLoaderDidScrollDown(_ deltaOffsetY: CGFloat, loader: PostCellLoader) {
        let delta: CGFloat = headerViewConstraintTop.constant - deltaOffsetY
        let maxDelta: CGFloat = max(delta, -(185-44))
        headerViewConstraintTop.constant = maxDelta
    }
}
