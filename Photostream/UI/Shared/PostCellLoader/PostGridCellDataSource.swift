//
//  PostGridCellDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

open class PostGridCellDataSource: NSObject, PostCellLoaderDataSourceProtocol {

    fileprivate var items: PostGridCellItemArray

    init(items: PostGridCellItemArray) {
        self.items = items
    }

    open func appendContentsOf(_ array: PostGridCellItemArray) {
        items.appendContentsOf(array)
    }

    open subscript(index: Int) -> PostCellDisplayItemProtocol? {
        set {
            if let val = newValue as? PostGridCellItem {
                items[index] = val
            }
        }
        get {
            return items[index]
        }
    }

    open subscript(postId: String) -> (Int, PostCellDisplayItemProtocol)? {
        if let index = items[postId] {
           return (index, items[index]!)
        }
        return nil
    }
}

extension PostGridCellDataSource: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPostGridCellReuseId, for: indexPath) as! PostGridCell
        if let item = items[(indexPath as NSIndexPath).row] {
            configureCell(cell, item: item)
        }
        return cell
    }
}

extension PostGridCellDataSource: PostGridCellConfiguration {

    public func configureCell(_ cell: PostGridCell, item: PostGridCellItem) {
        cell.setPhotoUrl(item.photoUrl, placeholderImage: nil)
    }
}
