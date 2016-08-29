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
    
    func recalculateCellHeight()
    func updateCellHeight(index: Int, height: CGFloat)
}

public enum PostCellLoaderType {
    case List
    case Grid
}

public class PostCellLoader: AnyObject {

    private weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDataSource!
    private var delegate: UICollectionViewDelegate!
    private var type: PostCellLoaderType = .List
    private lazy var flowLayout = MONUniformFlowLayout()
    
    public var listCellCallback: PostListCellLoaderCallback!
    public var gridCellCallback: PostGridCellLoaderCallback!
    
    init(collectionView: UICollectionView, type: PostCellLoaderType) {
        self.type = type
        self.collectionView = collectionView
        self.collectionView.collectionViewLayout = flowLayout
        
        switch type {
        case .List:
            let listDataSource = PostCellDataSource(items: PostCellItemArray())
            listDataSource.actionHander = self
    
            let listDelegate = PostCellDelegate()
            listDelegate.config = listDataSource
            listDelegate.dataSource = listDataSource
            
            self.dataSource = listDataSource
            self.delegate = listDelegate
            
            self.collectionView.dataSource = listDataSource
            self.collectionView.delegate = listDelegate
            
            self.collectionView.registerNib(UINib(nibName: kPostCellNibName, bundle: nil), forCellWithReuseIdentifier: kPostCellReuseId)
            self.collectionView.registerNib(UINib(nibName: kPostHeaderViewNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kPostHeaderViewReuseId)
            self.collectionView.registerNib(UINib(nibName: kPostFooterViewReuseId, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kPostFooterViewReuseId)
            
            break
            
        case .Grid:
            let gridDataSource = PostGridCellDataSource(items: PostGridCellItemArray())
            let gridDelegate = PostGridCellDelegate(actionHandler: self)
            self.dataSource = gridDataSource
            self.delegate = gridDelegate
            self.collectionView.dataSource = gridDataSource
            self.collectionView.delegate = gridDelegate
            self.collectionView.registerNib(UINib(nibName: kPostGridCellNibName, bundle: nil), forCellWithReuseIdentifier: kPostGridCellReuseId)
            self.flowLayout.interItemSpacing = MONInterItemSpacingMake(4, 4)
            
            break
        }
    }
    
    deinit {
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }
    
    public func append<T>(items: T) {
        switch type {
        case .List:
            let listDataSource = dataSource as! PostCellDataSource
            let items = items as! PostCellItemArray
            listDataSource.appendContentsOf(items)
            break
        case .Grid:
            let gridDataSource = dataSource as! PostGridCellDataSource
            let items = items as! PostGridCellItemArray
            gridDataSource.appendContentsOf(items)
            break
        }
    }
    
    public func reload() {
        collectionView.reloadData()
    }
    
    public func recalculateCellHeight() {
        if let delegate = delegate as? PostCellLoaderDelegateProtocol {
            delegate.recalculateCellHeight()
        }
    }
    
    public func shouldEnableStickyHeader(should: Bool) {
        flowLayout.enableStickyHeader = should
    }
    
    public func reloadCell(postId: String, likeState: Bool) {
        switch type {
        case .List:
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
        case .Grid:
            break
        }
        
    }
    
    private subscript (cell: PostCell) -> PostCellItem? {
        if let dataSource = dataSource as? PostCellLoaderDataSourceProtocol {
            if let indexPath = collectionView.indexPathForCell(cell) {
                let index = indexPath.section
                return dataSource[index] as? PostCellItem
            }
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
                self.listCellCallback.postCellLoaderDidUnlikePost(item.postId)
            } else {
                self.listCellCallback.postCellLoaderDidLikePost(item.postId)
            }
        }
    }
    
    public func postCellDidTapPhoto(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderDidLikePost(item.postId)
        }
    }
    
    public func postCellDidTapComment(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderWillShowComments(item.postId, shouldComment: true)
        }
    }
    
    public func postCellDidTapLikesCount(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderWillShowLikes(item.postId)
        }
    }
    
    public func postCellDidTapCommentsCount(cell: PostCell) {
        performLoaderCallback(cell) { (item) in
            self.listCellCallback.postCellLoaderWillShowComments(item.postId, shouldComment: false)
        }
    }
}

extension PostCellLoader: PostGridCellActionHandler {
    
    public func postGridCellWillShowPostDetails(index: Int) {
        if let dataSource = dataSource as? PostCellLoaderDataSourceProtocol {
            if let item = dataSource[index] {
                gridCellCallback.postCellLoaderWillShowPostDetails(item.postId)
            }
        }
    }
}
