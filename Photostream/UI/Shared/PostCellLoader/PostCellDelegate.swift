//
//  PostCellDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//x

import UIKit
import MONUniformFlowLayout

open class PostCellDelegate: NSObject, MONUniformFlowLayoutDelegate, PostCellLoaderDelegateProtocol {

    open var config: PostCellConfiguration!
    open var dataSource: PostCellLoaderDataSourceProtocol!
    open var scrollProtocol: PostCellLoaderScrollProtocol?
    fileprivate var sizingCell: PostCell
    fileprivate var cellHeights: [CGFloat]

    override init() {
        let bundle = Bundle.main
        let views = bundle.loadNibNamed(kPostCellNibName, owner: nil, options: nil)
        self.sizingCell = views?[0] as! PostCell
        self.cellHeights = [CGFloat]()
    }

    open func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        if cellHeights.isValid(section) {
            return cellHeights[section]
        } else {
            let height = computeExpectedCellHeight(section, width: collectionView.width)
            cellHeights.append(height)
            return height
        }
    }

    open func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, headerHeightInSection section: Int) -> CGFloat {
        return kPostHeaderViewHeight
    }

    open func updateCellHeight(_ index: Int, height: CGFloat) {
        cellHeights[index] += height
    }

    open func recalculateCellHeight() {
        cellHeights.removeAll()
    }

    fileprivate func computeExpectedCellHeight(_ index: Int, width: CGFloat) -> CGFloat {
        if let item = dataSource[index] as? PostCellItem {
            config.configureCell(sizingCell, item: item)
            sizingCell.bounds = CGRect(x: 0, y: 0, width: width, height: sizingCell.bounds.height)
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
               height += sizingCell.messageLabel.intrinsicContentSize.height
            }

            height -= kPostCellInitialPhotoHeight
            return height + pHeight
        }
        return 0
    }

    fileprivate func computeExpectedPhotoHeight(_ maxWidth: CGFloat, photoWidth: CGFloat, photoHeight: CGFloat) -> CGFloat {
        let ratio = maxWidth / photoWidth
        let height = CGFloat(photoHeight * ratio)
        return  height
    }
}

extension PostCellDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollProtocol?.willBeginDragging(scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollProtocol?.didScroll(scrollView)
    }
}
