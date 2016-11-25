//
//  PhotoLibraryDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoLibraryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        presenter.willShowSelectedPhoto(at: selectedIndex, size: selectedPhotoSize)
    }
}

extension PhotoLibraryViewController {
    
    var selectedPhotoSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: cropView.bounds.width * scale,
                      height: cropView.bounds.height * scale)
    }
}

extension PhotoLibraryViewController {
    
    func scrollViewDidScroll(_ view: UIScrollView) {
        guard let scrollView = scrollHandler.scrollView,
            scrollView == view,
            scrollHandler.isScrollable else {
            return
        }
        
        if !dimView.isHidden {
            dimView.alpha = min(scrollHandler.percentageOffsetY, 0.5)
        }
        
        switch scrollHandler.direction {
        case .down:
            didScrollDown(with: abs(scrollHandler.offsetDelta))
        case .up, .none:
            didScrollUp(with: abs(scrollHandler.offsetDelta), offsetY: view.contentOffset.y)
        }
        
        scrollHandler.update()
    }
    
    func didScrollUp(with delta: CGFloat, offsetY: CGFloat = 0) {
        guard offsetY < -(48 + 2) else {
            return
        }
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
