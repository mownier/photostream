//
//  PostCellDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

public class PostCellDelegate: NSObject, MONUniformFlowLayoutDelegate {

    public var config: PostCellConfiguration!
    private var sizingCell: PostCell
    private var cellHeights: [CGFloat]
    
    override init() {
        let bundle = NSBundle.mainBundle()
        let views = bundle.loadNibNamed(kPostCellNibName, owner: nil, options: nil)
        self.sizingCell = views[0] as! PostCell
        self.cellHeights = [CGFloat]()
    }
    
    public func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        if cellHeights.isValid(section) {
            return cellHeights[section]
        } else {
            let height = computeExpectedCellHeight(section, width: collectionView.width)
            cellHeights.append(height)
            return height
        }
    }
    
    public func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, headerHeightInSection section: Int) -> CGFloat {
        return kPostHeaderViewHeight
    }
    
    public func updateCellHeight(index: Int, height: CGFloat) {
        cellHeights[index] += height
    }
    
    private func computeExpectedCellHeight(index: Int, width: CGFloat) -> CGFloat {
        if let item = config[index] {
            config.configureCell(sizingCell, item: item)
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            let size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            let photoWidth = CGFloat(item.photoWidth)
            var photoHeight = CGFloat(item.photoHeight)
            photoHeight = computeExpectedPhotoHeight(width, photoWidth: photoWidth, photoHeight: photoHeight)
            return size.height + photoHeight
        }
        return 0
    }
    
    private func computeExpectedPhotoHeight(maxWidth: CGFloat, photoWidth: CGFloat, photoHeight: CGFloat) -> CGFloat {
        let ratio = maxWidth / photoWidth
        let height = CGFloat(photoHeight * ratio)
        return  height
    }
}
