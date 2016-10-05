//
//  PostCellLoader.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

public typealias PostCellLoaderItemArray = PostCellDisplayItemArray<PostCellDisplayItemProtocol>

public protocol PostCellLoaderDataSourceProtocol {

    subscript(index: Int) -> PostCellDisplayItemProtocol? { get set }
    subscript(postId: String) -> (Int, PostCellDisplayItemProtocol)? { get }
}

public protocol PostCellLoaderDelegateProtocol {

    var scrollProtocol: PostCellLoaderScrollProtocol? { get set }
    func recalculateCellHeight()
    func updateCellHeight(_ index: Int, height: CGFloat)
}

public protocol PostCellLoaderScrollProtocol {

    func didScroll(_ view: UIScrollView)
    func willBeginDragging(_ view: UIScrollView)
}

public enum PostCellLoaderType {
    case list
    case grid
}

open class PostCellLoader: AnyObject {

    fileprivate weak var collectionView: UICollectionView!
    fileprivate var dataSource: UICollectionViewDataSource!
    fileprivate var delegate: UICollectionViewDelegate!
    fileprivate var type: PostCellLoaderType = .list
    fileprivate var lastContentOffsetY: CGFloat = 0
    fileprivate lazy var flowLayout = MONUniformFlowLayout()

    open var listCellCallback: PostListCellLoaderCallback!
    open var gridCellCallback: PostGridCellLoaderCallback!
    open var scrollCallback: PostCellLoaderScrollCallback?
    open var contentOffset: CGPoint {
        return collectionView.contentOffset
    }

    init(collectionView: UICollectionView, type: PostCellLoaderType) {
        self.type = type
        self.collectionView = collectionView
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.alwaysBounceVertical = true
        switch type {
        case .list:
            let listDataSource = PostCellDataSource(items: PostCellItemArray())
            listDataSource.actionHander = self

            let listDelegate = PostCellDelegate()
            listDelegate.config = listDataSource
            listDelegate.dataSource = listDataSource
            listDelegate.scrollProtocol = self

            self.dataSource = listDataSource
            self.delegate = listDelegate

            self.collectionView.dataSource = listDataSource
            self.collectionView.delegate = listDelegate

            self.collectionView.register(UINib(nibName: kPostCellNibName, bundle: nil), forCellWithReuseIdentifier: kPostCellReuseId)
            self.collectionView.register(UINib(nibName: kPostHeaderViewNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kPostHeaderViewReuseId)
            self.collectionView.register(UINib(nibName: kPostFooterViewReuseId, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kPostFooterViewReuseId)

            break

        case .grid:
            let gridDataSource = PostGridCellDataSource(items: PostGridCellItemArray())
            let gridDelegate = PostGridCellDelegate(actionHandler: self)
            gridDelegate.scrollProtocol = self
            self.dataSource = gridDataSource
            self.delegate = gridDelegate
            self.collectionView.dataSource = gridDataSource
            self.collectionView.delegate = gridDelegate
            self.collectionView.register(UINib(nibName: kPostGridCellNibName, bundle: nil), forCellWithReuseIdentifier: kPostGridCellReuseId)
            self.flowLayout.interItemSpacing = MONInterItemSpacingMake(4, 4)

            break
        }
    }

    deinit {
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }

    open func append<T>(_ items: T) {
        switch type {
        case .list:
            let listDataSource = dataSource as! PostCellDataSource
            let items = items as! PostCellItemArray
            listDataSource.appendContentsOf(items)
            break
        case .grid:
            let gridDataSource = dataSource as! PostGridCellDataSource
            let items = items as! PostGridCellItemArray
            gridDataSource.appendContentsOf(items)
            break
        }
    }

    open func reload() {
        collectionView.reloadData()
    }

    open func recalculateCellHeight() {
        if let delegate = delegate as? PostCellLoaderDelegateProtocol {
            delegate.recalculateCellHeight()
        }
    }

    open func shouldEnableStickyHeader(_ should: Bool) {
        flowLayout.enableStickyHeader = should
    }

    open func reloadCell(_ postId: String, likeState: Bool) {
        switch type {
        case .list:
            let listDataSource = dataSource as! PostCellDataSource
            if let (index, _) = listDataSource[postId] {
                if listDataSource.updateLike(index, state: likeState) {
                    var newHeight: CGFloat = kPostCellCommonHeight + kPostCellCommonTop
                    if listDataSource.likesCount(index) < 1 {
                        newHeight *= -1
                    }
                    if let delegate = delegate as? PostCellLoaderDelegateProtocol {
                        delegate.updateCellHeight(index, height: newHeight)
                    }
                    reload()
                }
            }
            break
        case .grid:
            break
        }

    }

    open func isContentScrollable() -> Bool {
        return collectionView.contentSize.height > collectionView.height
    }

    open func killScroll() {
        updateContentOffset(collectionView.contentOffset, animated: false)
    }

    open func updateContentOffset(_ offset: CGPoint, animated: Bool) {
        collectionView.setContentOffset(offset, animated: animated)
    }

    fileprivate subscript (cell: PostCell) -> PostCellItem? {
        if let dataSource = dataSource as? PostCellLoaderDataSourceProtocol {
            if let indexPath = collectionView.indexPath(for: cell) {
                let index = (indexPath as NSIndexPath).section
                return dataSource[index] as? PostCellItem
            }
        }
        return nil
    }

    fileprivate subscript (cell: PostCell, result: (PostCellItem) -> Void) -> Bool {
        if let item = self[cell] {
            result(item)
            return true
        }
        return false
    }

    fileprivate func performLoaderCallback(_ cell: PostCell, result: (PostCellItem) -> Void) {
        if let item = self[cell] {
            result(item)
        }
    }
}

extension PostCellLoader: PostCellActionHandler {

    public func postCellDidTapLike(_ cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            if item.isLiked {
                self.listCellCallback.postCellLoaderDidUnlikePost(item.postId)
            } else {
                self.listCellCallback.postCellLoaderDidLikePost(item.postId)
            }
        }
    }

    public func postCellDidTapPhoto(_ cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderDidLikePost(item.postId)
        }
    }

