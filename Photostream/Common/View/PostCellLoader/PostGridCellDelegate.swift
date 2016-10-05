//
//  PostGridCellDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

open class PostGridCellDelegate: NSObject, MONUniformFlowLayoutDelegate {

    fileprivate let kColumnCount: UInt = 3
    fileprivate let actionHandler: PostGridCellActionHandler

    open var scrollProtocol: PostCellLoaderScrollProtocol?

    init(actionHandler: PostGridCellActionHandler) {
        self.actionHandler = actionHandler
    }

    open func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        return collectionView.width / CGFloat(kColumnCount)
    }

    open func collectionView(_ collectionView: UICollectionView!, layout: MONUniformFlowLayout!, numberOfColumnsInSection section: Int) -> UInt {
        return kColumnCount
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        actionHandler.postGridCellWillShowPostDetails((indexPath as NSIndexPath).row)
    }
}

extension PostGridCellDelegate: PostCellLoaderDelegateProtocol {

    public func recalculateCellHeight() {

    }

    public func updateCellHeight(_ index: Int, height: CGFloat) {

    }
}

extension PostGridCellDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollProtocol?.willBeginDragging(scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollProtocol?.didScroll(scrollView)
    }
}
