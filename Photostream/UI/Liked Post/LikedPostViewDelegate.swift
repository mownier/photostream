//
//  LikedPostViewDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension LikedPostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = presenter.post(at: indexPath.section) as? PostListCollectionCellItem
        prototype.configure(with: item, isPrototype: true)
        let size = CGSize(width: listLayout.itemSize.width, height: prototype.dynamicHeight)
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.section == presenter.postCount - 10 else {
            return
        }
        
        presenter.loadMore()
    }
}

extension LikedPostViewController: PostListCollectionCellDelegate {
    
    func didTapPhoto(cell: PostListCollectionCell) {
        guard let index = collectionView?.indexPath(for: cell)?.section else {
            return
        }
        
        presenter.likePost(at: index)
    }
    
    func didTapHeart(cell: PostListCollectionCell) {
        guard let index = collectionView?.indexPath(for: cell)?.section,
            let isLiked = presenter.post(at: index)?.isLiked else {
            return
        }
        
        cell.toggleHeart(liked: isLiked) { [weak self] in
            self?.presenter.toggleLike(at: index)
        }
    }
    
    func didTapComment(cell: PostListCollectionCell) {
         guard let index = collectionView?.indexPath(for: cell)?.section else {
            return
        }
        
        presenter.presentCommentController(at: index, shouldComment: true)
    }
    
    func didTapCommentCount(cell: PostListCollectionCell) {
        guard let index = collectionView?.indexPath(for: cell)?.section else {
            return
        }
        
        presenter.presentCommentController(at: index)
    }
    
    func didTapLikeCount(cell: PostListCollectionCell) {
        guard let index = collectionView?.indexPath(for: cell)?.section else {
            return
        }
        
        presenter.presentPostLikes(at: index)
    }
}

extension LikedPostViewController: PostListCollectionHeaderDelegate {
    
    func didTapDisplayName(header: PostListCollectionHeader, point: CGPoint) {
        willPresentUserTimeline(header: header, point: point)
    }
    
    func didTapAvatar(header: PostListCollectionHeader, point: CGPoint) {
        willPresentUserTimeline(header: header, point: point)
    }
    
    private func willPresentUserTimeline(header: PostListCollectionHeader, point: CGPoint) {
        guard collectionView != nil else {
            return
        }
        
        var relativePoint = collectionView!.convert(point, from: header)
        relativePoint.y += header.frame.height
        
        guard let index = collectionView!.indexPathForItem(at: relativePoint)?.section else {
            return
        }
        
        presenter.presentUserTimeline(at: index)
    }
}
