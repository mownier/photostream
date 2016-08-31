//
//  PostGridCellDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

public class PostGridCellDelegate: NSObject, MONUniformFlowLayoutDelegate {

    private let kColumnCount: UInt = 3
    private let actionHandler: PostGridCellActionHandler

    public var scrollProtocol: PostCellLoaderScrollProtocol?

    init(actionHandler: PostGridCellActionHandler) {
        self.actionHandler = actionHandler
    }

    public func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        return collectionView.width / CGFloat(kColumnCount)
    }

    public func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, numberOfColumnsInSection section: Int) -> UInt {
        return kColumnCount
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        actionHandler.postGridCellWillShowPostDetails(indexPath.row)
    }
}

extension PostGridCellDelegate: PostCellLoaderDelegateProtocol {

    public func recalculateCellHeight() {

    }

    public func updateCellHeight(index: Int, height: CGFloat) {

    }
}

extension PostGridCellDelegate {

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollProtocol?.willBeginDragging(scrollView)
    }

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollProtocol?.didScroll(scrollView)
    }
}
