//
//  PhotoPickerDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoPickerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.willShowSelectedPhoto(at: indexPath.row, size: selectedPhotoSize)
    }
}

extension PhotoPickerViewController {
    
    var selectedPhotoSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: cropView.bounds.width * scale,
                      height: cropView.bounds.height * scale)
    }
}
