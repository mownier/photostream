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

extension PhotoPickerViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollHandler.offsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ view: UIScrollView) {
        if scrollHandler.isScrollable {
            if scrollHandler.isScrollingDown {
                didScrollDown(with: abs(scrollHandler.offsetDelta))
            } else {
                if view.contentOffset.y < -(48 + 2) {
                    didScrollUp(with: abs(scrollHandler.offsetDelta))
                }
            }
            scrollHandler.update()
        }
    }
    
    func didScrollUp(with delta: CGFloat) {
        let sum = cropContentViewConstraintTop.constant + delta
        let newDelta = min(sum, 0)
        cropContentViewConstraintTop.constant = newDelta
    }
    
    func didScrollDown(with delta: CGFloat) {
        let diff = cropContentViewConstraintTop.constant - delta
        let newDelta = max(diff, -(collectionView.contentInset.top - 48))
        cropContentViewConstraintTop.constant = newDelta
    }
}
