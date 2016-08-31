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
    
    private var listLoader: PostCellLoader!
    private var gridLoader: PostCellLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listLoader = PostCellLoader(collectionView: collectionView, type: .List)
        listLoader.listCellCallback = self
        listLoader.scrollCallback = self
        listLoader.shouldEnableStickyHeader(false)
        
        gridLoader = PostCellLoader(collectionView: gridCollectionView, type: .Grid)
        gridLoader.gridCellCallback = self
        gridLoader.scrollCallback = self
        
        let inset = UIEdgeInsetsMake(185-44, 0, 0, 0)
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
        gridCollectionView.contentInset = inset
        gridCollectionView.scrollIndicatorInsets = inset
        
        presenter.fetchUserProfile()
        presenter.fetchUserPosts(10)
    }
    
    @IBAction func showList(sender: AnyObject) {
        toggleCollectionViewVisibility(collectionView, willHide: gridCollectionView)
        updateLoader(gridLoader, next: listLoader)
    }
    
    @IBAction func showGrid(sender: AnyObject) {
        toggleCollectionViewVisibility(gridCollectionView, willHide: collectionView)
        updateLoader(listLoader, next: gridLoader)
    }
    
    private func toggleCollectionViewVisibility(willShow: UIView, willHide: UIView) {
        willShow.hidden = false
        willHide.hidden = true
    }
    
    private func updateLoader(current: PostCellLoader, next: PostCellLoader) {
        current.killScroll()
        if !next.isContentScrollable() {
            changeRelativeOffset(current)
            putBackHeaderView()
        }
    }
    
    private func putBackHeaderView() {
        UIView.animateWithDuration(0.25, animations: {
            self.headerViewConstraintTop.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    private func changeRelativeOffset(loader: PostCellLoader) {
        if loader.isContentScrollable() {
            let offset = loader.contentOffset
            let newOffset = CGPointMake(0, offset.y + headerViewConstraintTop.constant)
            loader.updateContentOffset(newOffset, animated: false)
        } else {
            let newOffset = CGPointMake(0, 0)
            loader.updateContentOffset(newOffset, animated: false)
        }
    }
}

extension UserProfileViewController: UserProfileViewInterface {
    
    func showUserProfile(item: UserProfileDisplayItem) {
        let text: String = item.displayName[0]
        let font = UIFont.systemFontOfSize(28, weight: UIFontWeightMedium)
        let image = UILabel.createPlaceholderImageWithFrame(avatarImageView.bounds, text: text, font: font)
        avatarImageView.kf_setImageWithURL(NSURL(string: item.avatarUrl), placeholderImage: image, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        postsCountLabel.text = item.postsCountText
        followersCountLabel.text = item.followersCountText
        followingCountLabel.text = item.followingCountText
        displayNameLabel.text = item.displayName
        descriptionLabel.text = item.getBio()
    }
    
    func showUserPosts(list: UserProfilePostListItemArray, grid: UserProfilePostGridItemArray) {
        listLoader.append(list)
        gridLoader.append(grid)
    }
    
    func reloadUserPosts() {
        listLoader.reload()
        gridLoader.reload()
    }
    
    func showError(error: NSError) {
        
    }
}

extension UserProfileViewController: PostListCellLoaderCallback {
    
    func postCellLoaderDidLikePost(postId: String) {
        presenter.likePost(postId)
    }
    
    func postCellLoaderDidUnlikePost(postId: String) {
        presenter.unlikePost(postId)
    }
    
    func postCellLoaderWillShowLikes(postId: String) {
        presenter.showLikes(postId)
    }
    
    func postCellLoaderWillShowComments(postId: String, shouldComment: Bool) {
        presenter.showComments(postId, shouldComment: shouldComment)
    }
}

extension UserProfileViewController: PostGridCellLoaderCallback {
    
    func postCellLoaderWillShowPostDetails(postId: String) {
        
    }
}

extension UserProfileViewController: PostCellLoaderScrollCallback {
    
    func postCellLoaderDidScrollUp(deltaOffsetY: CGFloat, loader: PostCellLoader) -> Bool {
        if loader.contentOffset.y < 0 {
            let delta: CGFloat = headerViewConstraintTop.constant + deltaOffsetY
            let minDelta: CGFloat = min(delta, 0)
            headerViewConstraintTop.constant = minDelta
            return minDelta == 0
        }
        return false
    }
    
    func postCellLoaderDidScrollDown(deltaOffsetY: CGFloat, loader: PostCellLoader) -> Bool {
        let delta: CGFloat = headerViewConstraintTop.constant - deltaOffsetY
        let maxDelta: CGFloat = max(delta, -(185-44))
        headerViewConstraintTop.constant = maxDelta
        return maxDelta == -(185-44)
    }
}
