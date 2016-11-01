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
        return presenter.feeds.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PostListCell.dequeue(from: collectionView, at: indexPath)
        cell?.delegate = self
        return cell!
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
