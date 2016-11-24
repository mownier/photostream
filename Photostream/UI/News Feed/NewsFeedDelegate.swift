//
//  NewsFeedDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

extension NewsFeedViewController: MONUniformFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        let item = presenter.feed(at: section)
        let maxWidth = collectionView.width
        
        switch item {
        case let post as NewsFeedPost?:
            return computeCellHeight(for: post, with: maxWidth)
        
        case let ad as NewsFeedAd?:
            return computeCellHeight(for: ad, with: maxWidth)
            
        default:
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, headerHeightInSection section: Int) -> CGFloat {
        return kPostListHeaderDefaultHeight
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, footerHeightInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == presenter.feedCount - 1 {
            presenter.loadMoreFeeds()
        }
    }
}

extension NewsFeedViewController {
    
    func computeCellHeight(for item: NewsFeedPost?, with maxWidth: CGFloat) -> CGFloat {
        guard let post = item else {
            return 0.0
        }
        
        let size = sizeHandler.compute(for: post.id, with: kPostListCellReuseId) { (prototype) -> CGSize in
            let cell = prototype as! PostListCell
            cell.configure(for: post, isPrototype: true)
            
            var targetSize = CGSize()
            targetSize.width = maxWidth
            targetSize.height = cell.bounds.height
            
            return targetSize
        }
        let ratio = maxWidth / CGFloat(post.photoWidth)
        let photoHeight = CGFloat(post.photoHeight) * ratio
        
        return size.height + photoHeight
    }
    
    func computeCellHeight(for item: NewsFeedAd?, with maxWidth: CGFloat) -> CGFloat {
        return 0.0
    }
}

extension NewsFeedViewController {
    
    func scrollViewWillBeginDragging(_ view: UIScrollView) {
        scrollHandler.offsetY = view.contentOffset.y
    }
    
    func scrollViewDidScroll(_ view: UIScrollView) {
        if scrollHandler.isScrollable {
            if scrollHandler.isScrollingUp {
                didScrollUp(with: scrollHandler.offsetDelta)
            } else if scrollHandler.isScrollingDown {
                didScrollDown(with: scrollHandler.offsetDelta)
            }
            scrollHandler.update()
        }
    }
    
    func didScrollUp(with delta: CGFloat) {

    }
    
    func didScrollDown(with delta: CGFloat) {

    }
}

extension NewsFeedViewController: PostListCellDelegate {
    
    func postListCellDidTapLike(cell: PostListCell) {
        guard let post = post(for: cell) else {
            return
        }
        
        if post.isLiked {
            presenter.unlike(post: post.id)
            cell.shouldHighlightLikeButton(false)
        } else {
            presenter.like(post: post.id)
            cell.showAnimatedHeart {}
            cell.shouldHighlightLikeButton(true)
            cell.animateLikeButton()
        }
    }
    
    func postListCellDidTapLikesCount(cell: PostListCell) {
    
    }
    
    func postListCollectionCellDidTapLikesCount(cell: PostListCell) {
        
    }
    
    func postListCellDidTapComment(cell: PostListCell) {
        
    }
    
    func postListCellDidTapCommentsCount(cell: PostListCell) {
        
    }
    
    func postListCellDidTapPhoto(cell: PostListCell) {
        guard let post = post(for: cell) else {
            return
        }
        
        presenter.like(post: post.id)
    }
}

extension NewsFeedViewController {
    
    func post(for cell: PostListCell) -> NewsFeedPost? {
        guard let indexPath = collectionView[cell],
            let post = presenter.feed(at: indexPath.section) as? NewsFeedPost else {
                return nil
        }
        
        return post
    }
}
