//
//  LikedPostViewDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension LikedPostViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.postCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PostListCollectionCell.dequeue(from: collectionView, for: indexPath)!
        let item = presenter.post(at: indexPath.section) as? PostListCollectionCellItem
        cell.configure(with: item)
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let header = PostListCollectionHeader.dequeue(from: collectionView, for: indexPath)!
            let item = presenter.post(at: indexPath.section) as? PostListCollectionHeaderItem
            header.configure(with: item)
            header.delegate = self
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

