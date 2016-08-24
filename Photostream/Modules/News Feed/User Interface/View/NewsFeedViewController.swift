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
    @IBOutlet weak var flowLayout: MONUniformFlowLayout!

    var presenter: NewsFeedModuleInterface!
    var displayItems = NewsFeedDisplayItemCollection()

    var sizingCell: NewsFeedCell!
    var cellHeights = [CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout.enableStickyHeader = true
        NewsFeedCell.registerNibInto(collectionView)

        sizingCell = NewsFeedCell.createNew()
        navigationItem.titleView = UILabel.createNavigationTitleView("Photostream")
        presenter.refreshFeed(10)
    }

    private func configureHeaderView(view: NewsFeedHeaderView, index: Int) {
        if let item = displayItems[index] {
            let displayName = item.headerItem.displayName
            let avatarUrl = item.headerItem.avatarUrl
            let placeholderImage = view.createAvatarPlaceholderImage(displayName[0])
            view.setDisplayName(displayName)
            view.setAvatarUrl(avatarUrl, placeholderImage: placeholderImage)
        }
    }

    private func configureCell(cell: NewsFeedCell, index: Int) {
        if let item = displayItems[index] {
            cell.setPhotoUrl(item.cellItem.photoUrl)
            cell.setLikesCountText(item.cellItem.likes)
            cell.setCommentsCountText(item.cellItem.comments)
            cell.setMessage(item.cellItem.message, displayName: item.headerItem.displayName)
            cell.setElapsedTime(item.cellItem.timestamp.timeAgoSinceNow())
            cell.shouldHighlightLikeButton(item.cellItem.isLiked)
        }
    }

    private func computeExpectedCellHeight(cell: NewsFeedCell!, index: Int!, width: CGFloat) -> CGFloat {
        configureCell(cell, index: index)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        let photoHeight = computeExpectedPhotoHeight(index, width: collectionView.width)
        
        return size.height + photoHeight
    }

    private func computeExpectedPhotoHeight(index: Int!, width: CGFloat) -> CGFloat {
        if let item = displayItems[index] {
            let photoWidth = item.cellItem.photoWidth
            let photoHeight = item.cellItem.photoHeight
            let ratio = width / CGFloat(photoWidth)
            return  CGFloat(photoHeight) * ratio
        }

        return -1
    }
    
    private func displayItemForCell(cell: NewsFeedCell) -> NewsFeedDisplayItem? {
        if let indexPath = collectionView.indexPathForCell(cell) {
            return displayItems[indexPath.section]
        }
        
        return nil
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

    func showItems(items: NewsFeedDisplayItemCollection) {
        displayItems.appendContentsOf(items)
    }
    
    func updateCell(postId: String, isLiked: Bool) {
        let (i, valid) = displayItems.isValid(postId)
        if valid {
            displayItems[i]!.cellItem.isLiked = isLiked

            let set = NSIndexSet(index: i)
            UIView.performWithoutAnimation({
                self.collectionView.reloadSections(set)
            })
        }
    }
}

extension NewsFeedViewController: NewsFeedCellDelegate {

    func newsFeedCellDidTapLike(cell: NewsFeedCell) {
        if let item = displayItemForCell(cell) {
            presenter.toggleLike(item.postId, isLiked: item.cellItem.isLiked)
        }
    }

    func newsFeedCellDidTapLikesCount(cell: NewsFeedCell) {

    }

    func newsFeedCellDidTapComment(cell: NewsFeedCell) {

    }

    func newsFeedCellDidTapCommentsCount(cell: NewsFeedCell) {
        presenter.presentCommentsInterface(false)
    }
    
    func newsFeedCellDidTapPhoto(cell: NewsFeedCell) {
        if let item = displayItemForCell(cell) {
            presenter.likePost(item.postId)
        }
    }
}

extension NewsFeedViewController: MONUniformFlowLayoutDelegate {

    func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        if cellHeights.isValid(section) {
            return cellHeights[section]
        } else {
            let height = computeExpectedCellHeight(sizingCell, index: section, width: collectionView.width)
            cellHeights.append(height)
            return height
        }
    }

    func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, headerHeightInSection section: Int) -> CGFloat {
        return kNewsFeedHeaderViewDefaultHeight
    }
}

extension NewsFeedViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return displayItems.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = NewsFeedCell.dequeueFromCollectionView(collectionView, indexPath: indexPath)
        configureCell(cell, index: indexPath.section)
        cell.delegate = self
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = NewsFeedHeaderView.dequeueFromCollectionView(collectionView, indexPath: indexPath)
            configureHeaderView(headerView, index: indexPath.section)

            return headerView
        } else {
            let reuseId = "NewsFeedFooterView"
            let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseId, forIndexPath: indexPath)

            return reusableView
        }
    }
}
