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
        guard let asset = presenter.photo(at: indexPath.row) else {
            return
        }
        
        showSelectedPhoto(with: asset)
    }
}
