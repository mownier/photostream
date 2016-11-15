//
//  PhotoPickerDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

extension PhotoPickerViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PhotoGridCell.dequeue(from: collectionView, for: indexPath)
        presenter.requestImage(at: indexPath.row, size: cellImageTargetSize) { (image) in
            cell.thumbnailImageView.image = image
        }
        return cell
    }
}

extension PhotoPickerViewController {
    
    var cellImageTargetSize: CGSize {
        let scale = UIScreen.main.scale
        var size = CGSize()
        size.width = flowLayout.itemSize.width * scale
        size.height = flowLayout.itemSize.height * scale
        return size
    }
}
