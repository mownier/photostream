//
//  PhotoLibraryDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

extension PhotoLibraryViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PhotoGridCell.dequeue(from: collectionView, for: indexPath)
        configure(with: cell, at: indexPath.row)
        
        return cell
    }
}

extension PhotoLibraryViewController {
    
    func configure(with cell: PhotoGridCell, at index: Int) {
        cell.isSelected = selectedIndex >= 0 && selectedIndex == index
        presenter.fetchThumbnail(at: index, size: cellImageTargetSize) { (image) in
            cell.thumbnailImageView.image = image
        }
    }
    
    var cellImageTargetSize: CGSize {
        let scale = UIScreen.main.scale
        var size = CGSize()
        size.width = flowLayout.itemSize.width * scale
        size.height = flowLayout.itemSize.height * scale
        return size
    }
}
