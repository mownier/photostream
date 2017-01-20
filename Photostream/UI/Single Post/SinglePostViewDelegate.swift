//
//  SinglePostViewDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension SinglePostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = presenter.postData as? PostListCollectionCellItem
        prototype.configure(with: item, isPrototype: true)
        let size = CGSize(width: listLayout.itemSize.width, height: prototype.dynamicHeight)
        return size
    }
}

extension SinglePostViewController: PostListCollectionCellDelegate {
    
    func didTapPhoto(cell: PostListCollectionCell) {
        presenter.likePost()
    }
    
    func didTapHeart(cell: PostListCollectionCell) {
        guard let isLiked = presenter.postData?.isLiked else {
            return
        }
        
        cell.toggleHeart(liked: isLiked) { [weak self] in
            self?.presenter.toggleLike()
        }
    }
    
    func didTapComment(cell: PostListCollectionCell) {
        presenter.presentCommentController(shouldComment: true)
    }
    
    func didTapCommentCount(cell: PostListCollectionCell) {
        presenter.presentCommentController()
    }
    
    func didTapLikeCount(cell: PostListCollectionCell) {
        presenter.presentPostLikes()
    }
}

extension SinglePostViewController: PostListCollectionHeaderDelegate {
    
    func didTapDisplayName(header: PostListCollectionHeader, point: CGPoint) {
        presenter.presentUserTimeline()
    }
    
    func didTapAvatar(header: PostListCollectionHeader, point: CGPoint) {
        presenter.presentUserTimeline()
    }
}