    public func postCellDidTapComment(_ cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderWillShowComments(item.postId, shouldComment: true)
        }
    }

    public func postCellDidTapLikesCount(_ cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderWillShowLikes(item.postId)
        }
    }

    public func postCellDidTapCommentsCount(_ cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderWillShowComments(item.postId, shouldComment: false)
        }
    }
}

extension PostCellLoader: PostGridCellActionHandler {

    public func postGridCellWillShowPostDetails(_ index: Int) {
        if let dataSource = dataSource as? PostCellLoaderDataSourceProtocol {
            if let item = dataSource[index] {
                gridCellCallback.postCellLoaderWillShowPostDetails(item.postId)
            }
        }
    }
}

extension PostCellLoader: PostCellLoaderScrollProtocol {

    public func didScroll(_ view: UIScrollView) {
        if isContentScrollable() {
            let currentOffsetY = view.contentOffset.y
            if let callback = scrollCallback {
                let delta = abs(lastContentOffsetY) - abs(currentOffsetY)
                if lastContentOffsetY > currentOffsetY && lastContentOffsetY < (view.contentSize.height - view.height) {
                    callback.postCellLoaderDidScrollUp(abs(delta), loader: self)
                } else if lastContentOffsetY < currentOffsetY && currentOffsetY > -(view.contentInset.top + view.contentInset.bottom) {
                    callback.postCellLoaderDidScrollDown(abs(delta), loader: self)
                }
            }
            lastContentOffsetY = currentOffsetY
        }
    }

    public func willBeginDragging(_ view: UIScrollView) {
        lastContentOffsetY = view.contentOffset.y
    }
}
