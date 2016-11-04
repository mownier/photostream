//
//  UICollectionViewCellSizeHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct UICollectionViewCellSizeHandler {
    
    var sizingCell: [String: UICollectionViewCell] = [String: UICollectionViewCell]()
    var computedSize: [String: CGSize] = [String: CGSize]()
    
    mutating func compute(for key: String, with reuseId: String, and targetWidth: CGFloat, config: (UICollectionViewCell) -> Void) -> CGSize {
        guard computedSize[key] == nil else {
            return computedSize[key]!
        }
        
        guard let cell = sizingCell[reuseId] else {
            return .zero
        }
        
        config(cell)
        cell.bounds = CGRect(x: 0, y: 0, width: targetWidth, height: cell.bounds.height)
        cell.contentView.bounds = cell.bounds
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        var size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        size.width = targetWidth
        
        computedSize[key] = size
        
        return size
    }
    
    mutating func register(cell: UICollectionViewCell, for reuseId: String) {
        sizingCell[reuseId] = cell
    }
    
    mutating func recompute() {
        computedSize.removeAll()
    }
}
