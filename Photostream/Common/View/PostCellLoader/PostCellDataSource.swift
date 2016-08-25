//
//  PostCellDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

public class PostCellDataSource: NSObject, UICollectionViewDataSource, PostCellConfiguration {
    
    private var list: PostCellItemList
    public var actionHander: PostCellActionHandler?
    
    init(list: PostCellItemList) {
        self.list = list
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPostCellReuseId, forIndexPath: indexPath) as! PostCell
        if let item = list[indexPath.section] {
            configureCell(cell, item: item)
            cell.actionHandler = actionHander
        }
        return cell
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return list.count
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kPostHeaderViewReuseId, forIndexPath: indexPath) as! PostHeaderView
            if let item = list[indexPath.section] {
                configureHeaderView(headerView, item: item)
            }
            
            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kPostFooterViewReuseId, forIndexPath: indexPath) as! PostFooterView
            return footerView
        }
    }
    
    public func appendContentsOf(items: PostCellItemList) {
        list.appendContentsOf(items)
    }
    
    public func configureCell(cell: PostCell, item: PostCellItem) {
        cell.setPhotoUrl(item.photoUrl)
        cell.setLikesCountText(item.likes)
        cell.setCommentsCountText(item.comments)
        cell.setMessage(item.message, displayName: item.displayName)
        cell.setElapsedTime(item.timestamp.timeAgoSinceNow())
        cell.shouldHighlightLikeButton(item.isLiked)
    }
    
    public subscript (index: Int) -> PostCellItem? {
        set {
            list[index] = newValue
        }
        get {
            return list[index]
        }
    }
    
    public subscript (postId: String) -> (Int, PostCellItem)? {
        if let index = list[postId] {
            return (index, list[index]!)
        }
        return nil
    }
    
    public func configureHeaderView(view: PostHeaderView, item: PostCellItem) {
        let displayName = item.displayName
        let avatarUrl = item.avatarUrl
        let image = view.createAvatarPlaceholderImage(displayName[0])
        view.setDisplayName(displayName)
        view.setAvatarUrl(avatarUrl, placeholderImage: image)
    }
}

