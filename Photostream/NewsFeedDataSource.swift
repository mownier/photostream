//
//  NewsFeedDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension NewsFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.feedCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = presenter.feed(at: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch item {
        case let post as NewsFeedPost:
            guard let cell = PostListCell.dequeue(from: collectionView, at: indexPath) else {
                return UICollectionViewCell()
            }
            
            configure(cell, for: post)
            return cell
            
        case is NewsFeedAd:
            fallthrough
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = PostListHeader.dequeue(from: collectionView, at: indexPath)
            return header!
        case UICollectionElementKindSectionFooter:
            let footer = PostListFooter.dequeue(from: collectionView, at: indexPath)
            return footer!
        default:
            return UICollectionReusableView()
        }
    }
}

extension NewsFeedViewController {
    
    func configure(_ cell: PostListCell, for item: NewsFeedPost) {
        cell.setMessage(with: item.message, and: item.displayName)
        cell.setPhoto(with: item.photoUrl)
        cell.elapsedTime = item.timeAgo
        
        cell.shouldHighlightLikeButton(item.isLiked)
        cell.likesCountText = item.likesText
        cell.commentsCountText = item.commentsText
        
        cell.delegate = self
    }
}
