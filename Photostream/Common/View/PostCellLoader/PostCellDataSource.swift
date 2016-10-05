//
//  PostCellDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

open class PostCellDataSource: NSObject, PostCellLoaderDataSourceProtocol {

    fileprivate var items: PostCellItemArray
    open var actionHander: PostCellActionHandler?

    init(items: PostCellItemArray) {
        self.items = items
    }


    open func appendContentsOf(_ array: PostCellItemArray) {
        items.appendContentsOf(array)
    }

    open subscript (index: Int) -> PostCellDisplayItemProtocol? {
        set {
            if let val = newValue as? PostCellItem {
                items[index] = val
            }
        }
        get {
            return items[index]
        }
    }

    open subscript (postId: String) -> (Int, PostCellDisplayItemProtocol)? {
        if let index = items[postId] {
            return (index, items[index]!)
        }
        return nil
    }

    open func updateLike(_ index: Int, state: Bool) -> Bool {
        if let _ = items[index] {
            return items[index]!.updateLike(state)
        }
        return false
    }

    open func likesCount(_ index: Int) -> Int {
        if let item = items[index] {
            return item.likesCount
        }
        return -1
    }
}

extension PostCellDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPostCellReuseId, for: indexPath) as! PostCell
        if let item = items[(indexPath as NSIndexPath).section] {
            configureCell(cell, item: item)
            cell.actionHandler = actionHander
        }
        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPostHeaderViewReuseId, for: indexPath) as! PostHeaderView
            if let item = items[(indexPath as NSIndexPath).section] {
                configureHeaderView(headerView, item: item)
            }

            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPostFooterViewReuseId, for: indexPath) as! PostFooterView
            return footerView
        }
    }
}

extension PostCellDataSource: PostCellConfiguration {

    public func configureCell(_ cell: PostCell, item: PostCellItem) {
        cell.setPhotoUrl(item.photoUrl)
        cell.setLikesCountText(item.likes)
        cell.setCommentsCountText(item.comments)
        cell.setMessage(item.message, displayName: item.displayName)
        cell.setElapsedTime((item.timestamp as NSDate).timeAgoSinceNow())
        cell.shouldHighlightLikeButton(item.isLiked)
    }

    public func configureHeaderView(_ view: PostHeaderView, item: PostCellItem) {
        let displayName = item.displayName
        let avatarUrl = item.avatarUrl
        let image = view.createAvatarPlaceholderImage(displayName[0])
        view.setDisplayName(displayName)
        view.setAvatarUrl(avatarUrl, placeholderImage: image)
    }
}
