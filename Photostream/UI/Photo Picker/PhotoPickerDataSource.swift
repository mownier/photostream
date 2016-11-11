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
        let manager = PHImageManager.default()
        let asset = presenter.photo(at: indexPath.row)
        let targetSize = CGSize(width: 100, height: 100)
        manager.requestImage(for: asset!, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
            cell.thumbnailImageView.image = image
        }
        return cell
    }
}
