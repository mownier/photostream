//
//  UserPostViewDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UserPostViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch sceneType {
        case .grid:
            return 1
            
        case .list:
            return presenter.postCount
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sceneType {
        case .grid:
            return presenter.postCount
            
        case .list:
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sceneType {
        case .grid:
            let cell = PostGridCollectionCell.dequeue(from: collectionView, for: indexPath)!
            let item = presenter.post(at: indexPath.row) as? PostGridCollectionCellItem
            cell.configure(with: item)
            return cell
            
        case .list:
            let cell = PostListCollectionCell.dequeue(from: collectionView, for: indexPath)!
            let item = presenter.post(at: indexPath.section) as? PostListCollectionCellItem
            cell.configure(with: item)
            cell.delegate = self
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader where sceneType == .list:
            let header = PostListCollectionHeader.dequeue(from: collectionView, for: indexPath)!
            let item = presenter.post(at: indexPath.section) as? PostListCollectionHeaderItem
            header.configure(with: item)
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}
