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
        
        let item = presenter.feed(at: indexPath.section)
        
        switch item {
        case let post as NewsFeedPost?:
            return cell(from: collectionView, at: indexPath, for: post)
        
        case let ad as NewsFeedAd?:
            return cell(from: collectionView, at: indexPath, for: ad)
            
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let item = presenter.feed(at: indexPath.section)
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            return header(from: collectionView, at: indexPath, for: item as! NewsFeedPost?)
        case UICollectionElementKindSectionFooter:
            let footer = PostListFooter.dequeue(from: collectionView, at: indexPath)
            return footer!
        default:
            return UICollectionReusableView()
        }
    }
}

extension NewsFeedViewController {
    
    func cell(from collectionView: UICollectionView, at indexPath: IndexPath, for item: NewsFeedAd?) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func cell(from collectionView: UICollectionView, at indexPath: IndexPath, for item: NewsFeedPost?) -> UICollectionViewCell {
        guard let cell = PostListCell.dequeue(from: collectionView, at: indexPath), let post = item else {
            return UICollectionViewCell()
        }
        
        configure(with: cell, for: post)
        return cell
    }
    
    func configure(with cell: PostListCell, for item: NewsFeedPost) {
        cell.setMessage(with: item.message, and: item.displayName)
        cell.setPhoto(with: item.photoUrl)
        cell.elapsedTime = item.timeAgo
        
        cell.shouldHighlightLikeButton(item.isLiked)
        cell.likesCountText = item.likesText
        cell.commentsCountText = item.commentsText
        
        cell.delegate = self
    }
    
    func header(from collectionView: UICollectionView, at indexPath: IndexPath, for item: NewsFeedPost?) -> UICollectionReusableView {
        guard let header = PostListHeader.dequeue(from: collectionView, at: indexPath), let post = item else {
            return UICollectionReusableView()
        }
        
        configure(with: header, for: post)
        return header
    }
    
    func configure(with header: PostListHeader, for item: NewsFeedPost) {
        let placeholder = header.createAvatarPlaceholderImage(with: item.displayName[0])
        header.displayName = item.displayName
        header.setAvatar(with: item.avatarUrl, and: placeholder)
    }
}
