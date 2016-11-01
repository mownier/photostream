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
        // TODO: Compute item height
        return UICollectionViewFlowLayoutAutomaticSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, headerHeightInSection section: Int) -> CGFloat {
        return kPostListHeaderDefaultHeight
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, footerHeightInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension NewsFeedViewController {
    
    func scrollViewWillBeginDragging(_ view: UIScrollView) {
        scrollHandler.prevContentOffsetY = view.contentOffset.y
        scrollHandler.nextContentOffsetY = view.contentOffset.y
    }
    
    func scrollViewDidScroll(_ view: UIScrollView) {
        if scrollHandler.isScrollable {
            scrollHandler.nextContentOffsetY = view.contentOffset.y
            if scrollHandler.isScrollingUp() {
                didScrollUp(with: scrollHandler.offsetDelta)
            } else if scrollHandler.isScrollingDown() {
                didScrollDown(with: scrollHandler.offsetDelta)
            }
            scrollHandler.prevContentOffsetY = scrollHandler.nextContentOffsetY
        }
    }
    
    func didScrollUp(with delta: CGFloat) {
        print("NewsFeedViewController: didScrollUp with", delta)
    }
    
    func didScrollDown(with delta: CGFloat) {
        print("NewsFeedViewController: didScrollDown with", delta)
    }
}

extension NewsFeedViewController: PostListCellDelegate {
    
    func postListCellDidTapLike(cell: PostListCell) {
        
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
        
    }
}
