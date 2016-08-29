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
        listLoader.shouldEnableStickyHeader(false)
        
        gridLoader = PostCellLoader(collectionView: gridCollectionView, type: .Grid)
        gridLoader.gridCellCallback = self
        
        presenter.fetchUserProfile()
        presenter.fetchUserPosts(10)
    }
    
    @IBAction func showList(sender: AnyObject) {
        collectionView.hidden = false
        gridCollectionView.hidden = true
    }
    
    @IBAction func showGrid(sender: AnyObject) {
        collectionView.hidden = true
        gridCollectionView.hidden = false
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
        print("user profile:", error)
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
