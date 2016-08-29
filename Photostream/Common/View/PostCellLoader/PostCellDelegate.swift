//
//  PostCellDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//x

import UIKit
import MONUniformFlowLayout

public class PostCellDelegate: NSObject, MONUniformFlowLayoutDelegate, PostCellLoaderDelegateProtocol {

    public var config: PostCellConfiguration!
    public var dataSource: PostCellLoaderDataSourceProtocol!
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
    
    public func recalculateCellHeight() {
        cellHeights.removeAll()
    }
    
    private func computeExpectedCellHeight(index: Int, width: CGFloat) -> CGFloat {
        if let item = dataSource[index] as? PostCellItem {
            config.configureCell(sizingCell, item: item)
            sizingCell.bounds = CGRectMake(0, 0, width, sizingCell.bounds.height)
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            sizingCell.sizeToFit()

            let photoWidth = CGFloat(item.photoWidth)
            let photoHeight = CGFloat(item.photoHeight)
            let pHeight = computeExpectedPhotoHeight(width, photoWidth: photoWidth, photoHeight: photoHeight)
//            let size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//            return size.height + pHeight
            
            var height = kPostCellInitialHeight
            if item.likesCount == 0 {
                height -= (kPostCellCommonTop + kPostCellCommonHeight)
            }
            if item.commentsCount == 0 {
                height -= (kPostCellCommonTop + kPostCellCommonHeight)
            }
            
            height -= (kPostCellCommonTop + kPostCellCommonHeight)
            if !item.message.isEmpty {
               height += sizingCell.messageLabel.intrinsicContentSize().height
            }
            
            height -= kPostCellInitialPhotoHeight
            return height + pHeight
        }
        return 0
    }
    
    private func computeExpectedPhotoHeight(maxWidth: CGFloat, photoWidth: CGFloat, photoHeight: CGFloat) -> CGFloat {
        let ratio = maxWidth / photoWidth
        let height = CGFloat(photoHeight * ratio)
        return  height
    }
}
