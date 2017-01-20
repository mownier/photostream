//
//  NewsFeedDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension NewsFeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == presenter.feedCount - 10 {
            presenter.loadMoreFeeds()
        }
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = presenter.feed(at: indexPath.section) as? PostListCollectionCellItem
        prototype.configure(with: item, isPrototype: true)
        let size = CGSize(width: listLayout.itemSize.width, height: prototype.dynamicHeight)
        return size
    }
}

extension NewsFeedViewController: PostListCollectionCellDelegate {
    
    func didTapPhoto(cell: PostListCollectionCell) {
        guard let index = collectionView[cell]?.section else {
            return
        }
        
        presenter.likePost(at: index)
    }
    
    func didTapHeart(cell: PostListCollectionCell) {
        guard let index = collectionView[cell]?.section,
            let post = presenter.feed(at: index) as? NewsFeedPost else {
                return
        }
        
        cell.toggleHeart(liked: post.isLiked) { [unowned self] in
            self.presenter.toggleLike(at: index)
        }
    }
    
    func didTapComment(cell: PostListCollectionCell) {
        guard let index = collectionView[cell]?.section else {
            return
        }
        
        presenter.presentCommentController(at: index, shouldComment: true)
    }
    
    func didTapCommentCount(cell: PostListCollectionCell) {
        guard let index = collectionView[cell]?.section else {
            return
        }
        
        presenter.presentCommentController(at: index)
    }
    
    func didTapLikeCount(cell: PostListCollectionCell) {
        guard let index = collectionView[cell]?.section else {
            return
        }
        
        presenter.presentPostLikes(at: index)
    }
}

extension NewsFeedViewController: PostListCollectionHeaderDelegate {
    
    func didTapDisplayName(header: PostListCollectionHeader, point: CGPoint) {
        willPresentUserTimeline(header: header, point: point)
    }
    
    func didTapAvatar(header: PostListCollectionHeader, point: CGPoint) {
        willPresentUserTimeline(header: header, point: point)
    }
    
    private func willPresentUserTimeline(header: PostListCollectionHeader, point: CGPoint) {
        var relativePoint = collectionView.convert(point, from: header)
        relativePoint.y += header.frame.height
        guard let indexPath = collectionView.indexPathForItem(at: relativePoint) else {
            return
        }
        
        presenter.presentUserTimeline(at: indexPath.section)
    }
}
