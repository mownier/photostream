//
//  NewsFeedViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: MONUniformFlowLayout!

    var presenter: NewsFeedModuleInterface!
    var sizingCell: NewsFeedCell!
    var cellHeights = [CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerNib(UINib(nibName: "NewsFeedCell", bundle: nil), forCellWithReuseIdentifier: "NewsFeedCell")

        sizingCell = NewsFeedCell.createNew()
        addCustomTitleView()
        presenter.refreshFeed(10)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        flowLayout.enableStickyHeader = true
        collectionView.contentOffset = CGPoint(x: 0, y: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func addCustomTitleView() {
        let titleView = UILabel(frame: CGRect.zero)
        let fontDesc = UIFontDescriptor(name: "Snell Roundhand", size: 24).fontDescriptorWithSymbolicTraits(.TraitBold)
        titleView.font = UIFont(descriptor: fontDesc, size: fontDesc.pointSize)
        titleView.text = "Photostream"
        titleView.sizeToFit()
        navigationItem.titleView = titleView
    }

    private func configureCell(cell: NewsFeedCell, index: Int) {
        let (post, user) = presenter.getPostAtIndex(UInt(index))
        cell.setPhotoUrl(post.photo.url)
        cell.setLikesCount(post.likesCount)
        cell.setCommentsCount(post.commentsCount)
        cell.setMessage(post.message, displayName: user.displayName)
        cell.setElapsedTime(post.timestamp)
    }
    
    private func computeExpectedCellHeight(cell: NewsFeedCell!, index: Int!) -> CGFloat {
        configureCell(cell, index: index)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }

    private func computeExpectedPhotoHeight(index: Int!, width: CGFloat) -> CGFloat {
        let (post, _) = presenter.getPostAtIndex(UInt(index))

        let photoWidth = post.photo.width
        let photoHeight = post.photo.height

        let ratio = width / CGFloat(photoWidth)
        return  CGFloat(photoHeight) * ratio
    }
}

extension NewsFeedViewController: NewsFeedViewInterface {

    func reloadView() {
        collectionView.reloadData()
    }

    func showEmptyView() {
        // TODO: Show empty view
    }
}

extension NewsFeedViewController: NewsFeedCellDelegate {

    func newsFeedCellDidTapLike(cell: NewsFeedCell) {

    }

    func newsFeedCellDidTapLikesCount(cell: NewsFeedCell) {

    }

    func newsFeedCellDidTapComment(cell: NewsFeedCell) {

    }

    func newsFeedCellDidTapCommentsCount(cell: NewsFeedCell) {

    }
}

extension NewsFeedViewController: MONUniformFlowLayoutDelegate {

    func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        if cellHeights.isValid(section) {
            return cellHeights[section]
        } else {
            let cellHeight = computeExpectedCellHeight(sizingCell, index: section)
            let photoHeight = computeExpectedPhotoHeight(section, width: collectionView.width)
            let height = photoHeight + cellHeight
            cellHeights.append(height)
            return height
        }
    }

    func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, headerHeightInSection section: Int) -> CGFloat {
        return 54
    }
}

extension NewsFeedViewController: UICollectionViewDelegate {

}


extension NewsFeedViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return presenter.feedCount
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsFeedCell", forIndexPath: indexPath) as! NewsFeedCell

        configureCell(cell, index: indexPath.section)
        cell.delegate = self

        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        var reuseId: String!
        if kind == UICollectionElementKindSectionHeader {
            reuseId = "NewsFeedHeaderView"
        } else {
            reuseId = "NewsFeedFooterView"
        }

        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseId, forIndexPath: indexPath)

        if reuseId == "NewsFeedHeaderView" {
            let headerView = reusableView as! NewsFeedHeaderView
            let i = UInt(indexPath.section)
            let (_, user) = presenter.getPostAtIndex(i)
            let placeholderImage = headerView.createAvatarPlaceholderImage(user.firstName[0])
            headerView.setDisplayName(user.fullName)
            headerView.setAvatarUrl("", placeholderImage: placeholderImage)
        }

        return reusableView
    }
}
