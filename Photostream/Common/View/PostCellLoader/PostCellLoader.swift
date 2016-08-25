//
//  PostCellLoader.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

public protocol PostCellLoaderCallback {
    
    func postCellLoaderDidLikePost(postId: String)
    func postCellLoaderDidUnlikePost(postId: String)
    func postCellLoaderWillShowLikes(postId: String)
    func postCellLoaderWillShowComments(postId: String, shouldComment: Bool)
}

public protocol PostCellConfiguration {
    
    func configureHeaderView(view: PostHeaderView, item: PostCellItem)
    func configureCell(cell: PostCell, item: PostCellItem)
    subscript (index: Int) -> PostCellItem? { get }
    subscript (postId: String) -> (Int, PostCellItem)? { get }
}

public class PostCellLoader: AnyObject {

    private weak var collectionView: UICollectionView!
    private lazy var dataSource = PostCellDataSource(list: PostCellItemList())
    private lazy var delegate = PostCellDelegate()
    private lazy var flowLayout = MONUniformFlowLayout()
    public var callback: PostCellLoaderCallback!
    
    init(collectionView: UICollectionView) {
        self.dataSource.actionHander = self
        self.delegate.config = self.dataSource
        self.collectionView = collectionView
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self.delegate
        
        self.collectionView.registerNib(UINib(nibName: kPostCellNibName, bundle: nil), forCellWithReuseIdentifier: kPostCellReuseId)
        self.collectionView.registerNib(UINib(nibName: kPostHeaderViewNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kPostHeaderViewReuseId)
        self.collectionView.registerNib(UINib(nibName: kPostFooterViewReuseId, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kPostFooterViewReuseId)
    }
    
    deinit {
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }
    
    public func append(list: PostCellItemList) {
        dataSource.appendContentsOf(list)
    }
    
    public func reload() {
        collectionView.reloadData()
    }
    
    public func shouldEnableStickyHeader(should: Bool) {
        flowLayout.enableStickyHeader = should
    }
    
    public func reloadCell(postId: String, likeState: Bool) {
        if let (index, _) = dataSource[postId] {
            if dataSource[index]!.updateLike(likeState) {
                var newHeight: CGFloat = kPostCellCommonHeight + kPostCellCommonTop
                if dataSource[index]!.likesCount < 1 {
                    newHeight *= -1
                }
                delegate.updateCellHeight(index, height: newHeight)
                reload()
            }
        }
    }
    
    public subscript (cell: PostCell) -> PostCellItem? {
        if let indexPath = collectionView.indexPathForCell(cell) {
            let index = indexPath.section
            return dataSource[index]
        }
        return nil
    }
    
    private subscript (cell: PostCell, result: (PostCellItem) -> Void) -> Bool {
        if let item = self[cell] {
            result(item)
            return true
        }
        return false
    }
    
    private func performLoaderCallback(cell: PostCell, result: (PostCellItem) -> Void) {
        if let item = self[cell] {
            result(item)
        }
    }
}

extension PostCellLoader: PostCellActionHandler {
    
    public func postCellDidTapLike(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            if item.isLiked {
                self.callback.postCellLoaderDidUnlikePost(item.postId)
            } else {
                self.callback.postCellLoaderDidLikePost(item.postId)
            }
        }
    }
    
    public func postCellDidTapPhoto(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.callback.postCellLoaderDidLikePost(item.postId)
        }
    }
    
    public func postCellDidTapComment(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.callback.postCellLoaderWillShowComments(item.postId, shouldComment: true)
        }
    }
    
    public func postCellDidTapLikesCount(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.callback.postCellLoaderWillShowLikes(item.postId)
        }
    }
    
    public func postCellDidTapCommentsCount(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.callback.postCellLoaderWillShowComments(item.postId, shouldComment: false)
        }
    }
}
