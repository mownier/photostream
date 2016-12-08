//
//  UserPostListViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserPostListViewController: UserPostGridViewController {

    lazy var prototype: PostListCollectionCell! = PostListCollectionCell()
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.postCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = PostListCollectionHeader.dequeue(from: collectionView, for: indexPath)!
            let item = presenter.post(at: indexPath.section) as? PostListCollectionHeaderItem
            header.configure(with: item)
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PostListCollectionCell.dequeue(from: collectionView, for: indexPath)!
        let item = presenter.post(at: indexPath.section) as? PostListCollectionCellItem
        cell.configure(with: item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.section == presenter.postCount - 10 else {
            return
        }
        
        presenter.loadMorePosts()
    }
    
    override func configureFlowLayout(with size: CGSize) {
        flowLayout.configure(with: size.width, columnCount: 1)
        flowLayout.headerReferenceSize = CGSize(width: size.width, height: 48)
        flowLayout.sectionHeadersPinToVisibleBounds = true
        prototype.contentView.bounds.size.width = flowLayout.itemSize.width
    }
    
    override func registerCell() {
        PostListCollectionCell.register(in: collectionView!)
        PostListCollectionHeader.register(in: collectionView!)
    }
}

extension UserPostListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = presenter.post(at: indexPath.section) as? PostListCollectionCellItem
        prototype.configure(with: item, isPrototype: true)
        let size = CGSize(width: flowLayout.itemSize.width, height: prototype.dynamicHeight)
        return size
    }
}
