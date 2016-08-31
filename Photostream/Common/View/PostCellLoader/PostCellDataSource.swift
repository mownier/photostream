//
//  PostCellDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

public class PostCellDataSource: NSObject, PostCellLoaderDataSourceProtocol {

    private var items: PostCellItemArray
    public var actionHander: PostCellActionHandler?

    init(items: PostCellItemArray) {
        self.items = items
    }


    public func appendContentsOf(array: PostCellItemArray) {
        items.appendContentsOf(array)
    }

    public subscript (index: Int) -> PostCellDisplayItemProtocol? {
        set {
            if let val = newValue as? PostCellItem {
                items[index] = val
            }
        }
        get {
            return items[index]
        }
    }

    public subscript (postId: String) -> (Int, PostCellDisplayItemProtocol)? {
        if let index = items[postId] {
            return (index, items[index]!)
        }
        return nil
    }

    public func updateLike(index: Int, state: Bool) -> Bool {
        if let _ = items[index] {
            return items[index]!.updateLike(state)
        }
        return false
    }

    public func likesCount(index: Int) -> Int {
        if let item = items[index] {
            return item.likesCount
        }
        return -1
    }
}

extension PostCellDataSource: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPostCellReuseId, forIndexPath: indexPath) as! PostCell
        if let item = items[indexPath.section] {
            configureCell(cell, item: item)
            cell.actionHandler = actionHander
        }
        return cell
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return items.count
    }

    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kPostHeaderViewReuseId, forIndexPath: indexPath) as! PostHeaderView
            if let item = items[indexPath.section] {
                configureHeaderView(headerView, item: item)
            }

            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kPostFooterViewReuseId, forIndexPath: indexPath) as! PostFooterView
            return footerView
        }
    }
}

extension PostCellDataSource: PostCellConfiguration {

    public func configureCell(cell: PostCell, item: PostCellItem) {
        cell.setPhotoUrl(item.photoUrl)
        cell.setLikesCountText(item.likes)
        cell.setCommentsCountText(item.comments)
        cell.setMessage(item.message, displayName: item.displayName)
        cell.setElapsedTime(item.timestamp.timeAgoSinceNow())
        cell.shouldHighlightLikeButton(item.isLiked)
    }

    public func configureHeaderView(view: PostHeaderView, item: PostCellItem) {
        let displayName = item.displayName
        let avatarUrl = item.avatarUrl
        let image = view.createAvatarPlaceholderImage(displayName[0])
        view.setDisplayName(displayName)
        view.setAvatarUrl(avatarUrl, placeholderImage: image)
    }
}
